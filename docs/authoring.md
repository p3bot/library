# Author a Module

Create or update a module in the library repository. One flow handles both operations (create and update) across all five indexed categories: agent, role, context, task, skill. This is an interactive design-led process — agree the design with the user before writing files.

Schema-only changes are not this flow. Read `docs/publishing.md` and follow Schema-only publish.

## Determine Operation and Category

Before doing any work, fix two axes:

- Operation: create (the target does not exist yet) or update (the target exists and is being modified)
- Category: agent, role, context, task, or skill

Infer both from the user's request where possible — phrases like "add a new", "create", or "author" point to create; "fix", "change", or "update" point to update; the subject identifies the category. Where either axis is unclear, ask.

The inferred operation is a starting hypothesis only. The existence confirmation inside the chosen flow is the authority: if a create finds the target already present, or an update finds it missing, pivot to the other flow within this same process, confirming the switch with the user first. This is the only module-authoring procedure, so never redirect the user elsewhere and never hard-error on the mismatch.

## Naming

Do not decide paths, package names, or tags from memory. At the point any path, package-name, or tag decision is made, read `docs/naming.md` and follow it. Do not proceed from memory.

It is the single source for address form, leaf-only names, per-category path patterns, package-name derivation, reserved domains, and tags.

## Create Flow

Use this flow for a new module that does not exist yet.

1. Gather the design inputs for the category (see the relevant specifics section) and the source: an existing document or definition to adapt, or a description to author from scratch
2. Decide the path, package name, and tags by following the naming standard
3. Confirm the target does not exist: check whether the module directory is already present. For a three-mode role, also check its agent, assistant, and teacher directories. `roles/hotseat/member` is the only directory for that role. If the target is present, the operation is really an update — switch to the Update Flow, confirming the switch with the user
4. Design interactively. Agree the path, the content, and the category-specific choices with the user before creating any files
5. Scaffold the directory structure and write the files from the source or from scratch, following the category specifics
6. Validate, then publish at v1.0.0 (see Validate and Publish)

Do not create files until the design is agreed.

## Update Flow

Use this flow for an existing module that is being modified.

1. Identify the target. If a path was supplied in the instructions, use it; otherwise ask which module to update and confirm the full path under its category directory
2. Confirm the target exists: read its current files. For a three-mode role, confirm whether the change affects one mode or all three and read each affected mode. `roles/hotseat/member` is the only directory for that role: read that directory only. If the target is missing, the operation is really a create — switch to the Create Flow, confirming the switch with the user
3. Summarise the current module back to the user so they can confirm your understanding before proceeding
4. Understand the problem. Ask what the module is doing wrong or not doing, and probe until it is clearly understood
5. Design the changes interactively. Describe what you plan to change and why, and confirm the approach with the user before writing anything
6. Apply the agreed changes, touching only what changes — do not rewrite sections or fields that are not affected
7. Validate, then publish a version bump (see Validate and Publish)

Do not implement until the design is agreed. The version bump for an update is determined by the publishing standard, not here.

## Agent Specifics

Files produced: `agent.cue` and `cue.mod/module.cue`. Agents have no markdown file — the whole definition lives in `agent.cue`.

Directory layout. The product modules for Claude Code, Copilot, Antigravity, and Grok are one module each, keyed by the agentdex id. Gemini and AIChat stay one module per variant. Hotseat member launches are `hotseat/<tool>`, leaves beside those product modules. `hotseat/grok` is a different leaf from `grok`. `hotseat/claude` launches Claude Code. Antigravity stays `agy`.

```
agents/<tool>/
├── agent.cue
└── cue.mod/module.cue
```

```
agents/<tool>/<variant>/
├── agent.cue
└── cue.mod/module.cue
```

```
agents/hotseat/<tool>/
├── agent.cue
└── cue.mod/module.cue
```

`<tool>` in the first tree is `claude-code`, `copilot`, `agy`, or `grok`. `<tool>` in the second tree is `gemini` or `aichat`. `<tool>` in the hotseat tree is `grok` or `claude`.

Schema fields:

| Field | Required | Type | Purpose |
| --- | --- | --- | --- |
| command | yes | string | Shell command template with placeholders |
| description | yes | string | Brief description of the agent |
| tags | no | list | Kebab-case keywords for discovery |
| bin | no | string | Binary name for auto-detection and `{{.bin}}` when unjoined |
| agentdex | no | string | agentdex catalog id of the product this recipe launches. Omit for custom or uncatalogued agents |
| default_model | no | string | Default model alias (must be a key in models) |
| models | no | map | CLI aliases (joined) or short alias to full model identifier (unjoined) |
| flags | no | struct | Optional flag table. See Flag table |
| session_locator | no | list of strings | JSON object keys from the root of the agent's stdout to the session id. Each key is a non-empty string and contains no newline. The list itself is non-empty. Omit when the module names no locator. A step is a key, not an array index |

Command template placeholders:

| Placeholder | Purpose |
| --- | --- |
| `{{.bin}}` | Binary name at launch. Unjoined recipes take it from `bin`. Joined recipes still use the placeholder; start fills it from agentdex. The schema does not define precedence when both fields are set |
| `{{.model}}` | Resolved model identifier; may be empty |
| `{{.prompt}}` | Task prompt. In `command` only when the module has no `flags.print`. When `flags.print` is set, that fragment carries the prompt word and `command` omits `{{.prompt}}` |
| `{{.role}}` | Role prompt content (inline); may be empty |
| `{{.role_file}}` | Path to a temp file containing the role; may be empty |
| `{{.permission}}` | Permission fragment from `flags.permission`. Empty or begins with a space |
| `{{.effort}}` | Effort fragment from `flags.effort`. Empty or begins with a space |
| `{{.output}}` | Output fragment from `flags.output`. Empty or begins with a space |
| `{{.resume}}` | Resume fragment from `flags.resume`, and the session id word inside that fragment |
| `{{.print}}` | Print fragment from `flags.print`. Empty or begins with a space |

`{{.model}}` is empty when start has no model to fill (no `--model` and no `default_model`). Optional `--model` flags use `{{if .model}}` with the leading space inside the if so tokens do not glue: `{{.bin}}{{if .model}} --model {{.model}}{{end}}`. Do not wrap positional required `{{.model}}` operands (for example `ollama run {{.model}}`).

`{{.role}}` and `{{.role_file}}` are empty when start has no role (`--role none`). Optional role flags use `{{if .role}}` / `{{if .role_file}}` with the leading space inside the if: `{{.bin}}{{if .role_file}} --system-prompt-file {{.role_file}}{{end}}`. Do not wrap `{{.prompt}}`. Gemini's env assignment sits before `{{.bin}}`; keep the trailing space that separates it from the binary inside the if: `{{if .role_file}}GEMINI_SYSTEM_MD={{.role_file}} {{end}}{{.bin}}`.

Role injection varies by tool. Published recipes: claude-code `{{if .role_file}} --system-prompt-file {{.role_file}}{{end}}`, grok `{{if .role}} --system-prompt-override {{.role}}{{end}}`, aichat `{{if .role}} --prompt {{.role}}{{end}}` with `{{.prompt}}` in `command` outside the if, gemini `{{if .role_file}}GEMINI_SYSTEM_MD={{.role_file}} {{end}}{{.bin}}`. For a new family, check the target tool's documentation and wrap only the role flag it already uses.

### Flag table

`flags` is optional and has no defaults. `permission`, `effort`, and `output` are maps from a value to a list of words. `print` has `off` and `on`. `resume` has `latest` and `id`. An empty list accepts the value and inserts nothing. A missing key rejects that flag. A word is a literal, or a whole word `{{.prompt}}` or `{{.resume}}`.

start assembles each fragment with a leading space. The command places the slots and does not contain an `{{if eq}}` copy of the table. Order for a flag module:

```
{{.bin}}{{if .model}} --model {{.model}}{{end}}{{.permission}}{{.role}}{{.effort}}{{.output}}{{.resume}}{{.print}}
```

`{{.role}}` in that line is the guarded role fragment, not a flags slot. Omit it when the product has no role flag. A module with no `flags.print` keeps `{{.prompt}}` in `command`.

Joined flag module. Catalog id, no `bin`, prompt only in `flags.print`:

```cue
package <leaf>

import "github.com/p3bot/library/schemas@v1"

agent: schemas.#Agent & {
	agentdex:      "<catalog-id>"
	command:       "{{.bin}}{{if .model}} --model {{.model}}{{end}}{{.permission}}{{.effort}}{{.output}}{{.resume}}{{.print}}"
	description:   "<description>"
	default_model: "<default-alias>"
	models: {
		"<alias>": "<cli-alias>"
	}
	flags: {
		permission: {
			default: []
			edit: ["--permission-mode", "acceptEdits"]
		}
		print: {
			off: ["{{.prompt}}"]
			on: ["--print", "{{.prompt}}"]
		}
	}
	tags: ["<tag1>", "<tag2>"]
}
```

Variant modules. Gemini and AIChat keep `{{.prompt}}` in `command`, set `bin`, and omit `agentdex`.

Gemini interactive. The role env assignment sits before the binary. The other variants swap the approval and prompt flags:

```cue
package <variant>

import "github.com/p3bot/library/schemas@v1"

agent: schemas.#Agent & {
	bin:           "gemini"
	command:       "{{if .role_file}}GEMINI_SYSTEM_MD={{.role_file}} {{end}}{{.bin}}{{if .model}} --model {{.model}}{{end}} --approval-mode default --prompt-interactive {{.prompt}}"
	description:   "<description>"
	default_model: "<default-alias>"
	models: {
		"<alias>": "<model-id>"
	}
	tags: ["<tag1>", "<tag2>"]
}
```

AIChat. The role flag is `--prompt`, and the task prompt stays outside that if:

```cue
package <variant>

import "github.com/p3bot/library/schemas@v1"

agent: schemas.#Agent & {
	bin:           "aichat"
	command:       "{{.bin}}{{if .model}} --model {{.model}}{{end}}{{if .role}} --prompt {{.role}}{{end}} {{.prompt}}"
	description:   "<description>"
	default_model: "<default-alias>"
	models: {
		"<alias>": "<model-id>"
	}
	tags: ["<tag1>", "<tag2>"]
}
```

`agentdex` must match `^[a-z0-9]+(-[a-z0-9]+)*$` (for example `claude-code`). The schema does not check that the id exists in the catalog. Omit `default_model` and `models` when start should use live agentdex models only, as Grok does. Copilot and Antigravity set `default_model` and omit `models`; start passes that word through.

Unjoined custom (command-only, or `bin` without a catalog id):

```cue
package <variant>

import "github.com/p3bot/library/schemas@v1"

agent: schemas.#Agent & {
	command:     "<command-template>"
	description: "<description>"
}
```

Add `bin` when the wrapper is on PATH and the command uses `{{.bin}}`. `agentdex` and `bin` are independent: joined recipes may omit `bin`; unjoined agents may still set it.

cue.mod/module.cue depends only on the schemas module. Pin a schemas version that includes `#Agent.flags` (`v1.7.0` or later). A module with no `flags` field still validates against that schema:

```cue
module: "github.com/p3bot/library/agents/<path>@v1"
language: {
	version: "v0.16.0"
}
source: {
	kind: "git"
}
deps: {
	"github.com/p3bot/library/schemas@v1": {
		v: "v1.7.0"
	}
}
```

Notes:

- The `agent:` key is always the literal `agent`; the index key supplies the friendly name
- `uses` stays empty for agents — they fetch no other module at runtime
- When `models` is set, `default_model` names a key in that map. When `models` is omitted, `default_model` is passed through as the model word
- Module identity is the index key, not `agentdex`

## Role Specifics

A role is normally three modules — agent, assistant, and teacher — in sibling directories. Each of those modes produces `role.cue`, `role.md`, and `cue.mod/module.cue`. `hotseat/chief` and `hotseat/member` are protocol roles, one module each. Do not add `hotseat/agent`, `hotseat/assistant`, or `hotseat/teacher`.

Three-mode handling differs by operation. The protocol roles are outside that handling: create and update touch that one module.

For a three-mode role:

- Create produces all three modes together. Mode selection is not optional
- Update operates on only the affected modes. Identity, Judgement, Expertise, and Boundaries are shared by all three, so a change to any of them is made in all three. The title suffix and the Mode section are the only per-mode parts

Each mode's `role.cue` varies only by mode:

```cue
package <mode>

import "github.com/p3bot/library/schemas@v1"

role: schemas.#Role & {
	description: "<description-base> - <suffix>"
	tags: ["<topic-tags>", <mode-tags>]
	file: "@module/role.md"
}
```

