# start CLI Module Library

CUE-only repository of agent, role, context, task, and skill modules for the [start](https://github.com/p3bot/start) CLI. Each module is published independently to the CUE Central Registry under `github.com/p3bot/library` and discovered through the index module. There is no build step; work is authoring, validating, and publishing CUE modules.

Behaviour and judgment for this repository live in `.agents/roles/default.md`. This file holds the facts.

## Environment

| Tool | Use |
| --- | --- |
| `cue` v0.16.x | Validate and publish. Every `cue.mod/module.cue` pins language `v0.16.0` |
| `start` | Post-publish verification (`start update`, `start doctor validate --force`) |
| `go` | Only for `scripts/render-template.go` (stdlib, no go.mod) |
| `git` with `origin` | Version source of truth and tag pushes |
| `gh` | Closing tracked issues on `p3bot/library` |

Modules resolve `github.com/p3bot/library/schemas@v1` from the registry, not by relative path, so validation needs network access. `cue.mod/pkg/`, `cue.mod/usr/`, `cue.mod/gen/`, and `.start/` are local only.

## Layout

| Path | Contents |
| --- | --- |
| `agents/` | Agent command templates (`agent.cue`) |
| `roles/` | System prompts (`role.cue`, `role.md`), normally agent/assistant/teacher modes |
| `contexts/` | Context fragments (`context.cue`, optional bundled `.md`) |
| `tasks/` | Task prompts (`task.cue`, `task.md`) |
| `skills/` | Agent Skills (`skill.cue`, `SKILL.md`, resources) |
| `schemas/` | The schemas module (`#Base`, `#UTD`, `#Agent`, `#Role`, `#Context`, `#Task`, `#Skill`, `#SkillInstall`, `#Index`, settings) |
| `index/` | Discovery index module, `index/index.cue` |
| `docs/` | Procedures, pattern catalogs, and `docs/examples/` schema examples |
| `scripts/` | Validation and publish helpers, run from the repository root |
| `.agents/roles/` | Repository role for agents working here |

Every module directory is self-contained:

```
tasks/review/pre-commit/
  task.cue
  task.md
  cue.mod/module.cue
```

## Procedures

Read the named document before acting. Do not work from memory.

| Activity | Document |
| --- | --- |
| Choosing a path, package name, or tag | `docs/naming.md` |
| Creating or updating any module | `docs/authoring.md` |
| Publishing, schema-only publish, index-only retire, versioning | `docs/publishing.md` |
| Agent flag tables and variants | `docs/agent-patterns.md` |
| Role mode patterns | `docs/role-patterns.md` |
| Schema fields and examples | `schemas/README.md` |
| Review task families and severity | `docs/review-types.md` |

## Validation

Single module, from its directory (`<module>.cue` is `agent.cue`, `role.cue`, `context.cue`, `task.cue`, or `skill.cue`):

```bash
cd tasks/review/pre-commit
cue mod tidy
cue vet task.cue
cue export task.cue
```

From the repository root:

```bash
scripts/validate-module tasks/review/pre-commit   # vet + export, no tidy
scripts/validate-index                            # after any index/index.cue change
scripts/validate-schemas                          # after any schemas/ change
go run scripts/render-template.go tasks/golang/debug   # render a prompt with live values
```

Schema changes, from `schemas/`:

```bash
cue vet ./...
cue vet *.cue ../docs/examples/<name>_example.cue
```

`docs/examples/` sits outside the schemas module so examples are not published. `docs/examples/locator_reject/` holds fixtures that must fail; `scripts/validate-schemas` checks they fail on `session_locator`.

`scripts/validate-index` also enforces the non-TTY default-resolution contract: a `bin` shared by several agent entries needs at least one entry that is a bare key or ends `/interactive`.

## Addressing

| Form | Example | Where |
| --- | --- | --- |
| Fully-qualified address | `tasks:review/pre-commit` | User input, display, `start get`, `uses` |
| Bare name | `review/pre-commit` | Index keys; cross-category lookup |
| Module path | `github.com/p3bot/library/tasks/review/pre-commit@v1` | CUE imports and `module:` |

- Index keys are bare names inside their category struct; never encode the `category:` prefix
- Names are leaves: no name may be a whole-segment ancestor of another in the same category
- Package name is the last path segment with hyphens stripped (`agents-md` becomes `agentsmd`). Importers of such a module add the `:pkgname` suffix
- Modules have no `name` field; the index key is the identity
- The definition key is the literal category noun (`agent:`, `role:`, `context:`, `task:`, `skill:`)

Runtime references from module prose (`start get contexts:ticket/writing`) must use the colon form and be declared in the definition's `uses` list. `uses` is not a CUE import; never add those modules to `cue.mod` `deps`.

## Templates

UTD fields on contexts, tasks, and roles: `file`, `command`, `prompt`; at least one is required. Resolution priority is prompt > file > command. `file: "@module/<name>.md"` reads from the module bundle; a path without `@module/` resolves against the user's working directory at runtime.

| Placeholder | Value |
| --- | --- |
| `{{.file}}`, `{{.file_contents}}` | File path and contents (read lazily) |
| `{{.command}}`, `{{.command_output}}` | Command string and output (run lazily) |
| `{{.instructions}}` | Task arguments from the CLI; empty otherwise |
| `{{.datetime}}` | Current timestamp |
| `{{.cwd}}`, `{{.home}}`, `{{.user}}`, `{{.hostname}}` | Session environment |
| `{{.os}}`, `{{.os_name}}`, `{{.shell}}` | OS id, distro name, shell basename |
| `{{.git_branch}}`, `{{.git_root}}`, `{{.git_user}}`, `{{.git_email}}` | Git state; empty outside a repository |

Agent command placeholders (`{{.bin}}`, `{{.model}}`, `{{.role}}`, `{{.role_file}}`, flag slots) are documented in `docs/authoring.md`.

Tasks embed small `task.md` files with `{{.file_contents}}` and point at large ones with `Read {{.file}} to understand your task.`

## Index

`index/index.cue` maps bare keys to modules in five structs: `agents`, `roles`, `contexts`, `tasks`, `skills`. Copy an existing entry in the same category rather than writing one from memory:

```cue
"claude-code": {
	module:      "github.com/p3bot/library/agents/claude-code@v1"
	version:     "v1.0.0"
	description: "Claude Code by Anthropic - agentic coding assistant"
	bin:         "claude"
	tags: ["claude-code", "anthropic", "claude", "coding", "agent"]
}
```

Only agent entries carry `bin`. Each role mode is its own entry. The `version` field must equal the module tag being pushed.

## Publishing Rules

`docs/publishing.md` owns the procedure. The rules most often broken:

- Derive versions from `git ls-remote --tags origin`, never from local tags or `scripts/publish-index` (it auto-bumps patch)
- New modules start at `v1.0.0`. Updates default to a minor bump; patch is for no-behaviour fixes only
- Commit the module and `index/index.cue` together in one commit. Schemas have no index entry
- Tags are `<category>/<path>/<version>`, `index/<version>`, and `schemas/<version>`
- Push each tag by name; never `git push --tags`
- Registry tags are immutable. A tag pushed before a failed `cue mod publish` is spent; bump and restart. Never move, delete, or reuse a tag
- Retiring index keys is an index minor on `@v1`, never a major
- `start` does not yet recognise the skills category; verify skills through the registry and git tag instead of `start doctor`

## Shared Template Copies

The per-item finding template (history in `docs/item-by-item-template.md`) is copied into each of these files. Keep them in step when one changes:

- `tasks/review/pre-commit/task.md`
- `tasks/ticket/review/task.md`
- `tasks/design/review/task.md`
- `tasks/review/multi-agent/orchestrator/task.md`
- `skills/finding/one-by-one/SKILL.md`

`tasks/tk/id/review` fetches it from `tasks:ticket/review` at runtime rather than holding a copy.

## Markdown

Agent-facing documents (`role.md`, `task.md`, context `.md`, docs): no bold, italic, horizontal rules, emojis, HTML comments, or task lists; headings to `###`; single blank lines; callout prefixes such as `Note:` without bold; no periods at the end of list items in role prompts. `SKILL.md` follows the Agent Skills specification instead.

## Commits

Use [Scoped Commits](https://scopedcommits.com): `<scope>: <description>`, no `feat`/`fix` prefix, multiple scopes comma-separated. Scope is the module path or area, for example `roles/golang/assistant, index: update golang assistant role`. Do not add `Co-Authored-By` trailers. Commit only when asked.
