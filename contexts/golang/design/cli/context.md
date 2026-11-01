# Golang CLI Design Guide

## Purpose

This guide defines the p3bot architecture, patterns, and conventions for building command-line tools in Go. It is derived from production CLIs and targets AI agents tasked with scaffolding or building new CLI projects.

This guide is the Go implementation of the p3bot CLI design guide. Load that guide first with `start get contexts:cli/design`; rule numbers cited here refer to it. Where this guide departs from it, it says so and why.

Follow this guide when creating a new Go CLI. Deviate only when the domain demands it, and document why.

Sections that open with "Applies when:" apply only when that condition holds; skip them otherwise, including their MUST rules. Every other section applies to every CLI.

Code examples are written to be copied. Their comments are the ones the generated code should keep: none unless the why is non-obvious, one short line, and a godoc summary on every exported type, function, constant group, and variable. Methods that only satisfy a standard interface, such as `Error` and `Unwrap`, need none. Explanations for the reader live in the prose around each example.

## Project Layout

Follow the standard Go project layout. The structure below shows the recommended internal packages for CLI tools.

```none
<project>/
├── cmd/<name>/
│   └── main.go
├── internal/
│   ├── cli/
│   ├── api/
│   ├── config/
│   ├── tui/
│   ├── skill/
│   ├── width/
│   └── <domain>/
├── testdata/
├── scripts/
├── docs/
├── go.mod
├── go.sum
├── .golangci.yml
├── LICENSE
└── README.md
```

Package purposes:

- cmd/name/main.go — Minimal entry point. Delegates everything to internal/cli
- internal/cli/ — Cobra root command, subcommands, output helpers, exit codes
- internal/api/ — HTTP client, authentication, pagination, error types
- internal/config/ — Environment variable loading, validation, fallback chains
- internal/tui/ — Terminal colour constants, formatting helpers, progress indicators
- internal/skill/ — Embedded SKILL.md and agentdex-backed install, when the CLI ships an agent skill (see "Agent Skill")
- internal/width/ — Unicode display width for aligned output (optional, add when cells may hold wide characters; see "Aligned Output")
- internal/domain/ — Domain-specific packages as needed (e.g. converter, models, jira)

Not every CLI needs every package. A simple CLI might only need `cli/` and `config/`. Add packages as complexity demands.

Note: `testdata/` at the project root holds test fixtures (JSON responses, sample files). `scripts/` holds manual and integration test scripts.

## Entry Point

cmd/name/main.go is minimal. It calls cli.Execute() and exits with the appropriate code. Execute has already emitted every error.

```go
package main

import (
	"os"

	"<module>/internal/cli"
)

func main() {
	err := cli.Execute()
	if code := cli.SignalExitCode(); code != 0 {
		os.Exit(code)
	}
	if err != nil {
		os.Exit(cli.ExitCodeFromError(err))
	}
}
```

Rules:

- No application logic in main
- No flag parsing in main
- No configuration loading in main
- No error printing in main
- The only responsibilities are: run, exit

`SignalExitCode` is checked first (see "Signal Handling"). Every other error has passed the error boundary in `Execute` (see "Error Boundary"), so it is already on stderr, or in the envelope under `--json`.

## CLI Architecture

### Root Command

The root command lives in `internal/cli/root.go`. It defines global flags, command groups, and the `Execute()` function.

```go
package cli

import (
	"context"
	"encoding/json"
	"errors"
	"os"
	"os/signal"
	"runtime/debug"
	"strings"
	"sync/atomic"
	"syscall"

	"github.com/fatih/color"
	"github.com/spf13/cobra"
)

// Version is set at build time with -ldflags; resolvedVersion falls back to the module version.
var Version = "dev"

func resolvedVersion() string {
	if Version != "dev" {
		return Version
	}
	if info, ok := debug.ReadBuildInfo(); ok && info.Main.Version != "" && info.Main.Version != "(devel)" {
		return info.Main.Version
	}
	return Version
}

var rootCmd = &cobra.Command{
	Use:           "<name>",
	Short:         "One-line description",
	Version:       resolvedVersion(),
	SilenceUsage:  true,
	SilenceErrors: true,
	Args:          usageArgs(cobra.NoArgs),
	RunE: func(cmd *cobra.Command, args []string) error {
		return cmd.Help()
	},
}

var (
	jsonOutput   bool
	verbose      bool
	debugLogging bool
	quiet        bool
	noInput      bool
	colorMode    string
)

func init() {
	rootCmd.PersistentFlags().BoolVar(&jsonOutput, "json", false, "Emit a JSON envelope on stdout")
	rootCmd.PersistentFlags().BoolVar(&verbose, "verbose", false, "Add detail to stdout output")
	rootCmd.PersistentFlags().BoolVar(&debugLogging, "debug", false, "Diagnostic logging to stderr")
	rootCmd.PersistentFlags().BoolVar(&quiet, "quiet", false, "Suppress non-essential output")
	rootCmd.PersistentFlags().BoolVar(&noInput, "no-input", false, "Never prompt; fail fast on missing required input")
	rootCmd.PersistentFlags().StringVar(&colorMode, "color", "auto", "Colour output: auto, always, never")
	rootCmd.SetFlagErrorFunc(flagUsageError)
}

var caughtSignal atomic.Int32

// Execute runs the root command with a context cancelled by SIGINT or SIGTERM.
func Execute() error {
	return execute(os.Args[1:])
}

func execute(args []string) error {
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	sigCh := make(chan os.Signal, 1)
	signal.Notify(sigCh, os.Interrupt, syscall.SIGTERM)
	defer func() {
		signal.Stop(sigCh)
		close(sigCh)
	}()
	go func() {
		if sig, ok := <-sigCh; ok {
			caughtSignal.Store(int32(sig.(syscall.Signal)))
			signal.Stop(sigCh)
			cancel()
		}
	}()

	rootCmd.SetArgs(args)
	rootCmd.SetOut(stdout)
	rootCmd.SetErr(stderr)
	err := rootCmd.ExecuteContext(ctx)
	if err == nil || IsPrintedError(err) || SignalExitCode() != 0 {
		return err
	}
	var usage *usageError
	if errors.As(err, &usage) {
		// Parsing stopped before PersistentPreRunE, and before any --json after the bad argument.
		jsonOutput = jsonOutput || jsonRequested(args)
		color.NoColor = !decorates(os.Stderr)
	}
	return outputErr(payloadFor(err))
}

// SignalExitCode returns 128+signum if Execute was interrupted, or 0.
// signal.NotifyContext alone cannot do this: cancellation surfaces as context.Canceled.
func SignalExitCode() int {
	if s := caughtSignal.Load(); s != 0 {
		return 128 + int(s)
	}
	return 0
}
```

`SilenceUsage` and `SilenceErrors` stop Cobra from printing usage and errors itself; the error boundary in `Execute` emits them instead.

`RunE: cmd.Help()` makes root runnable so cobra renders the full help template (Usage + Flags), not just `Long`. `Args: usageArgs(cobra.NoArgs)` rejects stray positionals and unknown subcommands as usage errors (see "Error Boundary").

`Execute` is the error boundary: an error no command emitted is converted and emitted here, so no failure reaches `main` without a payload. `execute` takes the arguments explicitly so tests drive the same path, and closing the signal channel on return ends the signal goroutine.

Under `--json`, help and `--version` emit the envelope (cli/design Rule 3). Cobra prints the version before any run hook, so the version template decides; `cmd.Help()` goes through the help function:

```go
func init() {
	defaultHelp := rootCmd.HelpFunc()
	rootCmd.SetHelpFunc(func(c *cobra.Command, args []string) {
		if !jsonOutput {
			defaultHelp(c, args)
			return
		}
		var b strings.Builder
		prev := c.OutOrStdout()
		c.SetOut(&b)
		defaultHelp(c, args)
		c.SetOut(prev)
		_ = outputJSON(Envelope{Status: StatusOK, Data: map[string]string{"help": b.String()}})
	})
	cobra.AddTemplateFunc("versionText", versionText)
	rootCmd.SetVersionTemplate("{{"{{"}}versionText .Version}}")
}

func versionText(v string) string {
	if !jsonOutput {
		return rootCmd.Name() + " version " + v + "\n"
	}
	data, _ := json.MarshalIndent(Envelope{Status: StatusOK, Data: map[string]string{"version": v}}, "", "  ")
	return string(data) + "\n"
}
```

### Runtime Modes

Interactive mode and decoration mode (cli/design, "TTY detection and environment signals") are detected once in `PersistentPreRunE` and exposed via accessor functions matching the `JSONOutput()` pattern.

The modes are orthogonal: a piped invocation may still be interactive, and stderr may be decorated while stdout is not.

```go
import (
	"os"
	"strings"

	"github.com/fatih/color"
	"golang.org/x/term"
)

var (
	interactive     bool
	stdoutDecorated bool
	stderrDecorated bool
)

func detectModes() error {
	// An unknown --color value decorates as auto, so the INVALID_COLOR error below is coloured for stderr.
	stdoutDecorated = decorates(os.Stdout)
	stderrDecorated = decorates(os.Stderr)
	// The tui colours write only to stderr; stdout emphasis checks StdoutDecorated.
	color.NoColor = !stderrDecorated

	switch colorMode {
	case "auto", "always", "never":
	default:
		return outputErr(&ErrorPayload{
			Code:        "INVALID_COLOR",
			Message:     "--color must be one of: auto, always, never",
			Fix:         "<cli> --color=auto",
			ValidValues: []string{"auto", "always", "never"},
		})
	}

	noInputEnv, err := envBool("<CLI>_NO_INPUT")
	if err != nil {
		return err
	}
	interactive = term.IsTerminal(int(os.Stdin.Fd())) && !noInput && !jsonOutput && !noInputEnv

	if !debugLogging {
		dbg, err := envBool("<CLI>_DEBUG")
		if err != nil {
			return err
		}
		debugLogging = dbg
	}

	return nil
}

func decorates(f *os.File) bool {
	switch {
	case colorMode == "always":
		return true
	case colorMode == "never", os.Getenv("NO_COLOR") != "":
		return false
	case os.Getenv("FORCE_COLOR") != "", os.Getenv("CLICOLOR_FORCE") != "":
		return true
	case os.Getenv("TERM") == "dumb":
		return false
	default:
		return term.IsTerminal(int(f.Fd()))
	}
}

// Interactive reports whether prompts are allowed.
func Interactive() bool { return interactive }

// StdoutDecorated reports whether ANSI escapes may reach stdout; the --json envelope never carries them.
func StdoutDecorated() bool { return stdoutDecorated && !jsonOutput }

// StderrDecorated reports whether ANSI escapes may reach stderr.
func StderrDecorated() bool { return stderrDecorated }

// Animated reports whether spinners and progress indicators may run on stderr.
func Animated() bool {
	return stderrDecorated && !quiet && term.IsTerminal(int(os.Stderr.Fd()))
}
```

