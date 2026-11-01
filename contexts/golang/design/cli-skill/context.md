# Go CLI Agent Skill

The Go implementation of an agent skill for a CLI built to `golang/design/cli`. Load that guide and `cli/design` first with `start get contexts:golang/design/cli` and `start get contexts:cli/design`. The command surface, agent resolution, uninstall safety, and `SKILL.md` content rules are cli/design Rule 10.

Write `skill.md` with the skill writing guide (`start get contexts:skill/writing`). A section named here that is not in this guide is in `golang/design/cli`.

## Package Layout

```none
internal/
├── skill/
│   ├── skill.md
│   ├── skill.go
│   ├── skill_test.go
│   ├── roots.go
│   └── install.go
└── cli/
    ├── skill.go
    ├── skill_install.go
    ├── skill_list.go
    ├── skill_uninstall.go
    └── skill_test.go
```

- skill.md — the skill source, frontmatter included
- skill.go — embed, identity constants, `Text`
- roots.go — agent sets and skills roots from the agentdex catalog
- install.go — write, detect, and remove copies under a skills root
- cli/skill*.go — `skill`, `skill install`, `skill list`, `skill uninstall`, one file per command (see "One File Per Command")
- skill/skill_test.go holds the frontmatter-name test; cli/skill_test.go holds the drift tests, which need `rootCmd`

`internal/skill` never imports `internal/cli`. It returns sentinel errors, and `cli` converts them to `ErrorPayload` at the boundary, as it does for `APIError` and `MissingEnvError`.

## Embedded Contract

```go
// Package skill holds the agent skill printed by <cli> skill.
package skill

import (
	_ "embed"
	"strings"
)

// Skill identity on disk: the directory name and frontmatter name, and the entry file.
const (
	ID       = "<cli>"
	FileName = "SKILL.md"
)

//go:embed skill.md
var embedded string

// Text returns the skill, ending in a newline.
func Text() string {
	if strings.HasSuffix(embedded, "\n") {
		return embedded
	}
	return embedded + "\n"
}
```

Test that `frontmatterName([]byte(Text()))` equals `ID` (see "Install and Remove"), so the embedded file always passes the ownership check in install and uninstall.

Keep the skill in step with the command tree. This test is the Go form of the skill drift check in cli/design: every canonical command starts a line, and no alias does. Matching whole words at line start stops `<cli> item get-all` from counting as `<cli> item get`:

```go
func TestSkillMatchesCommandTree(t *testing.T) {
	text := skill.Text()
	listed := func(path string) bool {
		return regexp.MustCompile(`(?m)^` + regexp.QuoteMeta(path) + `(\s|$)`).MatchString(text)
	}
	var walk func(c *cobra.Command)
	walk = func(c *cobra.Command) {
		for _, sub := range c.Commands() {
			if sub.Hidden || sub.Name() == "help" || sub.Name() == "completion" {
				continue
			}
			if !listed(sub.CommandPath()) {
				t.Errorf("skill.md does not list %q", sub.CommandPath())
			}
			for _, alias := range sub.Aliases {
				if path := c.CommandPath() + " " + alias; listed(path) {
					t.Errorf("skill.md lists alias %q; use %q", path, sub.CommandPath())
				}
			}
			walk(sub)
		}
	}
	walk(rootCmd)
}
```

Missing flags are fine, since `--help` covers them. A flag the skill names must exist and be canonical. `flagAliases` is the map from "Aliases" under Global Flags; a CLI with no flag aliases drops that branch:

```go
func TestSkillFlagsExist(t *testing.T) {
	// cobra adds help and version only when the command runs.
	known := map[string]bool{"help": true, "version": true}
	var walk func(c *cobra.Command)
	walk = func(c *cobra.Command) {
		mark := func(f *pflag.Flag) { known[f.Name] = true }
		c.Flags().VisitAll(mark)
		c.PersistentFlags().VisitAll(mark)
		for _, sub := range c.Commands() {
			walk(sub)
		}
	}
	walk(rootCmd)
	for _, m := range regexp.MustCompile(`--([a-z][a-z0-9-]*)`).FindAllStringSubmatch(skill.Text(), -1) {
		name := m[1]
		if canonical, ok := flagAliases[name]; ok {
			t.Errorf("skill.md uses alias --%s; use --%s", name, canonical)
		} else if !known[name] {
			t.Errorf("skill.md names --%s, which no command defines", name)
		}
	}
}
```