| Mode | Package | Suffix | Mode tags |
| --- | --- | --- | --- |
| agent | `agent` | `autonomous agent mode` | `"agent", "autonomous"` |
| assistant | `assistant` | `collaborative assistant mode` | `"assistant", "collaborative"` |
| teacher | `teacher` | `instructional teacher mode` | `"teacher", "instructional", "learning"` |

cue.mod/module.cue for each mode depends only on the schemas module:

```cue
module: "github.com/p3bot/library/roles/<path>/<mode>@v1"
language: {
	version: "v0.16.0"
}
source: {
	kind: "git"
}
deps: {
	"github.com/p3bot/library/schemas@v1": {
		v: "v1.0.0"
	}
}
```

Write each `role.md` with the Role Prompt Guide below, then apply the Mode Section.

### Role Prompt Guide

Use this guide to craft the content for each role.md file:

- Determine the best topic name or phrase and use it as the role title
- Think carefully before writing; the output should be complete and well-considered
- Keep the prompt succinct
- Follow the markdown rules from the repository code style (no bold, italic, emojis, horizontal rules; use headings, code blocks, tables, lists; no periods at the end of list items)
- Decide whether the topic is technical: a role for writing and changing code. Only a technical role gets the shared judgement block and the shared boundary

Sections, in this order:

- Title: a `# Role:` heading with the mode suffix
- Identity: one sentence, "You are an expert in <topic>", plus intrinsic constraints such as pure Go with no cgo. Mindset belongs in Judgement
- Mode: the per-mode lines from the Mode Section
- Judgement: every decision rule for the topic, as directives in one voice, then the shared judgement block for a technical role
- Expertise: a numbered list of knowledge areas, `<Number>. <Area>: <what about it matters>`
- Boundaries: hard limits only, led by the shared boundary for a technical role. Omit the section for a non-technical role when nothing qualifies

Judgement rules:

- Each line states something no other line implies. Do not restate a line in other words
- Write judgement, not task directives or procedure
- When the stack uses inheritance, add "Compose pieces rather than growing a hierarchy"
- Add "Talk to neighbours rather than reaching through them" or "Do one thing and compose the results" only when the topic already works that way
- When the topic's code logs, add "Log at decisions and boundaries with structured fields, and never log secrets or personal data"

Tailor the Judgement to the nature of the role:

| Role nature | Emphasise |
| --- | --- |
| Technical | distinctive judgement of that stack |
| Creative | originality, ideation, audience awareness, aesthetic judgement |
| Analytical | critical thinking, pattern recognition, data interpretation, synthesis |
| Communication | clarity, tone, empathy, precision |
| Domain Expert | deep knowledge, accuracy, current awareness of the field |

Shared judgement block, appended to Judgement for a technical role in this order:

- When two design principles collide, choose the one that cuts future cost in this codebase
- Bias toward the principled long-term solution that reduces maintenance and improves quality. Do not default to the smallest-diff fix
- Price a change in agent time. A principled improvement you can finish and verify now is not deferred because a human would call it a week of work
- Fix the root cause, not the symptom. When a test fails, fix the broken invariant, not the assertion
- Reuse before you invent. Extend code that already does the job, or nearly does, rather than writing a second copy
- Keep one authoritative representation of each piece of knowledge. Similar lines may stay similar
- Choose the simplest design that works. A seam earns its place when it reduces complexity now
- Hide internals behind a small stable contract
- Treat a name as a contract, and rename when its meaning shifts
- Fail so an illegal state cannot be represented. Partial states are bugs
- Validate at the boundary rather than scattering checks through the body
- Read time, randomness, environment, network, and the filesystem at the edges and pass values inward. Make a retryable operation idempotent
- Treat each dependency as a standing liability. Prefer the standard library and the dependencies the codebase already carries
- Check the pinned version's release notes before working around a dependency's apparent limit. Training knowledge is not current
- Prefer a design that is easy to delete
- Default to writing no comments. Add one only when the WHY is non-obvious — a hidden constraint, invariant, intentional tradeoff, or surprising behaviour — and keep it to one short line. Do not restate the identifier
- Keep the doc-comment form the toolchain requires. The summary states the contract, and a non-obvious WHY follows it. Do not leave task, PR, ticket, or conversation references, or a bare TODO without an owner or tracker

Shared boundary, first in Boundaries for a technical role:

- Do not skip, weaken, or comment out a test to make verification pass

Boundaries rules:

- A boundary is a hard limit that good judgement would not reliably produce, such as an action that looks helpful but must never happen
- An anti-pattern earns a line only when agents commonly commit it in this stack
- Identity and Judgement do not already imply it
- Boundaries are intrinsic role constraints, not task directives

Optional sections (include only if they add meaningful context):

- Format: expected output format for the role's responses
- Example: a sample interaction demonstrating the role in action

Output template:

```md
# Role: <role-title><mode-suffix>

You are an expert in <topic>.

## Mode

<list-of-mode-lines>

## Judgement

<list-of-judgement-lines>

## Expertise

<numbered-list-of-expertise-areas>

## Boundaries

<list-of-boundaries>
```

### Mode Section

The Mode section holds the baseline lines for the mode, then at most a few topic lines where the mode changes how the topic is handled, such as a teacher explaining concurrency before implementing it.

Agent mode, title suffix " - Autonomous Agent":

- Operate autonomously with minimal need for user confirmation
- Complete the work end to end and report results, not process
- Make reasonable assumptions when details are not specified, and state them
- Ask only when blocked

Assistant mode, no title suffix (this is the default mode):

- Clarify requirements before acting, and confirm the approach at key decision points
- Explain decisions and trade-offs
- Refine the work one deliberate, confirmed step at a time
- Communicate in a friendly manner

Teacher mode, title suffix " - Teacher":

- Explain concepts and the reasoning behind them, and check for understanding before moving on
- Break complex topics into digestible parts, with examples and analogies
- Do not assume prior knowledge. Explain foundational concepts when needed
- Build understanding, not just solutions

### Protocol Roles

`hotseat/chief` and `hotseat/member` define a protocol, not expertise. They keep a `## Protocol` section of operating rules in place of Mode and Judgement, get no shared judgement block, and use Expertise and Boundaries headings when they need them.

## Context Specifics

Files produced: `context.cue` and `cue.mod/module.cue`. Contexts have no separate markdown file — content is sourced at runtime via the UTD fields in `context.cue`. Long-form bundled prose uses `file: "@module/<name>.md"` in the CUE definition.

Selection fields determine how the context is included:

| Field | Type | Purpose |
| --- | --- | --- |
| required | bool | Always included in every command |
| default | bool | Included when running plain `start` without flags |

Neither set means the context is only included when matched by tag via `--context <tag>`.

UTD content fields (at least one required):

| Field | Type | Purpose |
| --- | --- | --- |
| file | string | Path to a file. Provides `{{.file}}` and `{{.file_contents}}` |
| command | string | Shell command. Provides `{{.command}}` and `{{.command_output}}` |
| prompt | string | Go template combining placeholders into final output |

UTD configuration fields: `shell` (override the default shell) and `timeout` (command timeout in seconds, 1-3600).

Resolution priority is prompt > file > command. With only `file` set, the file contents are returned directly; with only `command` set, the command output is returned directly; with `prompt` set, it is rendered as a Go template with access to `{{.file}}`, `{{.file_contents}}`, `{{.command}}`, `{{.command_output}}`, and `{{.datetime}}`.

Context definition templates:

```cue
package <noun>

import "github.com/p3bot/library/schemas@v1"

context: schemas.#Context & {
	description: "<description>"
	tags: ["<tag1>", "<tag2>"]
	file: "<file-path>"
	prompt: """
		{{.file_contents}}
		"""
}
```

Swap `file` for `command` and `{{.file_contents}}` for `{{.command_output}}` for a command-only context. Set `required`/`default` and combine both fields in the `prompt` when the context draws on a file and a command together.

cue.mod/module.cue depends only on the schemas module:

```cue
module: "github.com/p3bot/library/contexts/<path>@v1"
language: {
	version: "v0.16.0"
}
source: {
	kind: "git"
}
deps: {
	"github.com/p3bot/library/schemas@v1": {
		v: "v1.0.0"
	}
}
```

Notes:

- The `context:` key is always the literal `context`; the index key supplies the friendly name
- Use the `@module/` prefix for files bundled with the module; paths without it resolve relative to the user's working directory at runtime

## Task Specifics

Files produced: `task.cue`, `task.md`, and `cue.mod/module.cue`. The `task.md` carries the instructions the agent executes; `task.cue` references it and optionally a role.

task.cue template (with a role):

