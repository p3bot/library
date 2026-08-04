# Author Module

Create or update a module in the library repository. One task handles both operations (create and update) across all four categories: agent, role, context, task. This is an interactive design-led process — agree the design with the user before writing files.

## Determine Operation and Category

Before doing any work, fix two axes:

- Operation: create (the target does not exist yet) or update (the target exists and is being modified)
- Category: agent, role, context, or task

Infer both from the user's request where possible — phrases like "add a new", "create", or "author" point to create; "fix", "change", or "update" point to update; the subject identifies the category. Where either axis is unclear, ask.

The inferred operation is a starting hypothesis only. The existence confirmation inside the chosen flow is the authority: if a create finds the target already present, or an update finds it missing, pivot to the other flow within this same task, confirming the switch with the user first. This is the only module-authoring task, so never redirect the user elsewhere and never hard-error on the mismatch.

## Naming

Do not decide paths, package names, or tags from memory. At the point any path, package-name, or tag decision is made, load the naming standard and follow it:

```bash
start get contexts:start/library/naming
```

It is the single source for address form, leaf-only names, per-category path patterns, package-name derivation, reserved domains, and tags.

## Create Flow

Use this flow for a new module that does not exist yet.

1. Gather the design inputs for the category (see the relevant specifics section) and the source: an existing document or definition to adapt, or a description to author from scratch
2. Decide the path, package name, and tags by following the naming standard
3. Confirm the target does not exist: check whether the module directory (or, for roles, any of its mode directories) is already present. If it is, the operation is really an update — switch to the Update Flow, confirming the switch with the user
4. Design interactively. Agree the path, the content, and the category-specific choices with the user before creating any files
5. Scaffold the directory structure and write the files from the source or from scratch, following the category specifics
6. Validate, then publish at v1.0.0 (see Validate and Publish)

Do not create files until the design is agreed.

## Update Flow

Use this flow for an existing module that is being modified.

1. Identify the target. If a path was supplied in the instructions, use it; otherwise ask which module to update and confirm the full path under its category directory
2. Confirm the target exists: read its current files. For roles, confirm whether the change affects one mode or all three and read each affected mode. If the target is missing, the operation is really a create — switch to the Create Flow, confirming the switch with the user
3. Summarise the current module back to the user so they can confirm your understanding before proceeding
4. Understand the problem. Ask what the module is doing wrong or not doing, and probe until it is clearly understood
5. Design the changes interactively. Describe what you plan to change and why, and confirm the approach with the user before writing anything
6. Apply the agreed changes, touching only what changes — do not rewrite sections or fields that are not affected
7. Validate, then publish a version bump (see Validate and Publish)

Do not implement until the design is agreed. The version bump for an update is determined by the publishing standard, not here.

## Agent Specifics

Files produced: `agent.cue` and `cue.mod/module.cue`. Agents have no markdown file — the whole definition lives in `agent.cue`.

Schema fields:

| Field | Required | Type | Purpose |
| --- | --- | --- | --- |
| command | yes | string | Shell command template with placeholders |
| description | yes | string | Brief description of the agent |
| tags | no | list | Kebab-case keywords for discovery |
| bin | no | string | Binary name for auto-detection |
| default_model | no | string | Default model alias (must be a key in models) |
| models | no | map | Short alias to full model identifier mapping |

Command template placeholders:

| Placeholder | Purpose |
| --- | --- |
| `{{.bin}}` | Replaced with the `bin` field value |
| `{{.model}}` | Replaced with the resolved model identifier |
| `{{.prompt}}` | Replaced with the task prompt content |
| `{{.role}}` | Replaced with the role prompt content (inline) |
| `{{.role_file}}` | Replaced with a path to a temp file containing the role |

Role injection varies by tool. Common patterns: a command-line flag (`--append-system-prompt-file {{.role_file}}`), an environment variable (`GEMINI_SYSTEM_MD={{.role_file}}`), or an inline argument (`--system {{.role}}`). Check the target tool's documentation for the correct approach.

Agent definition template (with models):

```cue
package <variant>

import "github.com/p3bot/library/schemas@v1"

agent: schemas.#Agent & {
	bin:           "<binary-name>"
	command:       "<command-template>"
	description:   "<description>"
	default_model: "<default-alias>"
	models: {
		"<alias>": "<full-model-id>"
		"<alias>": "<full-model-id>"
	}
	tags: ["<tag1>", "<tag2>"]
}
```

Without models, omit the `default_model` and `models` fields.