## Skills Roots

agentdex resolves every agent's skills roots from its catalog, so the CLI never hardcodes product paths. `EnrichNone` never contacts models.dev. The catalog itself uses agentdex's default `FetchCached`, which reaches the registry only when its cache is cold, so the first run on a machine may need the network. A failed load is `ErrCatalogUnavailable`.

```go
// Location selects global or project-local skills roots.
type Location int

// Skills root locations.
const (
	Global Location = iota
	Local
)

// Usage-class failures in agent selection.
var (
	ErrUnknownAgent    = errors.New("unknown agent")
	ErrNoSkillsConcept = errors.New("agent has no skills concept")
	ErrNoSkillsRoot    = errors.New("agent has no writable skills root")
	ErrNoAgents        = errors.New("no installed agents with a skills concept")
)

// OpenIndex opens the agentdex catalog with local roots based on workingDir.
func OpenIndex(workingDir string) (*agentdex.Index, error) {
	return agentdex.Open(agentdex.WithWorkingDir(workingDir))
}

// ScopeAt returns a's skills roots at loc.
func ScopeAt(a agentdex.Agent, loc Location) agentdex.SkillsScope {
	if loc == Local {
		return a.Detection.Skills.Local
	}
	return a.Detection.Skills.Global
}

// HasSkillsConcept reports whether the catalog defines any skills root for a.
func HasSkillsConcept(a agentdex.Agent) bool {
	return !emptyScope(a.Detection.Skills.Global) || !emptyScope(a.Detection.Skills.Local)
}

func emptyScope(sc agentdex.SkillsScope) bool {
	return sc.Agents.Path == "" && sc.Native.Path == "" && sc.Primary.Path == "" && len(sc.Alternatives) == 0
}

// InstallRoot is Primary for the default set; a named agent uses Native, else the shared agents root.
func InstallRoot(sc agentdex.SkillsScope, named bool) string {
	if !named {
		return clean(sc.Primary.Path)
	}
	if sc.Native.Path != "" {
		return clean(sc.Native.Path)
	}
	return clean(sc.Agents.Path)
}

// Candidates returns every root a copy may live under, de-duplicated.
func Candidates(sc agentdex.SkillsScope) []string {
	var out []string
	for _, p := range []string{sc.Primary.Path, sc.Native.Path, sc.Agents.Path} {
		if p = clean(p); p != "" && !slices.Contains(out, p) {
			out = append(out, p)
		}
	}
	return out
}

func clean(p string) string {
	if p == "" {
		return ""
	}
	return filepath.Clean(p)
}

// DefaultSet returns the installed agents that have a skills concept.
func DefaultSet(ctx context.Context, idx *agentdex.Index) ([]agentdex.Agent, error) {
	res, err := idx.Agents.List(ctx, agentdex.AgentQuery{Installed: true, Enrich: agentdex.EnrichNone})
	if err != nil {
		return nil, err
	}
	var out []agentdex.Agent
	for _, a := range res.Items {
		if HasSkillsConcept(a) {
			out = append(out, a)
		}
	}
	return out, nil
}

// UnknownAgentError names an agent the catalog does not know, and the IDs it does.
type UnknownAgentError struct {
	ID    string
	Known []string
}

func (e *UnknownAgentError) Error() string { return fmt.Sprintf("unknown agent %q", e.ID) }
func (e *UnknownAgentError) Unwrap() error { return ErrUnknownAgent }

// KnownIDs returns every agent ID in the catalog, sorted.
func KnownIDs(ctx context.Context, idx *agentdex.Index) ([]string, error) {
	res, err := idx.Agents.List(ctx, agentdex.AgentQuery{Enrich: agentdex.EnrichNone})
	if err != nil {
		return nil, err
	}
	ids := make([]string, 0, len(res.Items))
	for _, a := range res.Items {
		ids = append(ids, a.ID)
	}
	slices.Sort(ids)
	return ids, nil
}

// Resolve loads named agents, installed or not.
func Resolve(ctx context.Context, idx *agentdex.Index, ids []string) ([]agentdex.Agent, error) {
	out := make([]agentdex.Agent, 0, len(ids))
	for _, id := range ids {
		d, err := idx.Agents.Get(ctx, id, agentdex.AgentGetQuery{Enrich: agentdex.EnrichNone})
		if errors.Is(err, agentdex.ErrAgentUnknown) {
			known, lerr := KnownIDs(ctx, idx)
			if lerr != nil {
				return nil, lerr
			}
			return nil, &UnknownAgentError{ID: id, Known: known}
		}
		if err != nil {
			return nil, err
		}
		if !HasSkillsConcept(d.Agent) {
			return nil, fmt.Errorf("%w: %q", ErrNoSkillsConcept, id)
		}
		out = append(out, d.Agent)
	}
	return out, nil
}
```

