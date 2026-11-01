# CLI Design for Agents

The p3bot guide for designing or refactoring CLIs. Apply when generating a new p3bot CLI or auditing an existing one.

A CLI that ships an agent skill uses p3bot tooling: agentdex resolves agent skills roots and start serves the skill writing guide (Rule 10).

In scope: command-based CLIs with subcommands, flags, and well-defined output.

Out of scope: TUI / full-screen apps, GUI apps, REST or GraphQL API design only, shell scripting helpers.

Platforms: Linux, macOS, and WSL. Native Windows is out of scope.

## Core stance

Agents are first-class consumers, not a tolerated secondary audience. The CLI you produce serves agents first; humans benefit from the same design.

Each command has two runtime modes detected from the environment, interactive mode (whether prompts are allowed, gated on stdin) and decoration mode (whether ANSI escapes are allowed, decided separately for stdout and stderr), and one output mode the caller chooses: text by default, JSON via `--json` for parsing. `--json` also turns interactive mode off and keeps ANSI out of stdout. The same command serves both audiences from one code path. See "TTY detection and environment signals" under Cross-cutting for the full list of triggers and rules.

Schema-first generation for large CLIs, or CI lints for smaller ones, keeps a CLI consistent with this guide. See "Schema-first generation" under Cross-cutting.

## Priority tiers

Treat these rules as a guide, not a contract. Every CLI is different — drop, adapt, or extend as the command requires. The verb strength (MUST/SHOULD/MAY) and tier (P0/P1/P2) below signal how much room each rule leaves; MUST marks rules whose absence breaks agents.

Tiers:

- P0: without these the agent breaks. Treat violations as blockers.
- P1: without these the agent works inefficiently. Treat violations as friction.
- P2: without these the CLI works fine. Treat violations as optimization opportunities.

Severity scales with command type. Idempotency is a blocker for mutations and irrelevant for streaming. Apply rules where they make sense for the command at hand.

## P0 — Critical

### 1. Non-interactive by default with wizard fallback in interactive mode

A command MUST never hang waiting for input. Whether the CLI may prompt depends on interactive mode; whether it may decorate output depends on decoration mode. The two are independent — see "TTY detection and environment signals" under Cross-cutting for the full rules.

- Interactive mode on, missing required input: prompt for it (wizard).
- Interactive mode off, missing required input: fail fast with stderr listing the missing flags by name. Exit code 2, error code `INPUT_REQUIRED`.
- `--no-input`, `--json`, `<CLI>_NO_INPUT=1`: never prompt regardless of stdin.

Read stdin only when the caller asks for it with `-` (Rule 3). Agent harnesses and CI runners often leave stdin as a pipe that never closes, so reading it because it is not a terminal hangs.

The same command serves both audiences. The agent passes complete flags and gets a deterministic response; the human at a terminal gets a guided wizard for the missing pieces.

Never prompt for secrets, even in interactive mode. Read secrets from env, file, or stdin only.

### 2. Token-efficient default output

Default output (without `--json`) is the priority output mode. Agents read it directly far more often than they parse JSON; humans read it always. Lean prose, scannable structure, minimal decoration.

- Lead with the answer. No preamble, no banners, no restating of the command the user just ran.
- Pick the format that fits the data — prose for narrative answers, aligned label-value pairs for a single resource, indented hierarchy for nested results, tables for genuinely tabular data.
- Convey structure through whitespace, indentation, and alignment. Avoid literal markdown syntax (`**bold**`, `# heading`, `---` rules), emoji, and box-drawing characters — they cost tokens and most terminals render them as noise. Use ANSI escapes for emphasis only when decoration mode is on, and only sparingly.
- No structural overhead. `Project: CW` rather than `{"project":"CW"}`. JSON wraps every value and key in quotes, separates with commas and braces; default output strips that out.
- For lists, skip per-row labels — a header row or no labels at all beats repeating `Project: X` on every line.
- Empty values render empty. No `null`, no `(none)`, no `-`. The whitespace is unambiguous.
- One blank line maximum between sections. Stacked blank lines are pure waste.
- Surface counts and bounds inline (`Showing 1-1 of 3352 results`) so the reader knows where they are.
- End with the next concrete action when one exists (`(--next <token>)`).
- Same information, fraction of the tokens. That fraction is the win.

`--json` exists for parsing, not as the default. An agent reaches for it when iterating a list, extracting an ID, or branching on `status`. Everything else, default output wins on tokens and readability.

### 3. Structured output (JSON mode)

When the caller opts into JSON mode with `--json`, every data-returning command except the `skill` commands (Rule 10) MUST emit a wrapped envelope with the same outer shape on success and failure so the agent parses once and branches on `status`.

Success:

```json
{"status":"ok","data":{"id":"post_8f2a","title":"Hello"}}
```

Failure:

```json
{"status":"error","error":{"code":"AUTH_EXPIRED","message":"API token has expired","fix":"<cli> auth refresh","transient":false}}
```

Warnings are optional and used for non-fatal conditions the agent can act on programmatically (deprecated flags, partial success on batch operations). Omit the `warnings` key entirely when empty. When present, each entry has the same shape as an error minus `transient` and `valid_values`:

```json
{"status":"ok","data":[{"id":"post_a"},{"id":"post_b"}],"warnings":[{"code":"FLAG_DEPRECATED","message":"--max-results is deprecated, use --limit","fix":"<cli> posts list --limit=10"}]}
```

Rules around the envelope:

- `status` is the string `ok` or `error`. A success always carries `data`; a failure always carries `error`.
- stdout carries only the JSON envelope. Nothing else.
- stderr carries diagnostics, prompts, progress, log lines, debug output.
- Parsers MUST ignore unknown fields anywhere in the response — at the envelope root and inside `data`, `error`, and `warnings` entries. This is the contract that makes additive changes (Rule 12) and `--verbose` field additions (Rule 9) safe; an agent that fails on unrecognised keys converts every minor version bump or verbose invocation into a break.
- ANSI escape codes never appear in stdout under `--json`.
- Under `--json`, `--version` emits `data: {"version": "<semver>"}` and help emits `data: {"help": "<text>"}`, so neither puts prose on stdout.
- Paginated responses include `next` at the envelope root (sibling to `data`) as an opaque cursor token. Omit `next` when no more pages exist:

  ```json
  {"status":"ok","data":[{"id":"post_a"},{"id":"post_b"}],"next":"eyJvZmZzZXQiOjJ9"}
  ```