cue.mod/module.cue depends only on the schemas module:

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
		v: "v1.0.0"
	}
}
```

Notes:

- The `agent:` key is always the literal `agent`; the index key supplies the friendly name
- `uses` stays empty for agents — they fetch no other module at runtime
- A `default_model` must name a key present in `models`

## Role Specifics

A role is three modules — agent, assistant, teacher — in sibling directories. Each mode produces `role.cue`, `role.md`, and `cue.mod/module.cue`.

Three-mode handling differs by operation:

- Create produces all three modes together. Mode selection is not optional
- Update operates on only the affected modes. The shared Skill Set and base Restrictions apply to all three, so a change to either is reflected across all three; mode-specific changes (Instructions tone, identity bullets) affect only the targeted mode(s)

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

Write each `role.md` with the Role Prompt Guide below, then apply the Mode-Specific Adjustments.

### Role Prompt Guide

Use this guide to craft the content for each role.md file:

- Determine the best topic name or phrase and use it as the role title
- Think carefully before writing; the output should be complete and well-considered
- The generated Instructions section must contain only role-level behavioural guidelines, not task directives
- In the Instructions section, include a style directive:
  - Use this list of style words: creativity, conciseness, precision, depth, elegance, performance
  - Choose the most fitting style word based on the topic's nature (e.g., "creativity" for brainstorming, "precision" for technical specs, "depth" for analysis)
  - If unsure, default to conciseness
  - Add this line: "Prioritise <chosen-style> in your responses"
- In the Instructions section, include a quality directive:
  - Add this line: "Bias your work toward the principled long-term solution that reduces maintenance and improves quality. Do not default to the smallest-diff fix."
- In the Instructions section, include a comment discipline directive:
  - Add this line: "Default to writing no comments. Add a comment only when the WHY is non-obvious — a hidden constraint, invariant, intentional tradeoff, or surprising behaviour — and keep it to one short line."
  - Add this line: "Never restate what code does in comments. Never leave task, PR, ticket, or conversation references. Never leave bare TODOs without an owner or tracker."

Restrictions:

- Keep the prompt succinct
- Follow the markdown rules from the repository code style (no bold, italic, emojis, horizontal rules; use headings, code blocks, tables, lists)
- Follow the required sections and format below

Required sections:

- Title: a `# Role:` heading followed by identity and capability bullets
- Skill Set: a numbered list of skills relevant to the role
- Instructions: role-level behavioural guidelines only; no task directives
- Restrictions: boundaries and constraints intrinsic to the role

Optional sections (include only if they add meaningful context):

- Context: background on the domain or environment the agent operates in
- Constraints: specific external limitations the agent must work within
- Format: expected output format for the role's responses
- Example: a sample interaction demonstrating the role in action
- Project: background context if the role is tied to a specific project

Format rules:

- Avoid periods at the end of list items
- Identity bullets should go beyond restating the role title — convey the mindset, approach, and distinctive qualities that make the role effective
- The Skill Set should be specific to the role; each skill should be directly relevant and meaningful for the topic
- Restrictions are intrinsic role constraints, not task instructions — keep task-level directives out of the Restrictions section

Tailor the identity bullets and skill set to the nature of the role:

| Role nature | Emphasise |
| --- | --- |
| Technical | problem-solving, debugging, algorithmic thinking, attention to detail |
| Creative | originality, ideation, audience awareness, aesthetic judgment |
| Analytical | critical thinking, pattern recognition, data interpretation, synthesis |
| Communication | clarity, tone, empathy, precision |
| Domain Expert | deep knowledge, accuracy, current awareness of the field |

Output template:

```md
# Role: <role-title>

- You are an expert in <topic>
<list-of-identity-bullets>

## Skill Set

<numbered-list-of-required-skills>

## Instructions

<list-of-instructions>

## Restrictions

<list-of-restrictions>
```

### Mode-Specific Adjustments

Apply these adjustments when generating each mode's role.md:

Agent mode:

- Title suffix: "- Autonomous Agent"
- Identity bullets: emphasise autonomy, initiative, independent decision-making
- Instructions tone: operate autonomously, make informed decisions, act without asking, communicate concisely about actions taken
- Add this line: "Operate autonomously with minimal need for user confirmation"
- Add this line: "Proactively identify and resolve potential issues"
- Restrictions: add "Make reasonable assumptions when details are not specified, documenting them clearly"

Assistant mode:

- Title: no suffix (this is the default mode)
- Identity bullets: emphasise collaboration, debugging skill, creative problem-solving
- Instructions tone: collaborative, friendly, interactive, clarify requirements, work alongside the user
- Add this line: "Be a helpful assistant who clarifies requirements, designs, implements, tests, and deploys perfect solutions"
- Add this line: "Communicate in a friendly manner"

Teacher mode:

- Title suffix: "- Teacher"
- Identity bullets: emphasise teaching passion, clear explanation, patience
- Instructions tone: educational, patient, thorough explanations, build understanding
- Add this line: "Be a patient teacher who explains concepts thoroughly and checks for understanding"
- Add this line: "Focus on building understanding, not just providing solutions"
- Restrictions: add "Don't assume prior knowledge — explain foundational concepts when needed"

### Content Consistency

The three modes for a role share:

- The same Skill Set (domain knowledge is identical across modes)
- The same Restrictions base (domain constraints apply equally)
- Similar identity bullets (adapted for mode tone)

They differ in:

- Title suffix
- Instructions section (mode-specific behavioural guidelines)
- Additional restrictions specific to the mode

## Context Specifics

Files produced: `context.cue` and `cue.mod/module.cue`. Contexts have no separate markdown file — content is sourced at runtime via the UTD fields in `context.cue`.

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

## Validate and Publish

First validate the module from its directory. For a role, validate each affected mode in its own directory:

```bash
cd <category>/<path>
cue mod tidy
cue vet <module>.cue
cue export <module>.cue
```

The `<module>.cue` file is `agent.cue`, `role.cue`, `context.cue`, or `task.cue` for its category. Resolve any failure before publishing.

Then load the publishing standard and follow it end to end:

```bash
start get contexts:start/library/publishing
```

It is the single source for version determination from the remote, the tag-collision preflight, the mandatory index update, the single module-plus-index commit, the explicit tag pushes, the registry publish, verification, and closing any related GitHub issue. A create starts at v1.0.0; an update bumps per its policy. A role applies the per-module steps and one index entry per affected mode.