`Primary` is agentdex's own choice: the shared agents root, else the native root, else the first alternative. Named agents skip alternatives because the user asked for that agent specifically, and an alternative may belong to another product.

## Install and Remove

```go
// ErrForeignCopy is an existing copy that install must not replace.
var ErrForeignCopy = errors.New("existing copy is not this skill")

// Install atomically writes Text under every root and returns the paths, writing nothing when any root holds a foreign copy.
func Install(roots []string) ([]string, error) {
	for _, root := range roots {
		if err := rootErr(root, checkReplaceable(root)); err != nil {
			return nil, err
		}
	}
	written := make([]string, 0, len(roots))
	for _, root := range roots {
		path, err := write(root)
		if err != nil {
			return nil, rootErr(root, err)
		}
		written = append(written, path)
	}
	return written, nil
}

func rootErr(root string, err error) error {
	if errors.Is(err, fs.ErrPermission) || errors.Is(err, syscall.EROFS) {
		return fmt.Errorf("%w: %s: %w", ErrNoSkillsRoot, root, err)
	}
	return err
}

func checkReplaceable(root string) error {
	dir := filepath.Join(root, ID)
	info, err := os.Lstat(filepath.Join(dir, FileName))
	switch {
	case errors.Is(err, fs.ErrNotExist):
		return nil
	case errors.Is(err, syscall.ENOTDIR):
		return fmt.Errorf("%w: %s: not a directory", ErrForeignCopy, dir)
	case err != nil:
		return err
	case !info.Mode().IsRegular():
		return fmt.Errorf("%w: %s: %s is not a regular file", ErrForeignCopy, dir, FileName)
	}
	reason, err := foreignReason(dir)
	if err != nil {
		return err
	}
	if reason != "" {
		return fmt.Errorf("%w: %s: %s", ErrForeignCopy, dir, reason)
	}
	return nil
}

func write(root string) (path string, err error) {
	dir := filepath.Join(root, ID)
	if err := os.MkdirAll(dir, 0o755); err != nil {
		return "", err
	}
	tmp, err := os.CreateTemp(dir, "."+FileName+"-*")
	if err != nil {
		return "", err
	}
	defer func() {
		if err != nil {
			err = errors.Join(err, os.Remove(tmp.Name()))
		}
	}()
	if _, err = tmp.WriteString(Text()); err != nil {
		return "", errors.Join(err, tmp.Close())
	}
	if err = tmp.Chmod(0o644); err != nil {
		return "", errors.Join(err, tmp.Close())
	}
	if err = tmp.Close(); err != nil {
		return "", err
	}
	path = filepath.Join(dir, FileName)
	if err = os.Rename(tmp.Name(), path); err != nil {
		return "", err
	}
	return path, nil
}

// Present reports whether <root>/<ID>/SKILL.md is a regular file.
func Present(root string) bool {
	info, err := os.Stat(filepath.Join(root, ID, FileName))
	return err == nil && info.Mode().IsRegular()
}

// Outcome is the result of removing one installed copy.
type Outcome string

// Uninstall outcomes, as printed in the first report column.
const (
	Removed Outcome = "removed"
	Absent  Outcome = "absent"
	Kept    Outcome = "kept"
)

// RemoveOwned deletes <root>/<ID> only when it holds SKILL.md alone and that file is named ID.
func RemoveOwned(root string) (Outcome, string, error) {
	dir := filepath.Join(root, ID)
	entries, err := os.ReadDir(dir)
	if errors.Is(err, fs.ErrNotExist) {
		return Absent, "", nil
	}
	if errors.Is(err, syscall.ENOTDIR) {
		return Kept, "not a directory", nil
	}
	if err != nil {
		return "", "", err
	}
	if len(entries) != 1 || entries[0].Name() != FileName || !entries[0].Type().IsRegular() {
		return Kept, "directory does not hold " + FileName + " alone", nil
	}
	reason, err := foreignReason(dir)
	if err != nil {
		return "", "", err
	}
	if reason != "" {
		return Kept, reason, nil
	}
	return Removed, "", os.RemoveAll(dir)
}

// foreignReason says why dir's SKILL.md is not this skill, or returns "" when it is.
func foreignReason(dir string) (string, error) {
	data, err := os.ReadFile(filepath.Join(dir, FileName))
	if err != nil {
		return "", err
	}
	name, err := frontmatterName(data)
	if err != nil {
		return "frontmatter unreadable", nil
	}
	if name != ID {
		return "frontmatter name is not " + ID, nil
	}
	return "", nil
}

func frontmatterName(data []byte) (string, error) {
	rest, ok := bytes.CutPrefix(data, []byte("---\n"))
	if !ok {
		return "", errors.New("no frontmatter")
	}
	fm, _, ok := bytes.Cut(rest, []byte("\n---\n"))
	if !ok {
		return "", errors.New("unterminated frontmatter")
	}
	var meta struct {
		Name string `yaml:"name"`
	}
	if err := yaml.Unmarshal(fm, &meta); err != nil {
		return "", err
	}
	return meta.Name, nil
}
```