`detectModes` resolves decoration before anything else can call `outputErr`, so errors never carry ANSI when the user asked for `--color=never`.

`decorates` reads the colour variables with a non-empty check, not `envBool`: they are not CLI-owned and follow their own specs.

```go
// Strict because the CLI owns these variables: a typo must fail, not read as false.
func envBool(name string) (bool, error) {
	raw, ok := os.LookupEnv(name)
	if !ok {
		return false, nil
	}
	switch strings.ToLower(strings.TrimSpace(raw)) {
	case "", "0", "false", "no":
		return false, nil
	case "1", "true", "yes":
		return true, nil
	default:
		return false, outputErr(&ErrorPayload{
			Code:        "CONFIG_INVALID",
			Message:     name + " has invalid value (expected one of: 1, 0, true, false, yes, no)",
			Fix:         "unset " + name + " or set to 1/true/yes/0/false/no",
			ValidValues: []string{"1", "0", "true", "false", "yes", "no"},
		})
	}
}
```

Wire `detectModes` into `rootCmd.PersistentPreRunE` so every subcommand sees consistent values. By default cobra runs only the nearest persistent hook, so a subcommand's own `PersistentPreRunE` would silently skip root's. `EnableTraverseRunHooks` (cobra 1.8 or later) runs every ancestor's hook, root first, so subcommands may add their own setup:

```go
func init() {
	cobra.EnableTraverseRunHooks = true
	rootCmd.PersistentPreRunE = func(cmd *cobra.Command, args []string) error {
		return detectModes()
	}
}
```

Callers check `Interactive()` before prompting, `StdoutDecorated()` or `StderrDecorated()` before emitting ANSI, and `Animated()` before animating.

### One File Per Command

Each command lives in its own file. Name files after the command hierarchy: `noun.go` for parent commands, `noun_verb.go` for subcommands.

```none
internal/cli/
├── root.go
├── envelope.go
├── exitcodes.go
├── skill.go
├── completion.go
├── item.go              # Parent: defines "item" command
├── item_list.go         # Subcommand: item list
├── item_create.go       # Subcommand: item create
├── item_get.go          # Subcommand: item get  (alias: view)
├── page.go              # Parent: defines "page" command
├── page_list.go
├── page_create.go
└── page_get.go          # Subcommand: page get  (alias: view)
```

Each file contains:

1. Package-level flag variables for that command
2. A cobra.Command variable definition
3. An init function that registers flags and adds the command to its parent
4. A run function matching runCommandName(cmd, args) returning error

```go
package cli

import "github.com/spf13/cobra"

var (
	itemListLimit  int
	itemListStatus string
)

var itemListCmd = &cobra.Command{
	Use:     "list <project>",
	Aliases: []string{"ls"},
	Short:   "List items",
	Args:    usageArgs(cobra.ExactArgs(1)),
	RunE:    runItemList,
}

func init() {
	itemListCmd.Flags().IntVarP(&itemListLimit, "limit", "l", 25, "Maximum results")
	itemListCmd.Flags().StringVar(&itemListStatus, "status", "", "Filter by status")
	itemCmd.AddCommand(itemListCmd)
}

func runItemList(cmd *cobra.Command, args []string) error {
	// Implementation
	return nil
}
```

The parent command carries the plural alias and renders help when run bare:

```go
var itemCmd = &cobra.Command{
	Use:     "item",
	Aliases: []string{"items"},
	Short:   "Manage items",
	Args:    usageArgs(cobra.NoArgs),
	RunE: func(cmd *cobra.Command, args []string) error {
		return cmd.Help()
	},
}

func init() {
	rootCmd.AddCommand(itemCmd)
}
```

Rules:

- Always use `RunE`, never `Run` — commands return errors, never call `os.Exit`
- Validate positionals with `usageArgs(cobra.ExactArgs(N))` or `usageArgs(cobra.NoArgs)`, so a wrong count is a usage error; `cobra.ArbitraryArgs` never fails and needs no wrapper
- Give parent commands `Args: usageArgs(cobra.NoArgs)` and `RunE: cmd.Help()` like root; without them, `tool item bogus` prints help and exits 0
- Prefix flag variables with the command name to avoid collisions (e.g. `itemListLimit`, not `limit`)
- Register commands in `init()` — this keeps the command tree declarative

### Command Groups

Organise commands into logical groups using Cobra's `AddGroup` for better help output.

```go
func init() {
	rootCmd.AddGroup(
		&cobra.Group{ID: "commands", Title: "Commands:"},
		&cobra.Group{ID: "utilities", Title: "Utilities:"},
	)
}
```

Assign commands to groups via `GroupID` in the command definition.

## Command Design

### Hierarchy

Commands take the `noun verb` shape of cli/design Rule 9:

```none
tool item list --status "Open"
tool item create --subject "Summary" --type Bug
tool page get 12345 --json
```

### Self-Describing Commands

Every command must have `Short` and `Long` descriptions. Include `Example` blocks for non-trivial commands.

```go
var itemCreateCmd = &cobra.Command{
	Use:   "create",
	Short: "Create a new item",
	Long:  "Create a new item in the specified project with the given summary, type, and priority.",
	Example: `  tool item create --subject "Fix login bug"
  tool item create --subject "Add feature" --type Story --description "Description"
  echo "Description" | tool item create --subject "From stdin" --file -`,
	RunE: runItemCreate,
}
```

Required, not decoration: `--help` is the flag reference for agents and humans (cli/design Rule 10).

### Aliases

Register each name in Rule 9's "Never as canonical" verb column as a Cobra `Aliases` entry on its canonical command, and the other noun form on each parent command (see the `itemCmd` example). Cobra lists aliases in `--help`; the skill lists canonicals only.

### Input Methods

Applies when: the command accepts content (text, a file, or piped data).

Content arrives only through an explicit channel:

- Positional arguments for short values
- `--file <file>` for file input
- `--file -` for stdin

`readInput` reads stdin only for `--file -` (cli/design Rule 1).

```go
func readInput(cmdPath string, args []string, flagFile string) ([]byte, error) {
	switch {
	case flagFile == "-":
		return io.ReadAll(os.Stdin)
	case flagFile != "":
		return os.ReadFile(flagFile)
	case len(args) > 0:
		return []byte(strings.Join(args, " ")), nil
	default:
		return nil, outputErr(&ErrorPayload{
			Code:    "INPUT_REQUIRED",
			Message: "content required",
			Fix:     cmdPath + " <text> | --file <file> | --file -",
		})
	}
}
```

In interactive mode a command may prompt for the content instead of failing (cli/design Rule 1).

### Mutation Safety

Applies when: the command creates, updates, or deletes state.

Mutations follow cli/design Rule 8. A `delete` of a deleted resource passes an `ALREADY_DELETED` `WarningPayload` to `outputData`; `--yes` reaches `--force` through `flagAliases` (see "Aliases" under Global Flags).

```go
func runItemCreate(cmd *cobra.Command, args []string) error {
	req := buildCreateRequest()

	existing, err := client.GetItemByKey(cmd.Context(), req.Key)
	if err != nil && !errors.Is(err, api.ErrNotFound) {
		return err
	}
	if err == nil {
		if matchesRequest(existing, req) {
			return outputData(newRecord(itemFields, existing, itemValues).With("existing", true))
		}
		return outputErr(&ErrorPayload{
			Code:    "CONFLICT",
			Message: fmt.Sprintf("item %s exists with different fields", req.Key),
			Fix:     fmt.Sprintf("<cli> item update %s ...", req.Key),
		})
	}

	created, err := client.CreateItem(cmd.Context(), req)
	if err != nil {
		return err
	}
	return outputData(newRecord(itemFields, created, itemValues))
}
```

`matchesRequest` skips request fields left nil, so only the fields the caller supplied are compared. The response is the item's record, so an agent reads an existing match exactly as it reads a fresh create, plus `existing: true`.

### Dry Run

Applies when: the command makes a consequential mutation.

`--dry-run` follows cli/design Rule 8:

```go
var itemCreateDryRun bool

func init() {
	itemCreateCmd.Flags().BoolVar(&itemCreateDryRun, "dry-run", false,
		"Validate and describe the change without applying it")
	// ... other flags
	itemCmd.AddCommand(itemCreateCmd)
}

func runItemCreate(cmd *cobra.Command, args []string) error {
	req := buildCreateRequest()

	if itemCreateDryRun {
		return outputData(newRecord(itemFields, req, createRequestValues).With("dry_run", true))
	}

	// ... actual create
}
```

`createRequestValues` maps the request to the same field names as `itemValues`.

## Global Flags

### Standard Set

Persistent root flags: `--json`, `--verbose`, `--debug`, `--quiet`, `--no-input`, `--color`.

Register every other Rule 9 flag on the commands whose capability needs it; `--timeout` uses the `Duration` type (see "Duration Flags").

`--json`, `--no-input`, `--color`, and `--quiet` belong on every CLI; `--verbose` and `--debug` when the CLI has detail or diagnostics to add.

Optional persistent flags. Add one only when the CLI has the capability:

| Flag | When |
| --- | --- |
| `--profile <name>` | The CLI supports profiles (see "Profiles") |
| `--config <path>` | The CLI reads a config file (see "User Config") |

### Aliases

Non-canonical flag names MAY alias their canonical for muscle memory or backward compatibility, when both perform the same operation. pflag's only mechanism is name normalisation, applied to every command from root:

```go
var flagAliases = map[string]string{
	"yes":             "force",
	"non-interactive": "no-input",
	"plan":            "dry-run",
	"simulate":        "dry-run",
	"max-results":     "limit",
	"out":             "output",
	"block":           "wait",
}

func init() {
	rootCmd.SetGlobalNormalizationFunc(func(f *pflag.FlagSet, name string) pflag.NormalizedName {
		if canonical, ok := flagAliases[name]; ok {
			name = canonical
		}
		return pflag.NormalizedName(name)
	})
}
```

Normalised names never appear in `--help`, so name each alias in its canonical flag's usage text (`"Bypass confirmation (alias: --yes)"`). The skill lists canonicals only.