```cue
package <packagename>

import (
	"github.com/p3bot/library/schemas@v1"
	assistantRole "github.com/p3bot/library/roles/<role-path>@v1:<mode>"
)

task: schemas.#Task & {
	description: "<task description>"
	tags: ["<tag1>", "<tag2>"]
	role: assistantRole.role
	file: "@module/task.md"
	prompt: """
		{{.file_contents}}
		{{if .instructions}}

		## Custom Instructions

		{{.instructions}}
		{{end}}
		"""
}
```

Without a role, drop the role import and the `role` field. Declare a `uses` list when the task fetches other library modules at runtime with `start get`, using fully-qualified colon-form addresses.

Choose the prompt pattern by the size of task.md:

- `{{.file_contents}}` embeds the file inline. Use for small task files
- `Read {{.file}} to understand your task.` instructs the agent to read the file itself. Use for long task files to avoid embedding large content

task.md structure:

```markdown
# Task Title

Brief description of what this task accomplishes.

## Prerequisites

What the user must provide or have available before starting.

## Process

Steps:

1. Step one
2. Step two

## Step 1: First Step

Detailed instructions, with code blocks for commands.
```

Write task.md for an AI agent to execute: explicit commands, expected results for validation, atomic verifiable steps, and clear decision points where user input is needed.

cue.mod/module.cue depends on the schemas module, plus any referenced role:

```cue
module: "github.com/p3bot/library/tasks/<path>@v1"
language: {
	version: "v0.16.0"
}
source: {
	kind: "git"
}
deps: {
	"github.com/p3bot/library/roles/<role-path>@v1": {
		v: "v1.0.0"
	}
	"github.com/p3bot/library/schemas@v1": {
		v: "v1.1.0"
	}
}
```

A `uses` reference is a runtime `start get` fetch, not a CUE import; it is recorded in `task.cue` `uses` only and must not appear in `deps`.

## Skill Specifics

Files produced: `skill.cue`, `SKILL.md`, `cue.mod/module.cue`, and optional resource files (scripts, references, assets) beside `SKILL.md`. Skills are Agent Skills: start materialises the file bundle onto disk. They do not embed `#UTD`. There is no prompt to render.

`#Skill.file` is `"@module/SKILL.md"`; that is the standard entry pointer, not a default you invent. SKILL.md follows the Agent Skills specification, not the repository's agent-document markdown rules.

For SKILL.md prose — description trigger, body shape, progressive disclosure — load the still-published writing guide and follow it:

```bash
start get contexts:skill/writing
```

Then fetch the Agent Skills specification as that guide instructs.

skill.cue template:

```cue
package <capabilityleaf>

import "github.com/p3bot/library/schemas@v1"

skill: schemas.#Skill & {
	description: "<description>"
	tags: ["<tag1>", "<tag2>"]
	uses: ["<category:name>"]
}
```

Omit `uses` when the skill fetches no other library module at runtime. Do not add a `name` field; the index key is the identity. The SKILL.md frontmatter `name` is the capability leaf and must equal the module directory leaf.

cue.mod/module.cue depends only on the schemas module:

```cue
module: "github.com/p3bot/library/skills/<path>@v1"
language: {
	version: "v0.16.0"
}
source: {
	kind: "git"
}
deps: {
	"github.com/p3bot/library/schemas@v1": {
		v: "v1.2.0"
	}
}
```

Notes:

- The `skill:` key is always the literal `skill`; the index key supplies the friendly name
- The capability leaf must be unique across all skills (see `docs/naming.md`)
- A `uses` reference is a runtime `start get` fetch, not a CUE import; record it in `skill.cue` `uses` only
- Index entries for skills have no `bin` field

## Validate and Publish

First validate the module from its directory. For a role, validate each affected mode in its own directory:

```bash
cd <category>/<path>
cue mod tidy
cue vet <module>.cue
cue export <module>.cue
```

The `<module>.cue` file is `agent.cue`, `role.cue`, `context.cue`, `task.cue`, or `skill.cue` for its category. Resolve any failure before publishing.

Then read `docs/publishing.md` and follow it end to end. Do not proceed from memory.

It is the single source for version determination from the remote, the tag-collision preflight, the mandatory index update, the single module-plus-index commit, the explicit tag pushes, the registry publish, verification, schema-only publish, index-only retire, and closing any related GitHub issue. A create starts at v1.0.0; an update bumps per its policy. A role applies the per-module steps and one index entry per affected mode.