The temp file lives in the destination directory so the rename never crosses a filesystem. `os.CreateTemp` creates it as `0600`, so `Chmod` makes the installed copy readable by every user of a shared root. A root the CLI cannot write to is `ErrNoSkillsRoot`; any other I/O error returns unchanged. `Install` checks every root before writing any, so a foreign copy fails the whole command with nothing changed. `RemoveOwned` keeps a copy that is foreign or shares its directory with other files, never deleting it. An edited copy that still names `ID` counts as owned and is replaced or removed.

## Commands

```go
// Shared by install, list, and uninstall; only the executing command parses it.
var skillLocal bool

var skillCmd = &cobra.Command{
	Use:     "skill",
	Aliases: []string{"skills"},
	Short:   "Print the agent skill or manage installed copies",
	Long:    "Print the embedded agent skill to stdout. Subcommands install, list, and uninstall manage copies in agent skills directories resolved by agentdex.",
	Args:    usageArgs(cobra.NoArgs),
	PersistentPreRunE: func(cmd *cobra.Command, args []string) error {
		if !JSONOutput() {
			return nil
		}
		return outputErr(&ErrorPayload{
			Code:    "INVALID_ARGUMENT",
			Message: "skill commands have no JSON mode",
			Fix:     cmd.CommandPath() + " without --json",
		})
	},
	RunE: func(cmd *cobra.Command, args []string) error {
		_, err := fmt.Fprint(stdout, skill.Text())
		return err
	},
}

var skillInstallCmd = &cobra.Command{
	Use:   "install [agents...]",
	Short: "Install the skill into agent skills directories",
	Args:  cobra.ArbitraryArgs,
	RunE:  runSkillInstall,
}

var skillListCmd = &cobra.Command{
	Use:     "list",
	Aliases: []string{"ls"},
	Short:   "List installed copies of the skill",
	Args:    usageArgs(cobra.NoArgs),
	RunE:    runSkillList,
}

var skillUninstallCmd = &cobra.Command{
	Use:   "uninstall [agents...]",
	Short: "Remove installed copies the CLI owns",
	Args:  cobra.ArbitraryArgs,
	RunE:  runSkillUninstall,
}

func init() {
	for _, c := range []*cobra.Command{skillInstallCmd, skillListCmd, skillUninstallCmd} {
		c.Flags().BoolVar(&skillLocal, "local", false, "Use project-local skills roots")
		skillCmd.AddCommand(c)
	}
	rootCmd.AddCommand(skillCmd)
}

func skillLocation() skill.Location {
	if skillLocal {
		return skill.Local
	}
	return skill.Global
}

// Global roots expand from ~, so only --local needs a real working directory.
func openSkillIndex() (*agentdex.Index, error) {
	wd, err := os.Getwd()
	if err != nil {
		if skillLocal {
			return nil, fmt.Errorf("working directory required for --local: %w", err)
		}
		wd = string(filepath.Separator)
	}
	return skill.OpenIndex(wd)
}

func skillTargets(cmd *cobra.Command, idx *agentdex.Index, ids []string) ([]agentdex.Agent, error) {
	if len(ids) > 0 {
		agents, err := skill.Resolve(cmd.Context(), idx, ids)
		return agents, skillErr(cmd, err)
	}
	agents, err := skill.DefaultSet(cmd.Context(), idx)
	if err != nil {
		return nil, skillErr(cmd, err)
	}
	if len(agents) == 0 {
		return nil, skillErr(cmd, skill.ErrNoAgents)
	}
	return agents, nil
}

func runSkillInstall(cmd *cobra.Command, args []string) error {
	idx, err := openSkillIndex()
	if err != nil {
		return err
	}
	agents, err := skillTargets(cmd, idx, args)
	if err != nil {
		return err
	}
	named := len(args) > 0
	var roots []string
	for _, a := range agents {
		root := skill.InstallRoot(skill.ScopeAt(a, skillLocation()), named)
		if root == "" {
			if named {
				return skillErr(cmd, fmt.Errorf("%w: %q", skill.ErrNoSkillsRoot, a.ID))
			}
			continue
		}
		if !slices.Contains(roots, root) {
			roots = append(roots, root)
		}
	}
	if len(roots) == 0 {
		return skillErr(cmd, skill.ErrNoSkillsRoot)
	}
	slices.Sort(roots)
	written, err := skill.Install(roots)
	if err != nil {
		return skillErr(cmd, err)
	}
	return outputData(written)
}
```