Not every Never-column name can alias. `--page` takes a page number, not a cursor, so it cannot alias `--next`. `--no-color` takes no value, so it cannot alias `--color=never`; the enum flag replaces it.

### Accessor Functions

Export flag state through functions, not variables.

```go
// JSONOutput reports whether --json is set.
func JSONOutput() bool { return jsonOutput }

// Quiet reports whether --quiet is set.
func Quiet() bool { return quiet }

// Debug reports whether --debug or <CLI>_DEBUG is set.
func Debug() bool { return debugLogging }
```

### Duration Flags

Every user-facing duration (`--timeout`, `--older-than`, `--since` and `--until` in relative form) uses the duration grammar of cli/design "Duration values". Never register one with `DurationVar`: `time.ParseDuration` rejects `7d` and accepts `1.5h`, `300ms`, and `30m1h`, which the grammar forbids.

```go
// Duration is a flag value in the duration grammar: 30s, 5m, 1h30m, 7d, or 0.
type Duration time.Duration

func (d *Duration) Set(s string) error {
	v, err := parseDuration(s)
	if err != nil {
		return err
	}
	*d = Duration(v)
	return nil
}

func (d *Duration) String() string { return formatDuration(time.Duration(*d)) }

func (d *Duration) Type() string { return "duration" }

type durationUnit struct {
	suffix byte
	size   time.Duration
}

var durationUnits = []durationUnit{
	{'d', 24 * time.Hour},
	{'h', time.Hour},
	{'m', time.Minute},
	{'s', time.Second},
}

func parseDuration(s string) (time.Duration, error) {
	if s == "0" {
		return 0, nil
	}
	bad := fmt.Errorf("invalid duration %q: use whole-number segments in d, h, m, s order, each once (30s, 1h30m, 7d)", s)
	if s == "" {
		return 0, bad
	}
	var total time.Duration
	allowed := durationUnits
	for rest := s; rest != ""; {
		i := strings.IndexFunc(rest, func(r rune) bool { return r < '0' || r > '9' })
		if i <= 0 {
			return 0, bad
		}
		n, err := strconv.Atoi(rest[:i])
		if err != nil || n == 0 {
			return 0, bad
		}
		u := slices.IndexFunc(allowed, func(x durationUnit) bool { return x.suffix == rest[i] })
		if u < 0 || time.Duration(n) > (math.MaxInt64-total)/allowed[u].size {
			return 0, bad
		}
		total += time.Duration(n) * allowed[u].size
		allowed = allowed[u+1:]
		rest = rest[i+1:]
	}
	return total, nil
}

// Rounds up to whole seconds, so a short positive wait never renders as "0" (no limit).
func formatDuration(d time.Duration) string {
	if d <= 0 {
		return "0"
	}
	d = (d + time.Second - 1).Truncate(time.Second)
	var b strings.Builder
	for _, u := range durationUnits {
		if n := d / u.size; n > 0 {
			fmt.Fprintf(&b, "%d%c", n, u.suffix)
			d -= n * u.size
		}
	}
	return b.String()
}
```