- Streaming responses (`--follow`, `--watch`, or continuous data) emit NDJSON: one envelope per line. `--follow` is append-only; each line is the next data record. `--watch` is a resource-change stream; CLIs supporting it MUST document the event shape (initial-state replay behaviour, per-event fields, reconnect/resume semantics) in the skill's contract (Rule 10).
- A `-` value means stdin or stdout depending on context.
- Document the envelope shape once, in the skill's contract (Rule 10). Do not repeat it everywhere.
- Commands with binary payloads route bytes via `--output` rather than stdout when `--json` is set. See Rule 14.

Pagination cursors:

- Cursors are short-lived. Valid for at least a normal traversal session (minutes), not guaranteed beyond an hour, never across sessions. Agents MUST NOT persist cursors across long pauses or store them in profiles or config.
- An expired or invalid cursor returns error code `CURSOR_INVALID` with exit code 5 and `transient: false`. The `fix` field instructs the agent to restart the traversal from the beginning. Exit 5 (Conflict) signals the underlying state moved out from under the cursor; exit 2 is reserved for argument mistakes the caller authored, and exit 75 is wrong because retrying with the same cursor fails the same way.
- Cursors are bound to the query that produced them. Reusing a cursor from one query against a different filter, sort, or fields selection is undefined behaviour and SHOULD return `CURSOR_INVALID`.
- Cursors are opaque strings; never document their structure. When the upstream offers only offsets and the data is provably static (an archive of closed records, an immutable log), the CLI MAY page by offset internally, still exposing only `--next`.
- Following upstream pages to fill `--limit` stops at a maximum page count, and the result is trimmed to exactly `--limit`.

### 4. Semantic exit codes

Use this taxonomy. It is anchored on `sysexits.h` (75 transient, 78 configuration) and shell convention (2 usage), so agents and shells generalise across tools:

| Code | Meaning | Action implied |
| --- | --- | --- |
| 0 | Success | Continue |
| 1 | General failure | Do not retry blindly |
| 2 | Usage error | Fix arguments and retry |
| 3 | Resource not found | Surface to user |
| 4 | Permission denied | Authenticate or escalate |
| 5 | Conflict | Current resource state prevents the operation. Examples: version mismatch on `update`, a `create` where an existing resource differs from the request (see Rule 8), or a `CURSOR_INVALID` response when the underlying state moved out from under a pagination cursor (see Rule 3). Re-fetch state and retry |
| 75 | Transient failure | Retry with backoff |
| 78 | Configuration error | User must fix config |

A run ended by a signal exits 128+signum (130 SIGINT, 143 SIGTERM), never 75: an interrupt is the user's intent, not a transient failure.

Code 75 is the explicit retry signal. The agent uses it to decide whether automatic retry is worthwhile. Document the exit codes used by the CLI in the skill's contract (Rule 10).

### 5. Errors that teach and enumerate

Every error MUST carry four elements:

- `code`: UPPER_SNAKE_CASE machine-readable identifier, modelled on gRPC canonical codes. Codes are domain-bare (`AUTH_EXPIRED`), not CLI-prefixed. Reuse a canonical code (below) before coining a domain one.
- `message`: human-readable one-line summary.
- `fix`: concrete next command or action.
- `transient`: retry hint matching exit code 75.

