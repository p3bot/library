# start CLI Library

CUE-based module library for the start AI agent launcher CLI. Modules include agents, roles, contexts, and tasks, published to the CUE Central Registry under `github.com/start-cli/library`.

## Repository Structure

| Directory | Purpose |
| --- | --- |
| agents/ | AI CLI tool command templates |
| roles/ | System prompt and behaviour definitions |
| contexts/ | Environmental context definitions |
| tasks/ | Task instruction definitions |
| schemas/ | CUE schema definitions |
| index/ | Module discovery index |
| docs/ | Naming standards and authoring patterns |

## Code Style

CUE conventions:

- Modules are identified by index keys, not by `name` fields
- Use kebab-case for tags and identifiers
- Schemas define pure constraints without defaults
- Package names match the deepest directory segment (hyphens removed)
- Import schemas from `github.com/start-cli/library/schemas@v1`
- CUE language pin: `v0.16.0` in every `cue.mod/module.cue`

Markdown for agent documents:

- No bold, italic, horizontal rules, or emojis
- Use headings, code blocks, tables, and lists
- Keep heading depth at `###` maximum
- Single blank lines between sections
- Callout prefixes (Note:, Warning:) without bold

## Address Scheme

User-facing fully-qualified module addresses use the colon form `category:name`:

- `agents:claude/interactive`
- `roles:golang/assistant`
- `contexts:cwd/agents-md`
- `tasks:review/git-diff`

Bare names (`claude/interactive`) continue to work as cross-category lookups. CUE module paths (`github.com/start-cli/library/agents/claude/interactive@v0`) remain slash-based; the colon form applies to user-facing input and display only.

Index keys inside the index module are bare names within their category struct (`agents: { "claude/interactive": ... }`). The colon prefix is not encoded in keys.

### Recursive Module References

When a published module's content fetches another library module at runtime with `start get`, the reference must use the fully-qualified colon form (`category:path`, e.g. `start get contexts:start/library/publishing`), not a bare name. Declare every such reference in the module's `uses` field in its CUE definition:

```cue
uses: ["contexts:start/library/publishing"]
```

`uses` records runtime fetches only. It is not a CUE import — do not add the referenced module to `cue.mod` `deps`.

## Module Patterns

UTD (Unified Template Design):

| Field | Purpose |
| --- | --- |
| file | Path to file (provides `{{.file}}`, `{{.file_contents}}`) |
| command | Shell command (provides `{{.command}}`, `{{.command_output}}`) |
| prompt | Go template with placeholders |

Resolution priority: prompt > file > command. At least one of the three must be present.

Common placeholders:

- `{{.file}}` - File path (local or temp)
- `{{.file_contents}}` - File contents (lazy, only read if referenced)
- `{{.command}}` - Command string
- `{{.command_output}}` - Command execution output (lazy, only executed if referenced)
- `{{.datetime}}` - Current timestamp in RFC3339 format
- `{{.instructions}}` - CLI argument passed to a task (empty otherwise)
- `{{.cwd}}` - Current working directory
- `{{.home}}` - User home directory
- `{{.user}}` - System username
- `{{.hostname}}` - Machine hostname
- `{{.os}}` - OS identifier (linux, darwin, windows)
- `{{.os_name}}` - OS/distro name
- `{{.shell}}` - Current shell basename
- `{{.git_branch}}` - Current git branch (empty if not in a repo)
- `{{.git_root}}` - Git repository root directory (empty if not in a repo)
- `{{.git_user}}` - Git user name
- `{{.git_email}}` - Git user email

Module file structure:

Each module contains a CUE definition file and `cue.mod/module.cue`. Modules carrying long-form prose also ship a markdown file referenced via `file: "@module/<name>.md"`.

```
tasks/review/git-diff/
  task.cue
  task.md
  cue.mod/
    module.cue
```

Index updates:

When adding a new module, register it in `index/index.cue`:

```cue
"category/name": {
    module:      "github.com/start-cli/library/<category>/<name>@v0"
    version:     "v0.1.0"
    description: "Brief description of the module"
    tags: ["relevant", "tags"]
}
```

## Validation

Schema validation from the schemas directory:

```bash
cd schemas
cue vet utd.cue task.cue ../docs/examples/task_example.cue
cue vet utd.cue role.cue ../docs/examples/role_example.cue
cue vet utd.cue context.cue ../docs/examples/context_example.cue
cue vet agent.cue ../docs/examples/agent_example.cue
cue vet index.cue ../docs/examples/index_example.cue
```

Module validation from a module directory (resolves `schemas@v1` from the registry):

```bash
cd agents/claude/interactive
cue mod tidy
cue vet ./...
```

Index validation (cue vet plus the non-TTY default-resolution contract for the agents map):

```bash
scripts/validate-index
```

## Publishing

Publishing a module to the CUE Central Registry follows one canonical workflow. Load it and follow it whenever you create or update a module:

```bash
start get contexts:start/library/publishing
```

It owns the full procedure — validation, version determination from the remote, tag-collision preflight, the mandatory index update, the single module-plus-index commit, the explicit tag pushes, the registry publish, and verification.

## Versioning

Every new module debuts at `v1.0.0`, never `v0.x`. From there, versioning follows SemVer, with a minor bump as the default for additive or behavioural content changes. Reserve patch for trivial fixes with no behavioural effect and major for breaking a contract consumers rely on. The publishing workflow above is the canonical source for the detailed criteria and the rule that the index bump rides along with the module change.

## Commit Convention

Use Scoped Commits (https://scopedcommits.com) for every commit, not only publishes:

- Format: `<scope>: <description>`
- Scope is the module path or area touched
- Multiple scopes are comma-separated
- No `feat`/`fix` type prefix — the scope and description carry the meaning

The publish workflow's module-plus-index commit is the canonical multi-scope case (for example `start/module/author, index: ...`).

## References

- Naming standards: contexts/start/library/naming/context.md
- Agent patterns: docs/agent-patterns.md
- Role patterns: docs/role-patterns.md
- Schema reference: schemas/README.md
- start CLI: https://github.com/start-cli/start