A bad value fails inside pflag, so it reaches the error boundary as `INVALID_ARGUMENT` (exit 2). Cover the grammar with a table test: `30s`, `1h30m`, `7d`, `2d12h`, and `0` parse; `1.5h`, `30m1h`, `1h2h`, `300ms`, `0s`, `5`, `106752d` (past `time.Duration`'s range), and the empty string fail.

## Output Design

### Modes

Text by default; the JSON envelope under `--json` (cli/design Rules 2 and 3).

### Output Helpers

Define typed envelope structs in `internal/cli/envelope.go`. Every `--json` response uses the same outer shape so callers parse once and branch on `Status`.

```go
// Status discriminates success from failure in an Envelope.
type Status string

// Envelope statuses.
const (
	StatusOK    Status = "ok"
	StatusError Status = "error"
)

// Envelope is the single stdout document emitted under --json.
type Envelope struct {
	Status   Status           `json:"status"`
	Data     any              `json:"data,omitempty"`
	Error    *ErrorPayload    `json:"error,omitempty"`
	Warnings []WarningPayload `json:"warnings,omitempty"`
	Next     string           `json:"next,omitempty"`
}

// ErrorPayload describes a failure in terms an agent can act on.
type ErrorPayload struct {
	Code        string   `json:"code"`
	Message     string   `json:"message"`
	Fix         string   `json:"fix"`
	ValidValues []string `json:"valid_values,omitempty"`
	RetryAfter  string   `json:"retry_after,omitempty"`
	ExitCode    int      `json:"-"` // a domain code's exit code; canonical codes ignore it
}

// WarningPayload is a non-fatal condition reported alongside a success.
type WarningPayload struct {
	Code       string `json:"code"`
	Message    string `json:"message"`
	Fix        string `json:"fix,omitempty"`
	RetryAfter string `json:"retry_after,omitempty"`
}
```

Define these helpers in `root.go` or a shared file within `internal/cli/`:

```go
// Tests swap these to capture output.
var (
	stdout io.Writer = os.Stdout
	stderr io.Writer = os.Stderr
)

func outputData(v any, warnings ...WarningPayload) error {
	if JSONOutput() {
		if v == nil {
			v = json.RawMessage("null") // omitempty would drop data, and a success always carries it
		}
		env := Envelope{Status: StatusOK, Data: v, Warnings: warnings}
		if p, ok := v.(interface{ NextCursor() string }); ok {
			env.Next = p.NextCursor()
		}
		return outputJSON(env)
	}
	if err := renderText(stdout, v); err != nil {
		return fmt.Errorf("render: %w", err)
	}
	for _, w := range warnings {
		outputWarning(w.Message)
	}
	return nil
}

func outputErr(p *ErrorPayload) error {
	if JSONOutput() {
		// An ErrorPayload holds only strings, bools, and ints, so encoding cannot fail.
		_ = outputJSON(Envelope{Status: StatusError, Error: p})
	} else {
		labels, values := []string{"Code"}, []string{p.Code}
		if len(p.ValidValues) > 0 {
			labels, values = append(labels, "Accepted"), append(values, strings.Join(p.ValidValues, ", "))
		}
		if p.RetryAfter != "" {
			labels, values = append(labels, "Retry after"), append(values, p.RetryAfter)
		}
		labels, values = append(labels, "Fix"), append(values, p.Fix)
		var detail strings.Builder
		_ = tui.Detail(&detail, labels, values) // a strings.Builder never fails a write
		fmt.Fprintln(stderr, tui.ColorError.Sprintf("Error: %s", p.Message))
		for _, line := range strings.Split(strings.TrimSuffix(detail.String(), "\n"), "\n") {
			fmt.Fprintln(stderr, tui.ColorDim.Sprint("  "+line))
		}
	}
	return &ExitError{
		Code: p.exitCode(),
		Err:  &printedError{msg: p.Message},
	}
}

var canonicalExit = map[string]int{
	"INVALID_ARGUMENT":    ExitUsage,
	"INPUT_REQUIRED":      ExitUsage,
	"ENV_REQUIRED":        ExitUsage,
	"OUTPUT_REQUIRED":     ExitUsage,
	"INVALID_FIELDS":      ExitUsage,
	"INVALID_COLOR":       ExitUsage,
	"BAD_REQUEST":         ExitUsage,
	"AGENT_UNKNOWN":       ExitUsage,
	"NO_SKILLS_CONCEPT":   ExitUsage,
	"NO_SKILLS_ROOT":      ExitUsage,
	"NO_AGENTS":           ExitUsage,
	"NOT_FOUND":           ExitNotFound,
	"UNAUTHENTICATED":     ExitPermission,
	"AUTH_EXPIRED":        ExitPermission,
	"PERMISSION_DENIED":   ExitPermission,
	"CONFLICT":            ExitConflict,
	"CURSOR_INVALID":      ExitConflict,
	"RATE_LIMITED":        ExitTransient,
	"UPSTREAM_ERROR":      ExitTransient,
	"WAIT_TIMEOUT":        ExitTransient,
	"CATALOG_UNAVAILABLE": ExitTransient,
	"UNKNOWN":             ExitFailure,
	"UPSTREAM_REJECTED":   ExitFailure,
	"CATALOG_INVALID":     ExitFailure,
	"CONFIG_INVALID":      ExitConfig,
}

func (p ErrorPayload) exitCode() int {
	if code, ok := canonicalExit[p.Code]; ok {
		return code
	}
	if p.ExitCode != 0 {
		return p.ExitCode
	}
	return ExitFailure
}

// MarshalJSON derives transient from the exit code, so the two cannot disagree.
func (p ErrorPayload) MarshalJSON() ([]byte, error) {
	type wire ErrorPayload
	return json.Marshal(struct {
		wire
		Transient bool `json:"transient"`
	}{wire(p), p.exitCode() == ExitTransient})
}

func outputWarning(msg string) {
	if Quiet() {
		return
	}
	fmt.Fprintln(stderr, tui.ColorWarning.Sprintf("Warning: %s", msg))
}

func outputNotice(msg string) {
	if JSONOutput() || Quiet() {
		return
	}
	fmt.Fprintln(stderr, tui.ColorWarning.Sprint(msg))
}

func outputHint(msg string) {
	if JSONOutput() || Quiet() {
		return
	}
	fmt.Fprintln(stderr, tui.ColorDim.Sprint("Hint: "+msg))
}

func outputJSON(v any) error {
	data, err := json.MarshalIndent(v, "", "  ")
	if err != nil {
		return fmt.Errorf("json marshal: %w", err)
	}
	_, err = fmt.Fprintln(stdout, string(data))
	return err
}
```

`outputData` returns render and encoding failures so they reach the error boundary rather than exiting 0 with empty output. It takes an optional warnings tail: under `--json` the warnings ride in `Envelope.Warnings`; in text mode they print to stderr after the rendered output, unless `--quiet` drops them.

`canonicalExit` mirrors the canonical codes table in cli/design Rule 5 exactly, and nothing else. Warning codes such as `ALREADY_DELETED` never reach it. A domain code (`INVALID_VISIBILITY`, `SPACE_REQUIRED`) sets `ExitCode` on its payload at the call site; without it, the code exits 1. Callers never set `transient`: `MarshalJSON` derives it, because Rule 5 makes it true exactly when the exit code is 75.

`outputNotice` and `outputHint` are stderr-only diagnostics for the human at a terminal; under `--json` or `--quiet` they are suppressed because they have no place in the envelope. Programmatic warnings (deprecated flags, partial-success conditions an agent can act on) belong in `Envelope.Warnings` and travel with the success response — accumulate them on a per-command warnings slice and pass them when calling `outputData`.

`outputWarning` is the one route for stderr warnings. Code that cannot import `internal/cli`, or runs outside a response, takes a `warn func(string)` and the CLI layer passes `outputWarning`, so `--quiet` and test capture hold everywhere.

### JSON Output

`--json` output is the envelope of cli/design Rule 3, encoded by `Envelope` (see "Output Helpers"). Field deprecations ride in `Envelope.Warnings` as `DEPRECATED_FIELD` (Rule 12).

### Text Output

Every value passed to `outputData` renders itself. Text mode calls `renderText`, which accepts a `TextRenderer`, a `[]string` (one value per line), or nil (no output), and treats anything else as a programming error:

```go
// TextRenderer is implemented by every value outputData renders in text mode.
type TextRenderer interface {
	RenderText(w io.Writer) error
}

func renderText(w io.Writer, v any) error {
	switch t := v.(type) {
	case nil:
		return nil
	case TextRenderer:
		return t.RenderText(w)
	case []string:
		for _, s := range t {
			if _, err := fmt.Fprintln(w, s); err != nil {
				return err
			}
		}
		return nil
	default:
		return fmt.Errorf("%T does not implement TextRenderer", v)
	}
}
```

Most results are a list or a single resource, so two field-selected types cover them. Both keep the `--fields` order for text and emit only the selected keys under `--json`:

```go
// Table is a list result restricted to the selected fields.
type Table struct {
	Fields []string
	Rows   []map[string]any
}

// MarshalJSON emits the rows alone.
func (t Table) MarshalJSON() ([]byte, error) { return json.Marshal(t.Rows) }

// RenderText writes the rows under a header, columns aligned.
func (t Table) RenderText(w io.Writer) error {
	cells := make([][]string, len(t.Rows))
	for i, row := range t.Rows {
		cells[i] = make([]string, len(t.Fields))
		for j, f := range t.Fields {
			cells[i][j] = textValue(row[f])
		}
	}
	return tui.Table(w, t.Fields, cells)
}

// Record is a single resource restricted to the selected fields.
type Record struct {
	Fields []string
	Values map[string]any
}

// MarshalJSON emits the values alone.
func (r Record) MarshalJSON() ([]byte, error) { return json.Marshal(r.Values) }

// RenderText writes one aligned label-value line per field.
func (r Record) RenderText(w io.Writer) error {
	values := make([]string, len(r.Fields))
	for i, f := range r.Fields {
		values[i] = textValue(r.Values[f])
	}
	return tui.Detail(w, r.Fields, values)
}

// With returns r with field set to v, appending field to the order when new.
func (r Record) With(field string, v any) Record {
	values := make(map[string]any, len(r.Values)+1)
	maps.Copy(values, r.Values)
	values[field] = v
	fields := r.Fields
	if !slices.Contains(fields, field) {
		fields = append(slices.Clip(fields), field)
	}
	return Record{Fields: fields, Values: values}
}

func newTable[T any](fields []string, items []T, values func(T) map[string]any) Table {
	rows := make([]map[string]any, len(items))
	for i, it := range items {
		rows[i] = pick(values(it), fields)
	}
	return Table{Fields: fields, Rows: rows}
}

func newRecord[T any](fields []string, item T, values func(T) map[string]any) Record {
	return Record{Fields: fields, Values: pick(values(item), fields)}
}

func pick(all map[string]any, fields []string) map[string]any {
	out := make(map[string]any, len(fields))
	for _, f := range fields {
		out[f] = all[f]
	}
	return out
}

// Empty values render empty: no null, (none), or -.
func textValue(v any) string {
	if v == nil {
		return ""
	}
	return fmt.Sprint(v)
}

// A zero time is unset, so it renders empty rather than as year 1.
func timeValue(t time.Time) any {
	if t.IsZero() {
		return nil
	}
	return t.Format(time.RFC3339)
}
```

Each resource defines its field names once, with a mapper from the API type to those names. List, get, create, and dry-run responses all share them:

```go
var itemFields = []string{"key", "summary", "status", "assignee", "priority", "created", "updated"}

func itemValues(it *api.Item) map[string]any {
	return map[string]any{
		"key":      it.Key,
		"summary":  it.Summary,
		"status":   it.Status,
		"assignee": it.Assignee,
		"priority": it.Priority,
		"created":  timeValue(it.Created),
		"updated":  timeValue(it.Updated),
	}
}
```

Mappers return plain values. A nil pointer would print as `<nil>`, so a mapper resolves it to the zero value or omits the key. A result that is neither a list nor a resource, such as a TSV report, is a small type with its own `RenderText`.

### Field Selection

Applies when: the command returns data records.

`--fields` follows cli/design Rule 6. Each command exposes a known field set, and `selectFields` rejects unknown names with `INVALID_FIELDS` and the set in `ValidValues`:

```go
var (
	itemListFields []string
	itemListNext   string
)

func init() {
	itemListCmd.Flags().StringSliceVar(&itemListFields, "fields", nil,
		"Fields to return: "+strings.Join(itemFields, ","))
	itemListCmd.Flags().StringVar(&itemListNext, "next", "", "Cursor from the previous page")
}

func runItemList(cmd *cobra.Command, args []string) error {
	selected, err := selectFields(itemListFields, itemFields)
	if err != nil {
		return err
	}
	res, err := client.ListItems(cmd.Context(), itemListStatus, itemListLimit, itemListNext)
	if err != nil {
		return err
	}
	return outputData(Page{
		Table: newTable(selected, res.Items, itemValues),
		Start: res.Start,
		Total: res.Total,
		Next:  res.Next,
	})
}

func selectFields(requested, known []string) ([]string, error) {
	if len(requested) == 0 {
		return known, nil
	}
	knownSet := make(map[string]struct{}, len(known))
	for _, f := range known {
		knownSet[f] = struct{}{}
	}
	for _, f := range requested {
		if _, ok := knownSet[f]; !ok {
			return nil, outputErr(&ErrorPayload{
				Code:        "INVALID_FIELDS",
				Message:     fmt.Sprintf("unknown field: %q", f),
				Fix:         "use one of the accepted field names",
				ValidValues: known,
			})
		}
	}
	return requested, nil
}
```

`selectFields` is generic across commands; the per-resource pieces are the `<resource>Fields` slice and its `<resource>Values` mapper (see "Text Output"). The `--fields` help names the accepted fields so agents discover the set without trial and error.

### Pagination Indicators

Applies when: the command lists results that can exceed one page.

List output follows cli/design Rule 6: the range, the total when cheap, and the cursor to advance.

```none
Showing 1-25 of 3352 results  (--next eyJvZmZzZXQiOjI1fQ)
Showing 1-12 of 12 results
```

A list result that can span pages is a `Page`: the `Table` plus where it sits in the result space. `outputData` copies `NextCursor()` into `Envelope.Next`:

```go
// Page is one page of a list result.
type Page struct {
	Table
	Start int
	Total int // -1 when counting is too expensive
	Next  string
}

// MarshalJSON emits the rows alone; the cursor rides at the envelope root.
func (p Page) MarshalJSON() ([]byte, error) { return p.Table.MarshalJSON() }

// NextCursor returns the cursor for the following page, or "" on the last page.
func (p Page) NextCursor() string { return p.Next }

// RenderText writes the table, then the range and the command to advance.
func (p Page) RenderText(w io.Writer) error {
	if err := p.Table.RenderText(w); err != nil {
		return err
	}
	_, err := fmt.Fprintln(w, pageIndicator(p.Start, len(p.Rows), p.Total, p.Next))
	return err
}

func pageIndicator(start, n, total int, next string) string {
	var b strings.Builder
	if n == 0 {
		b.WriteString("Showing 0 results")
	} else {
		fmt.Fprintf(&b, "Showing %d-%d", start, start+n-1)
		if total >= 0 {
			fmt.Fprintf(&b, " of %d", total)
		}
		b.WriteString(" results")
	}
	if next != "" {
		fmt.Fprintf(&b, "  (--next %s)", next)
	}
	return b.String()
}
```

## Agent Skill

Applies when: the CLI ships an agent skill. cli/design Rule 10 poses the question and sets the requirements.

The Go implementation is a separate guide: `start get contexts:golang/design/cli-skill`.

## Exit Codes

### Standard Codes

The taxonomy is cli/design Rule 4.

```go
// Process exit codes; document the ones a CLI uses in the skill's contract.
const (
	ExitSuccess    = 0  // Continue
	ExitFailure    = 1  // General failure; do not retry blindly
	ExitUsage      = 2  // Bad arguments; fix and retry
	ExitNotFound   = 3  // Resource not found
	ExitPermission = 4  // Permission denied; authenticate or escalate
	ExitConflict   = 5  // Resource state prevents the operation
	ExitTransient  = 75 // Retry with backoff (sysexits EX_TEMPFAIL)
	ExitConfig     = 78 // Configuration error (sysexits EX_CONFIG)
)
```

Signal exits sit outside this set (see "Signal Handling").

### ExitError Type

```go
// ExitError carries the process exit code for Err.
type ExitError struct {
	Code int
	Err  error
}

func (e *ExitError) Error() string { return e.Err.Error() }
func (e *ExitError) Unwrap() error { return e.Err }
```

### Exit Code Mapping

```go
// ExitCodeFromError returns the code of the ExitError the error boundary attached to err.
func ExitCodeFromError(err error) int {
	var exitErr *ExitError
	if errors.As(err, &exitErr) {
		return exitErr.Code
	}
	return ExitFailure
}
```

`Execute` converts every error into an `ExitError` (see "Error Boundary"), so `main` needs no other case. Mapping an error's type to a code happens once, in `payloadFor`.

Cobra's own parse errors are untyped. `usageArgs` and `flagUsageError` mark them as usage errors before they leave cobra, so an unknown command or flag exits 2 with `INVALID_ARGUMENT` (see "Error Boundary").

## Error Handling

### Error Code Conventions

Every `ErrorPayload.Code` follows cli/design Rule 5: UPPER_SNAKE_CASE, domain-bare, and a canonical code where one fits. A canonical code takes its exit code from `canonicalExit`; a domain code sets `ExitCode` (see "Output Helpers").

### Wrapping

Always wrap errors with context using `%w` for internal Go error chains:

```go
if err := client.GetPage(ctx, pageID); err != nil {
	return fmt.Errorf("getting page %s: %w", pageID, err)
}
```

`%w` is for composition between Go layers. A command that knows the right payload emits it with `outputErr` — that is where `Code`, `Fix`, and `ValidValues` are populated. Any other error returns up the chain to the error boundary in `Execute`.

### Preventing Double Output

The `printedError` type wraps errors that `outputErr` has already emitted. The error boundary checks for it before converting.

```go
type printedError struct {
	msg string
}

func (e *printedError) Error() string { return e.msg }

// IsPrintedError reports whether err was already written to stderr.
func IsPrintedError(err error) bool {
	var pe *printedError
	return errors.As(err, &pe)
}
```

`Execute` (see "Root Command") consults `IsPrintedError` before converting — that is what closes the double-output loop. Code that writes an error does it through `outputErr`, which returns the wrapped error.

### Error Boundary

Every error that no command emitted is converted once, in `Execute`, so `--json` callers always get an envelope. Commands `return err` freely; the boundary picks the payload from the error's type:

```go
// usageError is a parser-level failure: unknown command or flag, bad flag value, wrong argument count.
type usageError struct {
	cmd string
	err error
}

func (e *usageError) Error() string { return e.err.Error() }
func (e *usageError) Unwrap() error { return e.err }

// usageArgs marks a positional-argument validator's failure as a usage error.
func usageArgs(v cobra.PositionalArgs) cobra.PositionalArgs {
	return func(cmd *cobra.Command, args []string) error {
		if err := v(cmd, args); err != nil {
			return &usageError{cmd: cmd.CommandPath(), err: err}
		}
		return nil
	}
}

func flagUsageError(cmd *cobra.Command, err error) error {
	return &usageError{cmd: cmd.CommandPath(), err: err}
}

// jsonRequested finds --json in raw arguments; the last occurrence wins, as in pflag.
func jsonRequested(args []string) bool {
	found := false
	for _, a := range args {
		if a == "--" {
			break
		}
		switch {
		case a == "--json":
			found = true
		case strings.HasPrefix(a, "--json="):
			v, err := strconv.ParseBool(strings.TrimPrefix(a, "--json="))
			found = err == nil && v
		}
	}
	return found
}

func payloadFor(err error) *ErrorPayload {
	var (
		usage   *usageError
		apiErr  *api.APIError
		missing *config.MissingEnvError
		invalid *config.InvalidError
		netErr  net.Error
	)
	switch {
	case errors.As(err, &usage):
		return &ErrorPayload{Code: "INVALID_ARGUMENT", Message: err.Error(), Fix: usage.cmd + " --help"}
	case errors.As(err, &apiErr):
		p := payloadFromAPIError(apiErr)
		p.Message = err.Error()
		return p
	case errors.As(err, &missing):
		return &ErrorPayload{
			Code:    "ENV_REQUIRED",
			Message: missing.Error(),
			Fix:     "export " + strings.Join(missing.Names, "=<value> ") + "=<value>",
		}
	case errors.As(err, &invalid):
		return &ErrorPayload{Code: "CONFIG_INVALID", Message: err.Error(), Fix: "correct or remove " + invalid.Path}
	case errors.As(err, &netErr):
		return &ErrorPayload{Code: "UPSTREAM_ERROR", Message: err.Error(), Fix: "retry with backoff"}
	default:
		return &ErrorPayload{Code: "UNKNOWN", Message: err.Error(), Fix: "rerun with --debug for details"}
	}
}
```

A usage error can fire before `--json` is parsed: pflag stops at the first bad flag, and `Args` validation runs before `PersistentPreRunE`. `Execute` therefore recovers `--json` with `jsonRequested` and sets the error colour from `decorates(os.Stderr)` before emitting.

The API case keeps the whole chain's message, so `%w` context (`getting page 123: ...`) survives into the payload. `UNKNOWN` is the fallback for an error with no known type. It exits 1, and a recurring one is a sign that a command should emit its own payload. A signal-terminated run skips conversion: its exit code is the signal's (see "Signal Handling").

When a new error type crosses package boundaries (as `MissingEnvError` and `InvalidError` do from `internal/config`), add its case here rather than converting it at each call site.

### Actionable Messages

Rule 5 sets what every payload carries. The error boundary and the API mapping supply generic fixes; a command that knows the specific next step emits its own payload, and sets `ExitCode` when its code is a domain code.

```go
// Good — structured, populates code/fix/valid_values; domain codes set their exit code
return outputErr(&ErrorPayload{
	Code:     "SPACE_REQUIRED",
	Message:  "space key required",
	Fix:      "<cli> page list --space <KEY>  (or set CONFLUENCE_SPACE_KEY)",
	ExitCode: ExitUsage,
})

return outputErr(&ErrorPayload{
	Code:        "INVALID_VISIBILITY",
	Message:     "--visibility must be one of: public, private, unlisted",
	Fix:         "<cli> post create --visibility=public --content=...",
	ValidValues: []string{"public", "private", "unlisted"},
	ExitCode:    ExitUsage,
})

// Bad — no code, no fix, no machine-readable shape
return fmt.Errorf("missing space key")
```

### Rate Limiting

Applies when: the CLI calls a service that rate-limits.

`RATE_LIMITED` follows cli/design Rule 5. Copy the upstream `Retry-After` into `RetryAfter` in the duration grammar:

```go
return outputErr(&ErrorPayload{
	Code:       "RATE_LIMITED",
	Message:    "API rate limit exceeded",
	Fix:        "wait and retry",
	RetryAfter: "30s",
})
```

## Configuration

Configuration is layered. Environment variables, profiles, and the user and system config files each occupy a tier in a precedence chain. Resolve every setting through the same chain at startup.

### Precedence

The chain is cli/design's "Configuration precedence": flag, env, `--profile`, active profile, user config file (or `--config <path>`), system config file, built-in default. There is no project tier.

The config format is CUE, so the user file is `config.cue` in the config directory (see "User Directories") and the system file is the first `<cli>/config.cue` across `$XDG_CONFIG_DIRS` (see "System Config"). `--config <path>` loads its file with `loadCUEFile` (see "User Config").

### User Directories

The four tiers, their platform defaults, and the rules are cli/design's "User directories". `ensureDir` creates with `0700` through `os.MkdirAll`, which leaves an existing directory's mode alone.

Do not use `os.UserConfigDir` or `os.UserCacheDir`: on Unix they return an error for a relative XDG value the spec says to ignore, on macOS they ignore XDG variables entirely, and there are no state or data equivalents.

```go
const cliName = "<cli>"

// The subdirectories keep tiers apart where platform defaults share a base.
type userTier struct {
	xdgEnv    string
	unixRel   string
	darwinRel string
	darwinSub string
}

var (
	configTier = userTier{"XDG_CONFIG_HOME", ".config", "Library/Application Support", "config"}
	dataTier   = userTier{"XDG_DATA_HOME", ".local/share", "Library/Application Support", "data"}
	stateTier  = userTier{"XDG_STATE_HOME", ".local/state", "Library/Application Support", "state"}
	cacheTier  = userTier{"XDG_CACHE_HOME", ".cache", "Library/Caches", ""}
)

func (t userTier) dir() (string, error) {
	if base := os.Getenv(t.xdgEnv); filepath.IsAbs(base) {
		return filepath.Join(base, cliName), nil
	}
	home, err := os.UserHomeDir()
	if err != nil {
		return "", err
	}
	if runtime.GOOS == "darwin" {
		return filepath.Join(home, filepath.FromSlash(t.darwinRel), cliName, t.darwinSub), nil
	}
	return filepath.Join(home, filepath.FromSlash(t.unixRel), cliName), nil
}

func configDir() (string, error) { return configTier.dir() }
func dataDir() (string, error)   { return dataTier.dir() }
func stateDir() (string, error)  { return stateTier.dir() }
func cacheDir() (string, error)  { return cacheTier.dir() }

func ensureDir(dir string) error { return os.MkdirAll(dir, 0o700) }
```

### System Config

Applies when: the CLI reads a config file.

Administrators and container images set machine-wide defaults through `$XDG_CONFIG_DIRS`, a list of directories separated like `$PATH`. The rules are cli/design "Configuration precedence".

```go
func systemConfigFile(warn func(string)) string {
	dirs := os.Getenv("XDG_CONFIG_DIRS")
	if dirs == "" && runtime.GOOS != "darwin" {
		dirs = "/etc/xdg"
	}
	for _, dir := range filepath.SplitList(dirs) {
		if !filepath.IsAbs(dir) {
			continue
		}
		p := filepath.Join(dir, cliName, "config.cue")
		f, err := os.Open(p)
		if err != nil {
			if errors.Is(err, fs.ErrPermission) {
				warn(fmt.Sprintf("skipping unreadable config: %v", err))
			}
			continue
		}
		f.Close()
		return p
	}
	return ""
}
```

`$XDG_DATA_DIRS` (default `/usr/local/share:/usr/share`) applies only when the CLI reads data files installed alongside it. Single-binary CLIs embed such data with `go:embed` and do not consult it.

### Environment Variables

Env vars carry secrets and per-invocation overrides. They sit at tier 2 in the precedence chain.

```go
// Config holds the settings read from environment variables.
type Config struct {
	BaseURL  string
	Email    string
	APIToken string
}

// MissingEnvError lists the required environment variables that are unset.
type MissingEnvError struct {
	Names []string
}

func (e *MissingEnvError) Error() string {
	return "required environment variables not set: " + strings.Join(e.Names, ", ")
}

// Load reads Config from the environment, reporting every missing variable at once.
func Load() (Config, error) {
	var missing []string
	cfg := Config{}

	cfg.BaseURL = firstNonEmpty(os.Getenv("TOOL_BASE_URL"), os.Getenv("ATLASSIAN_BASE_URL"))
	if cfg.BaseURL == "" {
		missing = append(missing, "TOOL_BASE_URL")
	}

	cfg.APIToken = firstNonEmpty(os.Getenv("TOOL_API_TOKEN"), os.Getenv("ATLASSIAN_API_TOKEN"))
	if cfg.APIToken == "" {
		missing = append(missing, "TOOL_API_TOKEN")
	}

	if len(missing) > 0 {
		return Config{}, &MissingEnvError{Names: missing}
	}
	return cfg, nil
}
```

`internal/config` cannot call `outputErr` without an import cycle. Commands return the typed error unchanged, and the error boundary converts it to `ENV_REQUIRED` (see "Error Boundary").

### Naming and Vendor Fallbacks

Names and vendor fallbacks follow cli/design "Environment variables". `Load` shows a fallback with `firstNonEmpty`; error messages name only the canonical variable. Parse CLI-owned booleans with `envBool` (see "Runtime Modes").

### User Config

Applies when: the CLI reads a config file.

User config lives at `config.cue` in the config directory (see "User Directories") and holds non-secret defaults the user wants to apply across all invocations. The system config file (see "System Config") uses the same format.

CUE is the standard config format. Keep the schema and the data apart:

- The schema ships inside the binary as `internal/config/schema.cue`, embedded with `go:embed`. It holds constraints only: every field optional, no `*` defaults. A default in the schema would make every field look set, and the precedence chain could no longer tell which tier supplied a value
- The user's file holds plain values. Users cannot weaken validation by editing it, because the rules are not in it
- Built-in defaults (tier 7) are Go values, applied only to fields every other tier left unset

```cue
// internal/config/schema.cue
#Config: {
	default_project?: string & !=""
	default_board?:   int & >0
	output?: {
		color?: "auto" | "always" | "never"
		limit?: int & >0 & <=100
	}
}
```

```cue
// config.cue in the config directory
default_project: "GCP"
output: limit: 50
```

Compile the file, unify it with the embedded definition, require concrete values, and decode into a struct whose fields are pointers so an unset field stays `nil`:

```go
//go:embed schema.cue
var schemaSrc []byte

// FileConfig is a decoded config file; a nil field was not set in the file.
type FileConfig struct {
	DefaultProject *string       `json:"default_project"`
	DefaultBoard   *int          `json:"default_board"`
	Output         *OutputConfig `json:"output"`
}

// OutputConfig is the output block of FileConfig.
type OutputConfig struct {
	Color *string `json:"color"`
	Limit *int    `json:"limit"`
}

// InvalidError is a config file that cannot be used: malformed, out of schema, or named with --config and unreadable.
type InvalidError struct {
	Path string
	Err  error
}

func (e *InvalidError) Error() string { return "config " + e.Path + ": " + e.Err.Error() }
func (e *InvalidError) Unwrap() error { return e.Err }

// loadCUEFile reports found=false for a missing or unreadable file at a default location.
func loadCUEFile(path, definition string, explicit bool, warn func(string), out any) (found bool, err error) {
	src, err := os.ReadFile(path)
	if err != nil {
		switch {
		case explicit:
			return false, &InvalidError{Path: path, Err: err}
		case errors.Is(err, fs.ErrNotExist):
			return false, nil
		case errors.Is(err, fs.ErrPermission):
			warn(fmt.Sprintf("skipping unreadable config: %v", err))
			return false, nil
		default:
			return false, &InvalidError{Path: path, Err: err}
		}
	}
	ctx := cuecontext.New()
	schema := ctx.CompileBytes(schemaSrc).LookupPath(cue.ParsePath(definition))
	v := schema.Unify(ctx.CompileBytes(src, cue.Filename(path)))
	if err := v.Validate(cue.Concrete(true)); err != nil {
		return false, &InvalidError{Path: path, Err: err}
	}
	if err := v.Decode(out); err != nil {
		return false, &InvalidError{Path: path, Err: err}
	}
	return true, nil
}

func firstSet[T any](tiers ...*T) *T {
	for _, v := range tiers {
		if v != nil {
			return v
		}
	}
	return nil
}
```

Resolve each setting by passing the tiers in precedence order, with the built-in default last: `firstSet(flagLimit, envLimit, profileLimit, userLimit, systemLimit, &defaultLimit)`. Unification rejects values out of range (`limit: 500`), unknown fields (`colour:`), and incomplete values (`limit: int`). `loadCUEFile` returns each as an `InvalidError`, which commands return unchanged; the error boundary converts it to `CONFIG_INVALID` (exit 78), as it does `MissingEnvError` (see "Error Boundary"). Use `cuecontext` rather than `cue/load` — `cue/load` resolves CUE packages and modules, which a single user file does not have.

### Profiles

Applies when: users routinely switch between identities or environments.

The surface and rules are cli/design Rule 13. Register `--profile` with the profile feature, not in the root `init()`:

```go
var profileName string

func init() {
	rootCmd.PersistentFlags().StringVar(&profileName, "profile", "", "Use a saved profile for this invocation")
}

// ProfileName returns the --profile value, or "" when unset.
func ProfileName() string { return profileName }
```

Storage: `profiles.cue` in the config directory, same CUE format and validation as `config.cue`. Resolve it with `configDir()` and call `ensureDir` before writing (see "User Directories"). A missing file means no profiles are saved.

```cue
// internal/config/schema.cue, alongside #Config
#Profiles: {
	active?: string
	profiles?: [string]: {
		flags: [string]: string
	}
}
```

```cue
// profiles.cue in the config directory, written by the CLI
active: "work"
profiles: {
	work: flags: "base-url":     "https://work.example.com"
	personal: flags: "base-url": "https://example.com"
}
```

```go
// Profile is a saved bundle of flag values.
type Profile struct {
	Flags map[string]string `json:"flags"`
}

// ProfileStore is the decoded profiles.cue, keyed by profile name.
type ProfileStore struct {
	Active   string             `json:"active,omitempty"`
	Profiles map[string]Profile `json:"profiles"`
}

func profilesPath() (string, error) {
	dir, err := configDir()
	if err != nil {
		return "", err
	}
	return filepath.Join(dir, "profiles.cue"), nil
}
```

Read with `loadCUEFile(path, "#Profiles", false, warn, &store)` exactly as `config.cue` is loaded; the map key is the profile name. Write by encoding the struct with `cuelang.org/go/encoding/gocode/gocodec`, then serialising with `cuelang.org/go/cue/format`. The struct tags above are reused — gocodec honours `json` tags. The CLI is the only writer; re-parse the existing file before re-emitting if you want to preserve user comments.

`profile save` skips every flag `IsSecretFlag` reports (see "Secrets"). `profile use` records the active profile in the same file's `Active` field, so reading it needs no separate lookup.

### Secrets

Applies when: the CLI handles credentials.

The rules are cli/design "Secrets handling".

Mark secret-bearing flags with a small registry so `profile save` can skip them:

```go
// Lower-case to match Cobra's flag-name normalisation.
var secretFlags = map[string]struct{}{
	"token-file":         {},
	"client-secret-file": {},
	"private-key-file":   {},
}

// IsSecretFlag reports whether the named flag carries a path to a secret.
func IsSecretFlag(name string) bool {
	_, ok := secretFlags[name]
	return ok
}
```

List every `*-file` flag variant the CLI accepts.

Debug logging redacts by header, a separate list:

```go
var redactedHeaders = map[string]struct{}{
	"authorization": {},
	"x-api-key":     {},
	"x-auth-token":  {},
	"cookie":        {},
	"set-cookie":    {},
}

func logRequest(w io.Writer, req *http.Request) {
	fmt.Fprintf(w, "> %s %s\n", req.Method, req.URL.Path)
	for k, vs := range req.Header {
		if _, redact := redactedHeaders[strings.ToLower(k)]; redact {
			fmt.Fprintf(w, "> %s: [REDACTED]\n", k)
			continue
		}
		for _, v := range vs {
			fmt.Fprintf(w, "> %s: %s\n", k, v)
		}
	}
}
```

Add any custom header the CLI documents as carrying credentials to `redactedHeaders`.

### Validation

CUE validates config files (see "User Config"); `Load` reports every missing variable at once (see "Environment Variables"). The error boundary converts both.

## Async Jobs

Applies when: the CLI submits work that completes after the command returns.

Submission, `--wait`, `--timeout`, the ledger, and the `jobs` commands follow cli/design Rule 11.

### Submission and Waiting

Register the flags on the submitting command:

```go
var (
	renderWait    bool
	renderTimeout = Duration(10 * time.Minute)
)

func init() {
	renderCmd.Flags().BoolVar(&renderWait, "wait", false,
		"Block until the job completes")
	renderCmd.Flags().Var(&renderTimeout, "timeout",
		"Maximum wait, e.g. 30s, 1h30m; exit 75 on expiry")
}
```

### Jobs Ledger

The ledger record (cli/design Rule 11):

```go
// JobStatus is the lifecycle state of an async job.
type JobStatus string

// Job lifecycle states, in order.
const (
	JobSubmitted JobStatus = "submitted"
	JobRunning   JobStatus = "running"
	JobComplete  JobStatus = "complete"
	JobFailed    JobStatus = "failed"
	JobCancelled JobStatus = "cancelled"
)

// JobRecord is one line of the jobs ledger.
type JobRecord struct {
	JobID       string         `json:"job_id"`
	Kind        string         `json:"kind"`
	Status      JobStatus      `json:"status"`
	SubmittedAt time.Time      `json:"submitted_at"`
	StartedAt   *time.Time     `json:"started_at,omitempty"`
	CompletedAt *time.Time     `json:"completed_at,omitempty"`
	DurationS   int            `json:"duration_s,omitempty"`
	Result      map[string]any `json:"result,omitempty"`
	Error       *JobError      `json:"error,omitempty"`
}

// JobError is a job failure as stored in the ledger, where the exit code must survive a read.
type JobError struct {
	Code     string `json:"code"`
	Message  string `json:"message"`
	Fix      string `json:"fix"`
	ExitCode int    `json:"exit_code"`
}

func newJobError(p *ErrorPayload) *JobError {
	return &JobError{Code: p.Code, Message: p.Message, Fix: p.Fix, ExitCode: p.exitCode()}
}

// Payload rebuilds the error for output, so transient is derived as for any other failure.
func (e JobError) Payload() *ErrorPayload {
	return &ErrorPayload{Code: e.Code, Message: e.Message, Fix: e.Fix, ExitCode: e.ExitCode}
}
```

The ledger is JSON Lines, not CUE: it is runtime history in the state tier, not user-edited config.

### Concurrent Append

Every writer takes an exclusive lock on `jobs.lock` in the state directory, then opens `jobs.jsonl` while holding it. The lock lives in its own file because `prune` and `repair` replace `jobs.jsonl`: a lock on the ledger itself would be held on the replaced file, and a waiting appender would write into it after the swap. `github.com/gofrs/flock` provides the lock.

```go
func withLedgerLock(fn func(dir string) error) (err error) {
	dir, err := stateDir()
	if err != nil {
		return err
	}
	if err := ensureDir(dir); err != nil {
		return err
	}
	lock := flock.New(filepath.Join(dir, "jobs.lock"))
	if err := lock.Lock(); err != nil {
		return err
	}
	defer func() { err = errors.Join(err, lock.Unlock()) }()
	return fn(dir)
}

func appendJob(rec JobRecord) error {
	return withLedgerLock(func(dir string) error {
		f, err := os.OpenFile(filepath.Join(dir, "jobs.jsonl"), os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0o600)
		if err != nil {
			return err
		}
		if err := json.NewEncoder(f).Encode(rec); err != nil {
			return errors.Join(err, f.Close())
		}
		return f.Close()
	})
}

// replaceLedger swaps jobs.jsonl for what write produces; call it inside withLedgerLock.
func replaceLedger(dir string, write func(io.Writer) error) (err error) {
	tmp, err := os.CreateTemp(dir, ".jobs-*.jsonl")
	if err != nil {
		return err
	}
	defer func() {
		if err != nil {
			err = errors.Join(err, os.Remove(tmp.Name()))
		}
	}()
	if err = write(tmp); err != nil {
		return errors.Join(err, tmp.Close())
	}
	if err = tmp.Close(); err != nil {
		return err
	}
	return os.Rename(tmp.Name(), filepath.Join(dir, "jobs.jsonl"))
}
```

`prune` and `repair` read the ledger and call `replaceLedger` inside one `withLedgerLock`, so no append lands between the read and the swap. Readers take no lock: the rename is atomic, so a reader sees the old file or the new one, and reader tolerance skips a last line that is still being appended.

### Reader Tolerance

Readers skip malformed lines with a stderr warning naming the line (cli/design Rule 11):

```go
func readLedger(path string, warn func(string)) ([]JobRecord, error) {
	f, err := os.Open(path)
	if errors.Is(err, fs.ErrNotExist) {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}
	defer f.Close()

	var records []JobRecord
	scanner := bufio.NewScanner(f)
	scanner.Buffer(make([]byte, 64<<10), 16<<20) // bufio's 64 KB default rejects long result lines
	for line := 1; scanner.Scan(); line++ {
		var rec JobRecord
		if err := json.Unmarshal(scanner.Bytes(), &rec); err != nil {
			warn(fmt.Sprintf("skipping malformed ledger line %d", line))
			continue
		}
		records = append(records, rec)
	}
	return records, scanner.Err()
}

// currentJobs keeps the last valid record per job, in first-submitted order.
func currentJobs(records []JobRecord) []JobRecord {
	index := make(map[string]int, len(records))
	var out []JobRecord
	for _, r := range records {
		if i, ok := index[r.JobID]; ok {
			out[i] = r
			continue
		}
		index[r.JobID] = len(out)
		out = append(out, r)
	}
	return out
}
```

`jobs list` and `jobs get` read through `currentJobs`. `jobs prune` decides per job from its current record and removes all of that job's lines.

### Signal Handling During --wait

The poll loop selects on `ctx.Done()`. On cancellation it writes the job ID to stderr and returns `ctx.Err()` without touching the ledger; `main` then exits with the signal code (see "Signal Handling").

## API Client

Applies when: the CLI calls an HTTP API.

### Structure

```go
// Client is the HTTP client for the upstream API.
type Client struct {
	baseURL    string
	httpClient *http.Client
	auth       string
	debug      io.Writer
}

// NewClient returns a Client authenticated from cfg.
func NewClient(cfg *config.Config) *Client {
	return &Client{
		baseURL: cfg.BaseURL,
		httpClient: &http.Client{
			Timeout: 30 * time.Second,
		},
		auth: cfg.APIToken,
	}
}
```

### Standard Methods

Implement `Get`, `Post`, `Put`, `Delete` methods that handle:

- Authentication headers (Basic or Bearer)
- Content-Type setting
- Response body reading and closing (`defer resp.Body.Close()`)
- Status code validation (2xx range)
- Error parsing into `APIError` type

### APIError Type

```go
// APIError is a non-2xx response from the upstream API.
type APIError struct {
	StatusCode   int
	Status       string
	UpstreamCode string
	Messages     []string
	Method       string
	Path         string
	RetryAfter   string // retryAfter(resp.Header.Get("Retry-After"), time.Now())
}

func (e *APIError) Error() string {
	if len(e.Messages) > 0 {
		return fmt.Sprintf("%s %s: %s (%d)", e.Method, e.Path, strings.Join(e.Messages, "; "), e.StatusCode)
	}
	return fmt.Sprintf("%s %s: %s", e.Method, e.Path, e.Status)
}
```

### APIError to ErrorPayload

`payloadFromAPIError` implements cli/design Rule 5's upstream HTTP status mapping. The error boundary calls it for any `APIError` a command returns (see "Error Boundary").

```go
func payloadFromAPIError(e *api.APIError) *ErrorPayload {
	p := &ErrorPayload{
		Message:    e.Error(),
		RetryAfter: e.RetryAfter,
		ExitCode:   exitCodeForStatus(e.StatusCode),
	}
	switch s := e.StatusCode; {
	case s == 400:
		p.Code, p.Fix = cmp.Or(e.UpstreamCode, "BAD_REQUEST"), "correct the arguments named in the message"
	case s == 401:
		p.Code, p.Fix = cmp.Or(e.UpstreamCode, "AUTH_EXPIRED"), "<cli> auth refresh"
	case s == 403:
		p.Code, p.Fix = "PERMISSION_DENIED", "check the credential's permissions"
	case s == 404:
		p.Code, p.Fix = "NOT_FOUND", "check the identifier"
	case s == 409:
		p.Code, p.Fix = "CONFLICT", "re-fetch the resource and retry deliberately"
	case s == 429:
		p.Code, p.Fix = "RATE_LIMITED", "wait and retry"
	case p.ExitCode == ExitTransient:
		p.Code, p.Fix = cmp.Or(e.UpstreamCode, "UPSTREAM_ERROR"), "retry with backoff"
	default:
		p.Code, p.Fix = cmp.Or(e.UpstreamCode, "UPSTREAM_REJECTED"), "do not retry; act on the message"
	}
	return p
}

func exitCodeForStatus(s int) int {
	switch {
	case s == 400:
		return ExitUsage
	case s == 401, s == 403:
		return ExitPermission
	case s == 404:
		return ExitNotFound
	case s == 409:
		return ExitConflict
	case s == 408, s == 425, s == 429, s >= 500 && s <= 599:
		return ExitTransient
	default:
		return ExitFailure
	}
}
```

`ExitCode` comes from the status, never from the code. An upstream code is a domain code, so it is absent from `canonicalExit` and would otherwise exit 1 (see "Output Helpers"). `exitCodeForStatus` is the one status-to-exit mapping.

`retryAfter` converts the header as Rule 5 requires:

```go
// retryAfter converts a Retry-After header to the duration grammar, or "" when absent or malformed.
func retryAfter(header string, now time.Time) string {
	if secs, err := strconv.Atoi(header); err == nil && secs >= 0 {
		return formatDuration(time.Duration(secs) * time.Second)
	}
	if t, err := http.ParseTime(header); err == nil {
		return formatDuration(t.Sub(now))
	}
	return ""
}
```

### Pagination

Pagination follows cli/design Rules 3 and 6. Encoding the cursor as base64 JSON lets the CLI control its format whatever the upstream uses, and the query hash binds it to its query:

```go
type cursor struct {
	Offset    int    `json:"o,omitempty"`
	Token     string `json:"t,omitempty"`
	QueryHash string `json:"q,omitempty"`
}

func encodeCursor(c cursor) string {
	b, _ := json.Marshal(c)
	return base64.RawURLEncoding.EncodeToString(b)
}

func decodeCursor(s string) (cursor, error) {
	b, err := base64.RawURLEncoding.DecodeString(s)
	if err != nil {
		return cursor{}, err
	}
	var c cursor
	if err := json.Unmarshal(b, &c); err != nil {
		return cursor{}, err
	}
	return c, nil
}
```

When decoding fails, or the embedded query hash does not match the current invocation's filter/sort/fields, return:

```go
return outputErr(&ErrorPayload{
	Code:    "CURSOR_INVALID",
	Message: "pagination cursor is invalid or stale",
	Fix:     "restart the traversal without --next",
})
```

### Debug Logging

HTTP logging belongs to `--debug`. `--verbose` only adds fields to the output and never logs (cli/design Rule 9).

```go
// SetDebugOutput enables request logging to w.
func (c *Client) SetDebugOutput(w io.Writer) {
	c.debug = w
}
```

Wire it with `if Debug() { client.SetDebugOutput(stderr) }`. Log through `logRequest` (see "Secrets"), adding status code and duration.

## Signal Handling

A signal-terminated run exits 128+signum (cli/design Rule 4). `Execute` (see "Root Command") records the caught signal in `caughtSignal` and cancels the root context; `main` (see "Entry Point") checks `SignalExitCode()` before the error path. The capture is required because `signal.NotifyContext` alone surfaces cancellation as `context.Canceled`, which would exit 1.

The first signal cancels the context; `signal.Stop` then restores the default action, so a second signal terminates the process even when a call ignores cancellation.

Pass context through to API calls and long-running operations. Check `ctx.Done()` in loops and pagination.

## TUI Package

`internal/tui/` holds terminal formatting utilities.

### Colour Constants

```go
package tui

import "github.com/fatih/color"

// Diagnostic colours; detectModes disables them when stderr decoration is off.
var (
	ColorError   = color.New(color.FgRed)
	ColorWarning = color.New(color.FgYellow)
	ColorDim     = color.New(color.Faint)
)
```

### Aligned Output

`Table` and `Detail` back the `Table` and `Record` result types (see "Text Output"). Lines never carry trailing spaces, and an empty cell stays blank:

```go
// Table writes rows under a header with columns aligned.
func Table(w io.Writer, header []string, rows [][]string) error {
	return writeAligned(w, append([][]string{header}, rows...), 2)
}

// Detail writes one aligned "label: value" line per pair.
func Detail(w io.Writer, labels, values []string) error {
	rows := make([][]string, len(labels))
	for i := range labels {
		rows[i] = []string{labels[i] + ":", values[i]}
	}
	return writeAligned(w, rows, 1)
}

func writeAligned(w io.Writer, rows [][]string, gap int) error {
	var widths []int
	for _, r := range rows {
		for i, c := range r {
			if i == len(widths) {
				widths = append(widths, 0)
			}
			widths[i] = max(widths[i], utf8.RuneCountInString(c))
		}
	}
	for _, r := range rows {
		var b strings.Builder
		for i, c := range r {
			b.WriteString(c)
			if i < len(r)-1 {
				b.WriteString(strings.Repeat(" ", widths[i]-utf8.RuneCountInString(c)+gap))
			}
		}
		if _, err := fmt.Fprintln(w, strings.TrimRight(b.String(), " ")); err != nil {
			return err
		}
	}
	return nil
}
```

The header stays uncoloured: escape codes count toward a cell's width and would misalign the columns. Rune count assumes every character is one column wide. When cells may hold CJK text or emoji, measure with `internal/width` instead.

### Progress Indicator

Applies when: the CLI runs operations long enough to need progress feedback.

A carriage-return progress indicator on stderr. Callers pass `Animated()`, so it honours `--quiet`, `--color`, and `TERM=dumb` as well as the terminal check:

```go
// Progress rewrites one terminal line; it is silent when disabled.
type Progress struct {
	writer  io.Writer
	enabled bool
}

// NewProgress returns a Progress writing to w.
func NewProgress(w io.Writer, enabled bool) *Progress {
	return &Progress{writer: w, enabled: enabled}
}

// Update replaces the current line with msg.
func (p *Progress) Update(msg string) {
	if !p.enabled {
		return
	}
	fmt.Fprintf(p.writer, "\r%s", msg)
}

// Done clears the line.
func (p *Progress) Done() {
	if !p.enabled {
		return
	}
	fmt.Fprint(p.writer, "\r\033[K")
}
```

## Testing

### Design for Testability

Declare interfaces at the consumer so tests can substitute without mocking the full API surface:

```go
// PageGetter is the part of the API client this package uses.
type PageGetter interface {
	GetPage(ctx context.Context, pageID string) (*api.Page, error)
}
```

### HTTP Testing

Use `httptest.NewServer` to exercise real HTTP behaviour without mocks:

```go
func TestGetPage(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		fmt.Fprint(w, `{"id": "123", "title": "Test"}`)
	}))
	defer server.Close()

	client := api.NewClient(&config.Config{BaseURL: server.URL})
	page, err := client.GetPage(context.Background(), "123")
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if page.Title != "Test" {
		t.Errorf("got title %q, want %q", page.Title, "Test")
	}
}
```

### Table-Driven Tests

Use table-driven tests for functions with multiple input/output scenarios:

```go
func TestValidateSpaceKey(t *testing.T) {
	tests := []struct {
		name    string
		input   string
		wantErr bool
	}{
		{"valid", "MYSPACE", false},
		{"with numbers", "SPACE123", false},
		{"empty", "", true},
		{"special chars", "MY SPACE!", true},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			err := validateSpaceKey(tt.input)
			if (err != nil) != tt.wantErr {
				t.Errorf("validateSpaceKey(%q) error = %v, wantErr %v", tt.input, err, tt.wantErr)
			}
		})
	}
}
```

### Test Utilities

- `t.TempDir()` for temporary file and directory tests
- `t.Setenv()` for environment variable tests (auto-cleanup)
- `testdata/` directory for JSON fixtures and sample files
- `resetFlags` and `run` (see "CLI Contract Tests") when testing cobra commands; flags are package-level mutable state

### CLI Contract Tests

These are the Go form of the vocabulary and envelope lints in cli/design, "Schema-first generation". They live in `internal/cli` and drive commands through `execute`, capturing output through the swappable `stdout` and `stderr` writers:

```go
func resetFlags(t *testing.T, c *cobra.Command) {
	t.Helper()
	reset := func(f *pflag.Flag) {
		var err error
		if sv, ok := f.Value.(pflag.SliceValue); ok {
			err = sv.Replace(nil)
		} else {
			err = f.Value.Set(f.DefValue)
		}
		if err != nil {
			t.Fatalf("reset --%s: %v", f.Name, err)
		}
		f.Changed = false
	}
	c.Flags().VisitAll(reset)
	c.PersistentFlags().VisitAll(reset)
	for _, sub := range c.Commands() {
		resetFlags(t, sub)
	}
}

func run(t *testing.T, args ...string) (string, error) {
	t.Helper()
	resetFlags(t, rootCmd)
	var out bytes.Buffer
	stdout, stderr = &out, io.Discard
	t.Cleanup(func() {
		stdout, stderr = os.Stdout, os.Stderr
		resetFlags(t, rootCmd)
	})
	err := execute(args)
	return out.String(), err
}

func commandPaths() [][]string {
	var paths [][]string
	var walk func(c *cobra.Command)
	walk = func(c *cobra.Command) {
		if !c.Hidden && c.Name() != "help" {
			paths = append(paths, strings.Fields(c.CommandPath())[1:])
		}
		for _, sub := range c.Commands() {
			walk(sub)
		}
	}
	walk(rootCmd)
	return paths
}
```

Every command, at every flag position, answers a bad flag with the error envelope:

```go
func TestErrorEnvelope(t *testing.T) {
	for _, path := range commandPaths() {
		for _, args := range [][]string{
			append(slices.Clone(path), "--bogus", "--json"),
			append(slices.Clone(path), "--json", "--bogus"),
		} {
			out, _ := run(t, args...)
			var env Envelope
			if err := json.Unmarshal([]byte(out), &env); err != nil {
				t.Errorf("%v: stdout is not an envelope: %q", args, out)
				continue
			}
			if env.Status != StatusError || env.Error == nil || env.Error.Code != "INVALID_ARGUMENT" {
				t.Errorf("%v: got %+v, want an INVALID_ARGUMENT error", args, env)
			}
		}
	}
}
```

No command or flag takes a name from the "Never as canonical" columns of cli/design Rule 9. Aliases pass, because they are never registered as names. When a domain flag only shares a spelling (`--target` for a build target), drop that name from the set with a comment saying why:

```go
var (
	bannedCommands = wordSet("view info show describe ls all find add new make edit modify rm remove destroy exec do health state")
	bannedFlags    = wordSet("skip-confirmations no-confirm yes-to-all yes non-interactive plan preview simulate silent " +
		"max-results count max page offset cursor columns select where query from start-time after to end-time before " +
		"config-file conf trace diagnostics colour ansi recurse tree tail observe subscribe " +
		"out destination write-to save-to target config-name env-name block sync time-limit max-duration deadline")
)

func wordSet(words string) map[string]bool {
	set := make(map[string]bool)
	for _, w := range strings.Fields(words) {
		set[w] = true
	}
	return set
}

func TestCanonicalVocabulary(t *testing.T) {
	var walk func(c *cobra.Command)
	walk = func(c *cobra.Command) {
		if bannedCommands[c.Name()] {
			t.Errorf("command %q is not canonical", c.CommandPath())
		}
		check := func(f *pflag.Flag) {
			if bannedFlags[f.Name] {
				t.Errorf("%s: flag --%s is not canonical", c.CommandPath(), f.Name)
			}
		}
		c.Flags().VisitAll(check)
		c.PersistentFlags().VisitAll(check)
		for _, sub := range c.Commands() {
			walk(sub)
		}
	}
	walk(rootCmd)
}
```

Success shapes are per-command tests against `httptest` fixtures (see "HTTP Testing"), asserting the `--json` output parses as an `Envelope` with `status: "ok"`.

## Recommended Dependencies

These packages have been evaluated against alternatives.

### Every CLI

| Package | Purpose |
| --- | --- |
| `github.com/spf13/cobra` | CLI framework: commands, flags, help, completion |
| `github.com/fatih/color` | Terminal colour for stderr diagnostics |
| `golang.org/x/term` | Terminal detection for the runtime modes |

### When the Need Arises

| Package | Purpose | When |
| --- | --- | --- |
| `cuelang.org/go` | Config files: schema, validation, decoding | The CLI reads a config file |
| `go.uber.org/goleak` | Goroutine leak detection in tests | The CLI runs background goroutines that outlive a command step (daemon, watcher, worker pool) |
| `github.com/p3bot/agentdex` | Agent detection and skills roots for `<cli> skill install` | The CLI ships an agent skill |
| `github.com/goccy/go-yaml` | SKILL.md frontmatter parsing for `<cli> skill install` and `uninstall` | The CLI ships an agent skill |
| `github.com/gofrs/flock` | File lock | The CLI keeps a jobs ledger |
| `github.com/yuin/goldmark` | Markdown parsing and rendering, GFM | The CLI converts or validates markdown content |
| `github.com/JohannesKaufmann/html-to-markdown/v2` | HTML to Markdown conversion | The CLI ingests HTML from an upstream |
| `github.com/charmbracelet/glamour` | Terminal markdown rendering | Human display on a decorated terminal only; never default or piped output |
| `golang.org/x/oauth2` | OAuth2, including Google Application Default Credentials | The upstream authenticates with OAuth |
| `github.com/google/uuid` | UUID generation | The CLI mints identifiers |
| `github.com/chzyer/readline` | Interactive line input | An explicit REPL command |
| `github.com/coder/websocket` | WebSocket client | The upstream streams over WebSocket |
| `golang.org/x/mod` | Module and semantic version handling | The CLI compares versions |

### Dependency Philosophy

Keep dependencies minimal and purposeful. Every dependency is a maintenance burden. Before adding a package:

- Check if the standard library can do it
- Evaluate alternatives for size, maintenance, and API quality
- Prefer packages with no or few transitive dependencies

## Build and Distribution

### Building

```bash
go build -o <name> ./cmd/<name>/
```

### Version Injection

Set the version at build time:

```bash
go build -ldflags "-X <module>/internal/cli.Version=v1.0.0" -o <name> ./cmd/<name>/
```

`go install <module>@v1.0.0` passes no ldflags, so `resolvedVersion` (see "Root Command") reads the module version Go embeds in the binary. Either path reports the contract version of cli/design Rule 12; only a local `go build` without ldflags reports `dev`.

### Linting

Include a `.golangci.yml` at the project root. golangci-lint v2 rejects a config without a version, so the minimal starting configuration is:

```yaml
version: "2"
```

errcheck already ignores `fmt.Fprint`, `fmt.Fprintf`, and `fmt.Fprintln` by default; do not add exclusions for them. Do not enable the `std-error-handling` exclusion preset — it hides unchecked `Close` and `os.Remove` errors, which must be handled deliberately.

Run before commits: `golangci-lint run`

### Distribution

Publish via Homebrew tap for easy installation:

```bash
brew tap <user>/tap
brew install <name>
```

Also support `go install`:

```bash
go install <module>@latest
```