When validation rejects a value against a known set, include `valid_values` listing what would have been accepted. Use cases include enum literals (public, private, unlisted), scheme prefixes (stdout, file:, webhook:, http://), accepted formats (RFC 3339, Unix timestamp), or any closed set the agent can pick from. Omit when the accepted set is open or not enumerable:

```
Error: --visibility must be one of: public, private, unlisted
  Code:     INVALID_VISIBILITY
  Accepted: public, private, unlisted
  Fix:      <cli> post create --visibility=public --content=...
```

Validate inputs before side effects fire. An error after a resource is created is harder to recover from than an error before.

Canonical codes:

Every CLI uses these codes for these conditions, with this exit code and `transient` value. A code outside this table is a domain code: it is specific to one CLI, and the CLI gives it an exit code from the Rule 4 taxonomy.

The skill does not list error codes. Each error teaches itself through `fix` and `transient` at the moment it occurs. A domain code goes in the skill's contract only when the agent must act differently from what its `fix` says.

| Code | Exit | Transient | Condition |
| --- | --- | --- | --- |
| `INVALID_ARGUMENT` | 2 | false | Unknown command or flag, malformed flag value, or wrong argument count |
| `INPUT_REQUIRED` | 2 | false | Required flag or argument missing with interactive mode off (Rule 1) |
| `ENV_REQUIRED` | 2 | false | Required environment variable unset |
| `OUTPUT_REQUIRED` | 2 | false | Binary output under `--json` without `--output` (Rule 14) |
| `INVALID_FIELDS` | 2 | false | Unknown `--fields` name; `valid_values` lists the field set |
| `INVALID_COLOR` | 2 | false | `--color` outside `auto`, `always`, `never` |
| `BAD_REQUEST` | 2 | false | Upstream rejected the request as malformed |
| `AGENT_UNKNOWN` | 2 | false | `skill install` or `uninstall` named an agent the catalog does not know (Rule 10) |
| `NO_SKILLS_CONCEPT` | 2 | false | Named agent has no skills directory |
| `NO_SKILLS_ROOT` | 2 | false | No writable skills root for the target set |
| `NO_AGENTS` | 2 | false | No installed agent has a skills concept |
| `NOT_FOUND` | 3 | false | Resource does not exist |
| `UNAUTHENTICATED` | 4 | false | No credentials available |
| `AUTH_EXPIRED` | 4 | false | Credentials present but expired or revoked |
| `PERMISSION_DENIED` | 4 | false | Authenticated but not allowed |
| `CONFLICT` | 5 | false | Resource state prevents the operation (Rule 8) |
| `CURSOR_INVALID` | 5 | false | Pagination cursor invalid, expired, or bound to another query (Rule 3) |
| `RATE_LIMITED` | 75 | true | Upstream quota hit; `retry_after` when known |
| `UPSTREAM_ERROR` | 75 | true | Upstream failed transiently (timeout, unavailable, 5xx) |
| `WAIT_TIMEOUT` | 75 | true | `--wait` reached `--timeout`; the job ID stays in the response (Rule 11) |
| `CATALOG_UNAVAILABLE` | 75 | true | Agent catalog could not be loaded (Rule 10) |
| `UNKNOWN` | 1 | false | Failure the CLI could not classify; do not retry blindly |
| `UPSTREAM_REJECTED` | 1 | false | Upstream refused the request for a reason not covered above |
| `CATALOG_INVALID` | 1 | false | Agent catalog loaded but failed validation |
| `CONFIG_INVALID` | 78 | false | Config file, profile store, or CLI-owned env var is malformed |

Warning codes ride in `warnings` on a success (exit 0):

| Code | Condition |
| --- | --- |
| `ALREADY_DELETED` | `delete` of an already-deleted resource (Rule 8) |
| `FLAG_DEPRECATED` | A deprecated flag was used; `fix` shows its replacement |
| `DEPRECATED_FIELD` | An envelope field will be removed or renamed (Rule 12); `fix` shows the new shape |

An upstream API's own code may replace `BAD_REQUEST`, `AUTH_EXPIRED`, `UPSTREAM_ERROR`, or `UPSTREAM_REJECTED`. It is then a domain code, and it keeps the exit code and `transient` value of the canonical code it replaces.

Upstream HTTP status:

A CLI over an HTTP API maps a failed response's status to a canonical code. An upstream code replaces the canonical one only where the paragraph above allows.

| Status | Code |
| --- | --- |
| 400 | `BAD_REQUEST` |
| 401 | `AUTH_EXPIRED` |
| 403 | `PERMISSION_DENIED` |
| 404 | `NOT_FOUND` |
| 409 | `CONFLICT` |
| 429 | `RATE_LIMITED` |
| 408, 425, 5xx | `UPSTREAM_ERROR` |
| Other 4xx | `UPSTREAM_REJECTED` |

Rate limiting:

Rate-limit failures use the canonical code `RATE_LIMITED` with exit code 75. When the upstream exposes a retry-after value, include it as an optional `retry_after` field using the duration grammar defined under Cross-cutting (single segment like `30s` or compound like `1h30m`). Agents use `retry_after` when present and fall back to exponential backoff when absent. Copy an HTTP `Retry-After` header on any status, not only 429; a 503 sends it too. The header holds seconds or an HTTP date, and either converts to the duration grammar.

```
Error: API rate limit exceeded
  Code:        RATE_LIMITED
  Retry after: 30s
  Fix:         wait 30s and retry
```

### 6. Bounded output

List-style commands MUST default to a bounded result set. Default `--limit` is in the low tens (10 to 25 is typical). Unbounded output is a blocker for routine commands.

When truncating, the response includes:

- The range and the total count if cheap to compute, surfaced inline: `Showing 1-25 of 3352 results`. When the total is expensive, drop it: `Showing 1-25 results`.
- A `next` cursor token — shown inline as `(--next <token>)` in text, at the envelope root in JSON (see Rule 3). Omit it on the last page; never put the text hint inside the JSON.

Cursor-based pagination via `--next` is the rule. Offset-based pagination drifts when underlying data changes during traversal and is forbidden for mutating data sets.

Support `--fields` on data-bearing commands so the agent requests only the columns it needs. It is the highest-leverage flag for per-call token cost. It takes a comma-separated list. Text output shows only the named columns, in the order given; JSON output keeps only the named keys in each `data` entry. Explicit `--fields` wins over the extra fields `--verbose` adds. The flag's `--help` names the accepted fields, and `INVALID_FIELDS` returns them in `valid_values`.

### 7. Output guides the next action

Every success or failure response MUST suggest what to do next.

- On success: include identifiers and the next-step commands the agent or human is likely to run.
- On failure: include the `fix` element defined in Rule 5.
- On partial result: include the `next` token defined in Rule 6.

The agent reads the output, sees the suggested invocation, and continues without guessing or hallucinating commands.

### 8. Safe retries and explicit mutation boundaries

Mutating commands MUST be safe to retry.

- `create` operations are idempotent. The outcome depends on whether a matching resource already exists:
  - No existing resource: create it. Exit 0.
  - Existing resource matching the request: return the resource with an `existing: true` indicator. Exit 0.
  - Existing resource differing from the request: do not modify it. Exit 5 with error code `CONFLICT`. The caller must `update` (or `delete` and re-`create`) deliberately.

  "Matching" means every field the caller supplied equals the corresponding field on the existing resource. Server-managed fields (IDs, timestamps, computed defaults) are not part of the comparison.
- `update` operations are idempotent on the same input.
- `delete` operations on already-deleted resources return exit 0 with a warning of code `ALREADY_DELETED`. The response describes the resource as it last existed, or carries `data: null` if the CLI keeps no tombstone.
- Destructive operations require an explicit non-default flag. `--force` is the canonical bypass. `--dry-run` never requires `--force`; the preview destroys nothing.
- Every consequential mutation MUST support `--dry-run`. With `--dry-run`, the response has the shape the applied change would return, plus `dry_run: true`, and nothing is applied. Trivial mutations (e.g., appending to a feedback log) and `skill install` and `uninstall` (Rule 10) are exempt. For async submitters (Rule 11), `--dry-run` MUST validate input locally and return the would-be request; it MUST NOT submit a job to the upstream system or write a ledger entry.

For long-running async operations, retry safety extends across the submit-poll-collect arc. See Rule 11.

## P1 — High

### 9. Cross-CLI vocabulary consistency

The agent generalises from every CLI it has seen. A non-conforming CLI succeeds slowly with extra retries and burned tokens. Commands should be guessable from their names and flags self-explanatory; a flag that needs documentation to understand is a naming defect.

Commands take the shape `<cli> <noun> <verb> [args] [--flags]` (`<cli> item list`). A single-domain CLI may drop the noun (`<cli> list`).

Canonical verbs:

| Use | Never as canonical |
| --- | --- |
| get | view, info, show, describe |
| list | ls, all, find |
| create | add, new, make |
| update | edit, modify |
| delete | rm, remove, destroy |
| run | exec, do |
| status | health, state |

Core flags:

| Use | Never as canonical |
| --- | --- |
| --json | --format=json, --output=json |
| --force | --skip-confirmations, --no-confirm, --yes-to-all, --yes |
| --no-input | --non-interactive |
| --dry-run | --plan, --preview, --simulate |
| --quiet | --silent |
| --verbose | — |
| --help | — |
| --version | — |

Data-shape flags:

| Use | Never as canonical |
| --- | --- |
| --limit | --max-results, --count, --max |
| --next | --page, --offset, --cursor |
| --fields | --columns, --select |
| --filter | --where, --query |
| --since | --from, --start-time, --after |
| --until | --to, --end-time, --before |

Operational flags:

| Use | Never as canonical |
| --- | --- |
| --config | --config-file, --conf |
| --debug | --trace, --diagnostics |
| --color | --colour, --ansi |
| --recursive | --recurse, --tree |
| --follow | --tail |
| --watch | --observe, --subscribe |
| --output | --out, --destination, --write-to, --save-to, --target |
| --profile | --config-name, --env-name |
| --wait | --block, --sync |
| --timeout | --time-limit, --max-duration, --deadline |

Subcommand groups when the rule applies:

| Group | Subcommands |
| --- | --- |
| auth | login, logout, status, refresh |
| jobs | list, get, cancel, prune, repair |
| profile | save, use, list, get, delete |
| feedback | (root verb takes a string), list |

Auth semantics:

- `auth login` initiates authentication. May open a browser in interactive mode; otherwise requires credentials via env, file, or stdin (see Secrets handling).
- `auth logout` clears local credentials. Idempotent — logout when already logged out returns 0.
- `auth status` reports the current authentication state. Exit 0 with the authentication state surfaced as `authenticated: true|false`. The authenticated form includes identity and expiry; the unauthenticated form includes a `reason` explaining why (no token, expired, revoked). Exit 4 if `auth status` itself cannot run because the credentials store is unreadable (filesystem permissions, OS keychain access denied); exit 78 only when the store is structurally invalid (malformed config, unknown schema).
- `auth refresh` renews an expiring token without re-authenticating. Exit 0 on success, exit 4 if refresh fails.

Notes that travel with the table:

- `--debug` enables diagnostic logging on stderr only. Never affects stdout regardless of mode. `<CLI>_DEBUG` set to a truthy value enables it for every invocation in the environment.
- `--verbose` adds detail to stdout. In text mode, more fields or lines appear on the rendered output. In JSON mode, the additional detail appears as extra fields on `data`; the envelope shape is unchanged, so existing parsers that ignore unknown fields (Rule 3) keep working.
- `--debug` and `--verbose` are different flags and may be set together.
- `--color` values are auto (default, decoration per stream from the environment), always, never. The flag overrides `NO_COLOR` and `FORCE_COLOR` (see "TTY detection and environment signals").
- Prefer enum values (`--color=never`) over negation flag pairs (`--no-color`).
- `--quiet` suppresses non-error output. Stdout emits requested data only; stderr emits errors only; warnings, progress, and informational output are dropped.
- When `--quiet` and `--json` are both set, `--json` governs stdout — the full envelope is emitted including any warnings. `--quiet` only suppresses stderr informationals.
- Absolute times on `--since` and `--until` use RFC 3339 (`2026-04-30T18:22:11Z`); relative times use the duration grammar (see Cross-cutting).
- `--timeout` takes a duration value (see Cross-cutting) and is paired with `--wait` (Rule 11).

Aliases:

The CLI MAY expose any name from the Never column as an alias of the canonical for muscle memory or backward compatibility, with one constraint: an alias must point to a canonical that performs the same conceptual operation. `ls` aliasing `list` is fine. `ls` aliasing `delete` is not. Aliases live in `--help` only — they do not appear in the skill.

`view` SHOULD alias `get`: agents trained on `gh` and `glab` reach for it.

Short forms:

Short single-letter flags exist as 1:1 aliases of long flags, never independent. Within a CLI, a letter means one flag on every command that has it. The CLI maintainer binds short letters per CLI domain — the same letter may mean `--limit` in one CLI and `--list` in another, so no cross-CLI bindings are prescribed here. Agents emit long forms by default and only use short forms when documented in the CLI's `--help`. Help examples, `fix` values, and the skill use long forms, because agents copy them. Capital-letter short forms (e.g., `-r` and `-R`) are acceptable only for semantically related or inverse pairs, never as a generic disambiguation tactic.

Singular vs plural noun forms:

Pick one form (singular or plural) for the CLI's resource namespaces and use it consistently across every command. Always alias the other form so both invocations resolve to the same handler. Lean singular as the default — it composes more naturally with single-resource verbs (`post get <id>`).

Domain-specific verbs (publish, deploy, render) stay domain-specific. Name them consistently within the CLI and document them once in the skill.

### 10. Agent skill

Does this CLI need an agent skill? Ask the user when they have not said.

A skill earns its place when agents use the CLI repeatedly and need what `--help` and error output cannot teach at the moment of use: required env vars, invariants whose violation causes damage, workflows across commands. A small CLI that `--help` explains does not need one.

Without a skill, whatever this guide assigns to the skill goes in the root `--help`, and the rest of this rule does not apply.

With one, the CLI ships its agent documentation as an Agent Skill (https://agentskills.io/specification): a `SKILL.md` embedded in the binary and installable into agent skills directories.

Two surfaces:

- `<cli> --help` and `<cli> <subcommand> --help`: the complete per-command reference, for humans and for agents recovering from a usage error. Every flag, its accepted values, usage, and 2–3 examples per subcommand. Terse, because agents read it. Aliases appear here, not elsewhere
- The skill: the agent contract. Read once on first contact, then loaded by the agent's skill system on demand

There is no third surface: no `help <topic>` pages. Agent-facing detail goes in the skill.

On first encounter with an unfamiliar CLI, the agent SHOULD load the installed skill or run `<cli> skill` before invoking commands, and fall back to `<cli> --help` when it has none.

Commands:

| Command | Behaviour |
| --- | --- |
| `<cli> skill` | Print the embedded `SKILL.md`, frontmatter included, to stdout. Needs no config, auth, scope, or network |
| `<cli> skill install [agents...]` | Write `<root>/<cli>/SKILL.md` into each target agent's skills root, replacing any copy the CLI owns. Print each written path |
| `<cli> skill list` | Print each installed copy as `<path>\t<agents>`, where agents are the installed agents that claim that root |
| `<cli> skill uninstall [agents...]` | Remove installed copies the CLI owns. Print one line per root: `removed`, `absent`, or `kept` with the reason |

`install`, `list`, and `uninstall` take `--local` to act on project-local skills roots instead of global ones. `skills` is an alias of `skill`.

The `skill` commands have no JSON mode: an agent reads their text directly. `--json` on one fails with `INVALID_ARGUMENT` (exit 2), so stdout under `--json` is never prose.

`install` and `uninstall` have no `--dry-run` or `--force`: they touch only copies the CLI owns and can regenerate.

Agent resolution:

- Resolve skills roots from the agentdex catalog (https://github.com/p3bot/agentdex): its library in Go, its `agentdex` binary from other languages. Never hardcode product paths
- No agent arguments: every installed agent that has a skills concept, at its primary root
- Named agents: the agent's native root, else the shared agents root. Named agents resolve even when not installed
- An unknown agent, an agent without a skills concept, a named agent without a writable root, or an empty default set is a usage error (exit 2)
- A root shared by several agents is written once. Output is sorted by path
- When the catalog is unavailable or invalid, the `fix` points to `<cli> skill` and a manual copy into the agent's skills directory

Install safety:

- Replace `<root>/<cli>/SKILL.md` only when it is absent or its frontmatter `name` is the CLI name
- Anything else at that path is a foreign copy. Fail with `CONFLICT` (exit 5) naming it, and write nothing to any root

Uninstall safety:

- Remove `<root>/<cli>/` only when it holds `SKILL.md` alone and that file's frontmatter `name` is the CLI name. Otherwise keep it and report why
- Keep a root that an installed agent outside the target set still claims, and report the claiming agents
- An absent copy is exit 0, so uninstall is safe to retry

`skill list` with nothing installed exits 0. It prints nothing on stdout and a note on stderr.

Installed copies are snapshots of the binary that wrote them. `<cli> skill` always matches the running binary; re-run `<cli> skill install` after upgrading.

`SKILL.md` content:

Write the skill with the skill writing guide (`start get contexts:skill/writing`). It owns the description, body structure, headings, and markdown. A CLI built to this guide adds:

- Frontmatter `name` is the CLI name; install and uninstall rely on it to recognise their own copies
- The facts an agent must hold before its first command, at the top of the body: required and optional env vars, the stdin sentinel, what lands on stdout versus stderr, when to reach for `--json`, and any invariant whose violation causes damage
- A commands catalogue: one code block listing every command by its canonical name, one per line, with realistic flags. Aliases never appear
- The contract: what the agent cannot learn from a single response. The exit codes used, the JSON envelope shape, streaming event shapes, CLI-defined `--output` destination fields, and any domain code whose handling differs from its `fix` (Rule 5). Documented once
- Workflows as `cmd -> cmd -> cmd` chains for orienting, the core work loop, and recovery
- No live values. The file is static and copied, so it never lists profile names or reports configured endpoints; it names the command that reports them

A test keeps the catalogue in step with the command tree (see "Schema-first generation").

Sample:

````
---
name: <cli>
description: >-
  Issue tracking with the <cli> CLI: list, create, and update issues in a
  project. Use when the user mentions issues, the board, or <cli> — even if
  they only say "what's open" or "file a bug".
---

# Issue tracking with <cli>

- <CLI>_API_TOKEN env required; <CLI>_PROJECT sets the default project
- `--file -` reads a body from stdin
- Data on stdout; diagnostics on stderr
- Use --json only when parsing

## Commands

```
<cli> issue list [--status S] [--limit N]          # Bounded list; --next cursor when more exist
<cli> issue get <id>                               # One issue as label-value pairs
<cli> issue create --subject <s> [--file F]        # Create; existing: true when it already matches
<cli> issue update <id> [--subject S] [--file F]   # Idempotent on the same input
<cli> profile list                                 # Saved profile names
<cli> skill                                        # Print this skill
<cli> skill install [agents...] [--local]          # Install into agent skills directories
<cli> skill list [--local]                         # Installed copies and the agents claiming them
<cli> skill uninstall [agents...] [--local]        # Remove copies the CLI owns
```

## Contract

- Exit: 0 ok, 2 usage, 3 not found, 4 auth, 5 conflict, 75 retry, 78 config
- --json: {"status":"ok","data":...,"next":"..."} | {"status":"error","error":{code,message,fix,transient}}

## Workflows

Triage: `<cli> issue list --status Open` -> `<cli> issue get <id>` -> `<cli> issue update <id>`
````

### 11. Async-aware execution

A command that submits an asynchronous job MUST support `--wait`, which blocks until the job completes and returns the final result in the same shape as the synchronous case. `--wait` MUST pair with `--timeout <duration>` defaulting to 10 minutes. On timeout, exit code 75 is returned with the job ID in the response so the agent can resume polling later.

Without `--wait`, the response includes the job ID and status. The agent can poll, but the recommended path is to let the CLI handle polling with backoff and jitter behind `--wait`.

Async state lives in a persistent ledger, `jobs.jsonl` in the state directory (see "User directories"). One JSON record per line:

```json
{"job_id":"job_8f2a","kind":"video.render","status":"complete","submitted_at":"2026-04-30T18:22:11Z","started_at":"2026-04-30T18:22:13Z","completed_at":"2026-04-30T18:22:48Z","duration_s":35,"result":{"url":"https://.../out.mp4"}}
```

Each state change appends a full snapshot of the job, never a delta. The last valid record for a job ID is its current state, so a skipped malformed line falls back to the previous complete state. `jobs list` shows one row per job.

The CLI MUST expose `<cli> jobs list`, `<cli> jobs get <id>`, `<cli> jobs cancel <id>`, `<cli> jobs prune`, and `<cli> jobs repair`. `jobs prune` removes every record of a job whose current status is terminal (complete, failed, cancelled) and whose `completed_at` is older than 30 days by default; `--older-than <duration>` and `--status <status>` narrow the scope. `jobs repair` is the recovery path for a corrupted ledger (see below) and is kept distinct from `prune` so its semantics never overlap with age- or status-based removal. Both support `--dry-run` (Rule 8), reporting the records or line numbers they would remove. The ledger lets a `--wait` invocation killed mid-poll find its existing job on retry rather than submitting a duplicate.

On SIGINT during `--wait`, the CLI exits 130 (128+SIGINT); on SIGTERM, exit 143 (128+SIGTERM). The job ID is written to stderr in both cases. The upstream job continues running; the ledger entry remains marked in-progress. Resuming is an explicit action — the agent re-invokes `--wait` against the same job ID to continue polling, or `<cli> jobs cancel <id>` to stop the work. Exit 75 is reserved for transient failures the caller MAY retry automatically; signal interrupts are the user's intent and MUST NOT be conflated with that signal.

Ledger durability:

- Concurrent invocations on the same host MUST NOT corrupt the ledger. Implementations append in a way that is safe against other invocations writing at the same time.
- The ledger is a per-host artifact. It MUST NOT be assumed shareable across hosts, even when the state directory resolves to a networked filesystem.
- Reader tolerance. `jobs list`, `jobs get`, and `jobs prune` MUST skip malformed lines, emit a stderr warning naming the line number, and continue. A corrupted ledger is degraded but usable.
- Recovery. `<cli> jobs repair --force` rewrites the ledger keeping only valid lines, replacing the original atomically. The dropped lines cannot be restored, so repair is destructive and requires `--force` unless `--dry-run` is set (Rule 8).

### 12. Contract stability

The CLI's existing surface is a contract. Once shipped, every flag name, subcommand name, exit code meaning, default text output structure, and JSON envelope field is part of that contract.

Additive changes are always safe:

- Adding a new flag with a default that preserves existing behaviour.
- Adding a new field to default text output (preserving existing fields).
- Adding a new optional field to the JSON envelope.
- Adding a new subcommand.
- Classifying a failure that previously exited 1 (`UNKNOWN`) into a taxonomy exit code and its canonical error code. Callers rely on exit 1 only as "unclassified"; note the reclassification in the changelog because it can change retry behaviour.
- Adding `--json`, `--fields`, `--quiet`, `--dry-run` where they did not exist.

Breaking changes require a major version bump:

- Removing or renaming a flag, subcommand, or env var.
- Changing the meaning of an existing exit code.
- Removing or renaming a field in default text output.
- Removing or renaming a JSON envelope field.
- Changing default behaviour of an existing command.
- Changing positional argument order.

The CLI's semantic version is the contract version, reported by `<cli> --version`. Any additive change MUST bump at least the minor version; any breaking change MUST bump the major version. The bump records the surface change; it is not itself the change.

The skill ships inside the binary, so `<cli> skill` always describes the running version. Change `SKILL.md` in the same commit as the surface it documents.

When deprecating, emit a stderr warning on the old form and keep it working through one major version. Under `--json`, the warning rides in `warnings` instead: `FLAG_DEPRECATED` for a flag, and `DEPRECATED_FIELD` at least one release before an envelope field is removed, renamed, or retyped. Its `message` names the field and its successor or removal release; its `fix` shows the new shape, so an agent branches on the code rather than diffing responses.

When in doubt, add. Do not modify.

## P2 — Compounding

### 13. Persistent identity through profiles

Applies when users routinely switch between accounts, tenants, or endpoints. Profiles save re-specifying the same flags for each one. Most CLIs need env vars and the user config file only.

When adopted, the CLI MUST expose:

- `<cli> profile save <name> [flags...]` — saves a named bundle of flag values.
- `<cli> profile use <name>` — sets the active profile for subsequent invocations.
- `<cli> profile list` — lists saved profiles.
- `<cli> profile get <name>` — shows the contents of a profile.
- `<cli> profile delete <name>` — removes a profile.
- `--profile <name>` as a persistent root flag that overrides the active profile for one invocation.

Profile storage: `profiles.<ext>` in the config directory, in the CLI's config file format (see "Configuration precedence").

`profile save` never persists credential-source flags (`--token-file` and similar). Profile storage uses normal file permissions and is not a secrets store.

`profile delete` of a name that does not exist exits 0 with an `ALREADY_DELETED` warning (Rule 8).

The skill names `<cli> profile list` as the way to discover identities, so the agent never reads config files. It never lists profile names itself — they are live data and the skill is a static copy.

### 14. Two-way I/O

Output destinations. The `--output` flag accepts scheme-prefixed values that route the artifact to where it is needed:

| Value | Behaviour |
| --- | --- |
| `stdout` or `-` | emit to stdout |
| `file:<path>` or bare path | write atomically to the file (write to temp, then rename) |
| `webhook:<url>` or `http(s)://<url>` | POST the payload to the URL; surface HTTP status in the response |
| (CLI-defined) | e.g., `s3:<bucket>/<key>`, `gs://<bucket>/<key>` |

Unknown schemes return a structured error listing the supported set.

Binary output. Commands producing binary payloads (downloads, renders, exports) MUST require `--output` to specify a destination when `--json` is set. Under `--json`, the response describes the artifact but does not embed the bytes. Common fields (`id`, `bytes`, `sha256`, `content_type`) appear regardless of destination. A `destination` object carries scheme-specific fields:

```
ID:           blob_8f2a
Bytes:        4815162342
SHA256:       a1b2...
Content type: application/octet-stream
Destination:  file ./out.bin
```

Destination shapes:

| Scheme | Required `destination` fields |
| --- | --- |
| `file` | `scheme`, `path` |
| `webhook` / `http(s)` | `scheme`, `url`, `http_status` |
| `stdout` | `scheme` only |
| CLI-defined | `scheme` plus the fields documented in the skill's contract |

Without `--json`, default behaviour is preserved (binary to stdout if no `--output` given, or to the destination if specified). When `--json` is set and `--output` is omitted on a binary-producing command, fail fast with exit 2 and error code `OUTPUT_REQUIRED`, listing supported schemes in `valid_values`.

Feedback channel. The CLI SHOULD expose:

- `<cli> feedback "<text>"` — records the entry as one JSONL row in `feedback.jsonl` in the state directory. Record shape: `{"timestamp":"<RFC 3339>","text":"<message>","cli_version":"<semver>","command_context":"<last invocation, optional>"}`.
- `<cli> feedback list` — lists local feedback entries.

When the env var `<CLI>_FEEDBACK_ENDPOINT` is set to a URL, the CLI also POSTs the entry upstream and surfaces the HTTP status in the response. Every `feedback` response states whether the entry was sent upstream, so the agent learns whether the channel is configured without reading the environment.

Friction observed by agents — flags rejected for the wrong reason, ambiguous error messages, race conditions in async paths — flows back to the maintainer through this channel.

## Cross-cutting

### TTY detection and environment signals

Two independent runtime modes are detected from the environment.

Interactive mode (whether prompts are allowed) is on when stdin is a terminal AND none of `--no-input`, `--json`, `<CLI>_NO_INPUT=1` are set. Otherwise off.

Decoration mode (whether ANSI escapes are allowed) is decided separately for stdout and stderr. The first matching rule wins:

1. `--color=always` turns it on; `--color=never` turns it off. A per-invocation flag overrides the environment (https://no-color.org)
2. `NO_COLOR` set to a non-empty value turns it off
3. `FORCE_COLOR` or `CLICOLOR_FORCE` set to a non-empty value turns it on (https://force-color.org)
4. `TERM=dumb` turns it off
5. Otherwise it is on when that stream is a terminal

Under `--json`, stdout carries only the envelope and never ANSI, whatever its decoration mode.

Animation (spinners, progress bars, rewriting a line in place) runs on a stream only when its decoration mode is on, the stream is a terminal, and `--quiet` is unset. Forced colour reaches logs; animation never does.

The `CI` environment variable is intentionally not consulted. CI environments suppress prompts and decoration via the absence of a TTY, which is reliable; reading `CI=true` is not (developers commonly export it for unrelated reasons). CI configurations that allocate a PTY MUST set `--no-input` or `<CLI>_NO_INPUT=1` explicitly. Pipelines that want colour in their log viewer set `FORCE_COLOR=1`.

`--quiet` controls output volume, not decoration or interactive mode. It drops animation along with warnings and informational output (Rule 9). A human running an interactive command with `--quiet` still gets prompted for missing input.

### Configuration precedence

Highest priority first:

1. Explicit flag on the command line.
2. Environment variable specific to the CLI.
3. Profile selected via `--profile` (when the CLI has profiles).
4. Active profile from `profile use` (when the CLI has profiles).
5. User config file: `config.<ext>` in the CLI's config directory. `--config <path>` reads the named file in its place.
6. System config file: the first `<cli>/config.<ext>` across `$XDG_CONFIG_DIRS` (default `/etc/xdg` on Linux and WSL; macOS uses it only when set). Relative entries are ignored, and later directories are not merged.
7. Built-in default.

Env vars outrank `--profile` so a per-shell override beats the loaded profile. Use `--profile` to swap identities; use env to override one setting.

Each CLI uses one config file format for every tier.

No project tier. Never walk the filesystem for `.<cli>.*` files: behaviour would change with the working directory without the caller seeing why, and a cloned repository could redirect endpoints that receive credentials. Express per-project needs through env, `--profile`, or `--config <path>`.

A missing or unreadable file at a default location is skipped; an unreadable one also gets a stderr warning. A file named with `--config` that cannot be read, or any malformed config file, is `CONFIG_INVALID` (exit 78).

Report every configuration error found in one pass, so the user fixes them together.

### User directories

Every file the CLI owns lives in one of four per-user tiers. On Linux and WSL the tiers follow the XDG Base Directory Specification (https://specifications.freedesktop.org/basedir-spec/latest/). macOS defaults to its native locations but honours an explicitly set XDG variable, so users who keep dotfiles in XDG locations get the same behaviour on every platform.

| Tier | Holds | Env var (any OS) | Linux / WSL default | macOS default |
| --- | --- | --- | --- | --- |
| config | User-edited settings, profiles | `$XDG_CONFIG_HOME` | `~/.config` | `~/Library/Application Support` |
| data | User data that is not config (downloads, assets) | `$XDG_DATA_HOME` | `~/.local/share` | `~/Library/Application Support` |
| state | Runtime history (jobs ledger, feedback log) | `$XDG_STATE_HOME` | `~/.local/state` | `~/Library/Application Support` |
| cache | Regenerable data | `$XDG_CACHE_HOME` | `~/.cache` | `~/Library/Caches` |

The CLI appends its own name to the base: `~/.config/<cli>`. On macOS, where the defaults share a base, each tier adds its own subdirectory: `~/Library/Application Support/<cli>/config`, `/data`, and `/state`. The rules below name these as the config, data, state, and cache directories.

- An XDG variable is used only when it holds an absolute path. Unset, empty, and relative values are treated as absent and the platform default applies; the spec requires relative paths to be ignored
- Never write config to the state or cache tier, or state and cache to the config tier. The split lets users back up and sync config independently of everything else
- Before writing, create a missing directory with mode `0700`. Never change the mode of a directory that already exists

### Environment variables

CLI-specific env vars use the form `<CLI>_<NAME>` where `<CLI>` is the uppercase command name and `<NAME>` is SCREAMING_SNAKE_CASE. Examples: `MYCLI_API_TOKEN`, `MYCLI_PROJECT`, `MYCLI_NO_INPUT`, `MYCLI_FEEDBACK_ENDPOINT`.

Standard cross-CLI env vars (`NO_COLOR`, `FORCE_COLOR`, `TERM`, `XDG_*`, `HOME`, `PATH`) keep their published names and semantics without the `<CLI>_` prefix. Do not shadow them with CLI-prefixed parallels; agents and shells set the standard names once for the whole environment.

CLI-owned boolean env vars accept `1`, `true`, `yes` (case-insensitive) as truthy and `0`, `false`, `no` (case-insensitive) or unset as falsy. Any other value is a configuration error (exit 78), so a typo fails rather than reading as false.

Vendor fallbacks. A CLI in a tool family with its own namespace (Atlassian, AWS) MAY accept the vendor-prefixed name as a fallback: `AJIRA_API_TOKEN` wins, `ATLASSIAN_API_TOKEN` fills in, and neither set is an error. Opt in per variable (tokens, base URLs, default project IDs), never blanket. Name the fallback at the top of the skill's body: `Token: AJIRA_API_TOKEN (or ATLASSIAN_API_TOKEN)`.

### Duration values

Every flag or field that accepts a duration uses one grammar: one or more `<n><unit>` segments where `<n>` is a positive integer and `<unit>` is `s`, `m`, `h`, or `d`. Segments MUST appear in descending unit order (`d`, `h`, `m`, `s`) and each unit MUST appear at most once. Examples: `30s`, `5m`, `2h`, `7d`, `1h30m`, `2d12h`.

- Mixed orderings (`30m1h`) and repeated units (`1h2h`) are usage errors (exit 2).
- `0` is reserved to mean "no limit" or "instant" depending on context. The CLI documents the semantics per flag.
- Applies to `--timeout`, `--since`/`--until` (relative form), `retry_after`, `--older-than`, and any future duration-bearing flag or field.

### Secrets handling

Never accept secrets via flags. A command line leaks to process listings (`ps` shows argv to other users), shell history, CI logs, terminal scrollback, and usage messages that echo the failing invocation. A token passed once as `--token <value>` is permanently compromised.

Accept secrets through exactly three paths, in order of preference:

1. Environment variable (`<CLI>_API_TOKEN`, with any vendor fallback). The canonical channel.
2. File reference flag: a `*-file` flag whose value is a path (`--token-file`, `--client-secret-file`). Warn on stderr when the file is world-readable.
3. Stdin pipe, for secrets generated or piped from another tool (`docker login --password-stdin`).

There is no fourth path: no `--token`, `--password`, or `--api-key`. When a library wants the secret as a string, read it from one of the three paths and pass the value through.

Never log secrets in `--debug` or `--verbose` output. Redact credential-bearing headers (`Authorization`, `Cookie`, API-key headers, and any the CLI documents); when in doubt, redact. Never log request or response bodies that may hold secrets (token issuance, session refresh, config reads); body logging, if offered, is a separate opt-in flag.

### Shell completion

The CLI SHOULD ship completion scripts for at least bash and zsh, exposed via `<cli> completion <shell>` writing to stdout. Completion is a human-experience feature; agents do not consume it. Generation MUST NOT depend on running an upstream call — completion scripts are static artifacts and shells invoke them on every keystroke.

### Schema-first generation

For CLIs of meaningful size or shipping parallel surfaces (SDK, MCP server, Terraform provider, OpenAPI docs), generate the surface from a single schema rather than writing each command by hand. The schema enforces vocabulary, the skill's command reference, and shape consistency mechanically. An MCP server's tool descriptions are a token budget paid on every tool listing; target about 50 tokens each.

For smaller hand-written CLIs the rules apply equally, enforced by CI lints. These lints carry most of the weight:

- Banned-verb / banned-flag check. Walk the parser definition, fail the build on any verb or flag in the "Never as canonical" columns of Rule 9 unless explicitly registered as an alias of its canonical.
- Envelope-shape validation. For every command supporting `--json`, run it under `--dry-run` (or against a fixture) and assert the response parses, contains `status`, and matches the success or error shape from Rule 3.
- Skill drift check, when the CLI ships a skill. Diff the commands enumerated by the parser against the skill's commands catalogue; fail when a canonical subcommand appears in one but not the other, when the skill names a flag the parser does not define, or when an alias appears in the skill. Flags missing from the skill are fine; `--help` covers them.

Lints catch drift that review misses.

## Anti-patterns

Each anti-pattern is followed by a one-line detection cue.

- Decoration when decoration mode is off. ANSI escape codes, spinners, or animated progress on a stream whose decoration mode is off. Detection: run `<cli> ... 2>&1 | cat -v`; if `^[[` sequences appear, the rule is violated.
- Interactive prompt with no flag bypass. Command hangs when stdin is `/dev/null`. Detection: run with `< /dev/null` and a 10s timeout; if it does not exit, the prompt has no bypass.
- Silent success or silent failure. Command exits without output even though state changed, or fails without explanation. Detection: an exit-0 with empty stdout and no `--quiet` flag.
- Mixing data and diagnostics on stdout. Anything that isn't part of the requested response (raw text warnings, log lines, debug output) on stdout corrupts downstream consumers in either mode. In text mode, warnings belong on stderr; in JSON mode, structured warnings inside `warnings[]` are fine. Detection: `<cli> ... --json | jq .` fails.
- Verbose default output without `--fields` or `--quiet`. A single command emits hundreds of lines into agent context. Detection: a routine list command exceeding a screenful of output by default.
- Renaming or removing existing flags, exit codes, or JSON envelope fields without a major version bump. Detection: a diff that touches the flag table or envelope keys without a changelog entry.
- Designing humans-first then bolting agent support on later. Symptom: `--json` was added recently and only covers half the commands; or default output is verbose, decorated, and unbounded with no thought to token cost. Detection: `--json` not supported uniformly, or default output bloated by JSON-style overhead and decoration.
- Inconsistent verbs and flag names within the same CLI. `posts list` uses `--limit` but `comments list` uses `--max-results`. Detection: scan the flag table; flag names must match across resources for the same operation.
- Returning prose error under --json. `--json` is set but stdout carries unstructured text instead of an envelope. Detection: `<cli> bogus-subcommand --json 2>/dev/null | jq .` returns a parse error or empty result. The argument parser must be `--json`-aware before any error fires; the same applies to panic handlers and any sub-process the CLI shells out to (capture and re-wrap their stderr rather than letting it leak to the user's stdout).
- JSON output by default. The CLI emits a JSON envelope when `--json` was not set, forcing humans and agents to parse braces and quotes for routine commands. Detection: `<cli> some-cmd` without `--json` returns text containing `{` and `"`.

## Auditing

Walk Rules 1 to 14 in order, then Cross-cutting. Failures in earlier tiers are more severe. Run each anti-pattern's detection cue against the CLI.
