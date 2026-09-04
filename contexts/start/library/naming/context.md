# Naming Standards

Naming conventions for all module types in the p3bot library.

## Address Form

Every module has two related identifiers:

- The name is what appears within a category, structured as one or more slash-separated segments (e.g. `claude/interactive`).
- The fully-qualified address combines the category and the name with a colon: `category:name` (e.g. `agents:claude/interactive`). This is the canonical user-facing form for inputs and display.

This document describes the structure of the name for each category. Examples below are bare names; the fully-qualified address is the same string prefixed with `<category>:`.

## Common Rules

- Use kebab-case within path segments
- Use `/` to separate hierarchy levels within a name, not hyphens
- The name reads broad to specific, left to right
- Use only the segments needed for clarity
- Each segment of the name maps to a directory in the repository
- Noun segments are singular. The segment names the kind of thing, not the collection: `item`, not `items`; `finding`, not `findings`
- No name may be an ancestor of another name in the same category — every module is a leaf (see Leaf-Only Names)

## Leaf-Only Names

Within a category, a name must not be a proper prefix of another name when both are split on `/`. Put differently: no name may be an ancestor of another. Every module occupies a leaf position in its category's name tree, and an intermediate path node is never itself a module.

The per-category patterns below tend to produce leaf names on their own: each ends in a terminal segment — agent variant, role mode, context noun, task action, skill capability — that an intermediate node does not carry. Contexts (`domain/[specialisation/]noun`) are the most prone to violation, because a noun can also read as a specialisation:

Wrong:

```
golang/design        (noun "design")
golang/design/cli    ("design" reused as specialisation)
```

`golang/design` is an ancestor of `golang/design/cli`, so the bare name `golang/design` can never be addressed without also matching its descendant. Give the broader module its own terminal noun so both are leaves:

```
golang/design/overview
golang/design/cli
```

This is a string-segment rule, not a substring rule: `jira/item/read` and `jira/item/read-only` are both valid leaves because `read` is not a whole-segment prefix of `read-only`. The registry index is validated to reject ancestor collisions, and `start doctor validate` reports them.

## CUE Package Names

The `package` declaration inside a module's `.cue` file must be a valid CUE identifier (no hyphens). When the last path segment of the name contains hyphens, strip them in the package declaration.

| Last segment | Package declaration |
|--------------|---------------------|
| `interactive` | `package interactive` |
| `agents-md` | `package agentsmd` |
| `git-diff` | `package gitdiff` |
| `bypass-permissions` | `package bypasspermissions` |
| `non-interactive` | `package noninteractive` |

Strip hyphens; do not substitute underscores. This keeps one convention across the library.

Consumers importing a module whose package name does not match the last URL segment must use the `:pkgname` import suffix:

```cue
import (
    ctx "github.com/p3bot/library/contexts/cwd/agents-md@v1:agentsmd"
    tsk "github.com/p3bot/library/tasks/review/pre-commit@v2:precommit"
)
```

## Agents

Pattern: `tool/variant`

Every agent has an explicit variant name. No bare tool names as defaults.

| Segment | Required | Purpose |
|---------|----------|---------|
| tool | yes | The CLI tool name |
| variant | yes | The configuration variant |

Examples:

```
claude/interactive
claude/edit
claude/non-interactive
claude/unattended
gemini/interactive
gemini/bypass-permissions
```

## Roles

Pattern: `domain/[specialisation/]mode`

Mode is the final segment. Normally it is one of `agent`, `assistant`, or `teacher`.

| Segment | Required | Purpose |
|---------|----------|---------|
| domain | yes | The subject area or system |
| specialisation | no | Narrows the domain |
| mode | yes | The interaction mode |

Examples:

```
golang/agent
gitlab/pipeline/assistant
markdown/low-token/teacher
start/library/agent
```

Exception: file-based roles under `cwd/` and `home/` may use alternative final segments such as `default` or a filename reference (e.g., `cwd/role-md`, `cwd/dotagents/default`) where no mode applies.

## Contexts

Pattern: `domain/[specialisation/]noun`

| Segment | Required | Purpose |
|---------|----------|---------|
| domain | yes | The subject area, system, or scope |
| specialisation | no | Narrows the domain |
| noun | yes | The thing being provided as context |

Examples:

```
cwd/agents-md
home/dotagents/environment
golang/design/cli
```

## Tasks

Pattern: `[domain/][specialisation/][noun/]action`

The path reads as a natural instruction. Only the action segment is required.

| Segment | Required | Purpose |
|---------|----------|---------|
| domain | no | The system or tool. Omit when obvious from context |
| specialisation | no | Narrows the domain |
| noun | no | The thing being acted upon |
| action | yes | What you are doing |

Examples:

```
golang/debug
review/security
review/pre-commit
jira/item/read
jira/item/research
confluence/doc/read
gitlab/pipeline/review
cwd/dotagents/role/create
start/module/author
```

## Skills

Pattern: `domain/[specialisation/]capability`

A skill is a named capability the library publishes and start installs. The domain is library taxonomy only: it does not appear in the installed path or in the SKILL.md `name`. The capability segment is the Agent Skills name and must equal the module directory leaf.

| Segment | Required | Purpose |
|---------|----------|---------|
| domain | yes | The subject area or the kind of thing the skill operates on |
| specialisation | no | Narrows the domain |
| capability | yes | The skill's identity — the Agent Skills name that installs on disk |

Examples:

```
finding/one-by-one
```

The capability leaf must be unique across all skills. Two skills that share a leaf would collide on disk after the domain is stripped.

## Reserved Domains

`cwd` and `home` are reserved domain names used across all module types:

- `cwd` — the current working directory
- `home` — the user's home directory

Modules using these domains are published to the registry normally, but their content references local filesystem paths at runtime rather than bundled files. This makes them portable across machines while remaining tied to local context.

Examples:

```
cwd/agents-md           (context — reads AGENTS.md from the working directory)
cwd/readme/create       (task — operates on README.md in the working directory)
home/dotagents/environment  (context — reads ~/.agents/environment.md)
```

## Tags

Tags are used for search and discovery. Follow these conventions:

- Use kebab-case
- Include each path segment as a tag, whatever the category's segments are
- Add relevant technology or keyword terms beyond the path

Example for `jira/item/backlog/review`:

```
tags: ["jira", "item", "backlog", "review", "triage"]
```

## Action Verbs

Use `create` and `update` as a pair when the workflows are meaningfully different:
- `create` — the target does not exist yet
- `update` — the target exists and is being modified

Use `generate` when the task is analysis-driven and state-agnostic:
- The agent analyses context and produces or updates the target
- The workflow is the same whether the target exists or not

Use a single combined verb such as `author` when one interactive module owns both create and update for its subject:
- The module determines whether the target exists and follows the matching flow within itself
- Prefer this when create and update share most of their design and differ only in whether the target already exists, so the create/update pair would be near-duplicates

Other action verbs (`read`, `review`, `research`, `debug`, and so on) are free-form; choose the clearest verb for the action.

## Quick Reference

| Category | Pattern | Required Segments |
|----------|---------|-------------------|
| Agents | `tool/variant` | tool, variant |
| Roles | `domain/[specialisation/]mode` | domain, mode |
| Contexts | `domain/[specialisation/]noun` | domain, noun |
| Tasks | `[domain/][specialisation/][noun/]action` | action |
| Skills | `domain/[specialisation/]capability` | domain, capability |

Rules that apply across all categories:

- Leaf-only: no name may be an ancestor of another within a category (see Leaf-Only Names).
- Reserved domains: `cwd` and `home` map to local filesystem paths (see Reserved Domains).