`skill list` (`ls` alias, no positionals):

- Open the index, take `DefaultSet`, and for each agent check every root in `Candidates` with `Present`
- Map each present root to the agents that claim it, then sort by path
- Pass `outputData` one `<root>/<cli>/SKILL.md<TAB><agents>` line per copy as a `[]string`, agents sorted and comma-joined
- An empty inventory prints nothing on stdout and calls `outputNotice("not installed")`

`skill uninstall [agents...]`:

- The target set is `skillTargets(cmd, idx, args)`. With named agents, the blocking set is `DefaultSet` minus the targets; with none, it is empty
- Walk the sorted union of `Candidates` across the target set
- A root that a blocking agent also claims is reported as `kept` with the claiming agents, or `absent` when no copy is there, and is never touched
- Every other root goes through `RemoveOwned`
- Pass `outputData` one `<outcome><TAB><root>/<cli>[<TAB><detail>]` line per root as a `[]string`
- Agent selection fails through `skillErr`; an I/O error from `RemoveOwned` returns unconverted

Convert the package's errors at the boundary:

```go
func skillErr(cmd *cobra.Command, err error) error {
	if err == nil {
		return nil
	}
	p := &ErrorPayload{Message: err.Error(), Fix: manualSkillFix}
	var unknown *skill.UnknownAgentError
	switch {
	case errors.As(err, &unknown):
		p.Code, p.Fix, p.ValidValues = "AGENT_UNKNOWN", cmd.CommandPath()+" <agent>", unknown.Known
	case errors.Is(err, skill.ErrNoSkillsConcept):
		p.Code = "NO_SKILLS_CONCEPT"
	case errors.Is(err, skill.ErrNoSkillsRoot):
		p.Code = "NO_SKILLS_ROOT"
	case errors.Is(err, skill.ErrNoAgents):
		p.Code = "NO_AGENTS"
	case errors.Is(err, skill.ErrForeignCopy):
		p.Code, p.Fix = "CONFLICT", "inspect the copy named in the message, remove it if unwanted, and rerun"
	case errors.Is(err, agentdex.ErrCatalogUnavailable):
		p.Code = "CATALOG_UNAVAILABLE"
	case errors.Is(err, agentdex.ErrCatalogInvalid):
		p.Code = "CATALOG_INVALID"
	default:
		return err
	}
	return outputErr(p)
}

const manualSkillFix = "<cli> skill > <agent-skills-dir>/<cli>/SKILL.md"
```

Every code here is in the canonical table (cli/design Rule 5), so `canonicalExit` supplies the exit code: usage codes exit 2, a foreign copy exits 5, an unavailable catalog is transient (exit 75), and an invalid one exits 1. An unknown agent's `fix` repeats the failing command with a placeholder, and `valid_values` lists the catalog's agent IDs (Rule 5); a foreign copy's `fix` is to resolve it by hand; every other `fix` is the manual install path, which needs neither the catalog nor a second CLI.

`skillCmd`'s `PersistentPreRunE` covers its subcommands, and root's hook still runs first through `EnableTraverseRunHooks` (see "Runtime Modes"). A bad flag fails before either hook, so it still reaches the error envelope.
