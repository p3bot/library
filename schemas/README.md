# start Schemas

CUE schemas for the start AI agent launcher.

## Module Information

- **Module:** `github.com/p3bot/library/schemas@v1`
- **Language:** CUE v0.16.0
- **Source:** git

## Design Philosophy

These schemas define **pure constraints** without defaults. This allows:

1. **User control** - Users set their own defaults in their config
2. **No conflicts** - Multiple defaults would conflict and cancel out
3. **Simplicity** - Schemas define "what is valid", not "what is typical"

## Schemas

### #UTD

Defines the Unified Template Design pattern used by roles, contexts, and tasks.

**Purpose:**

- Build prompt text from static files, dynamic command output, and template text
- Provide consistent pattern across all content generation
- Support lazy evaluation (only execute commands/read files when needed)

**Fields:**

- `file` (string, optional) - Path to file (provides `{{.file}}`, `{{.file_contents}}`)
- `command` (string, optional) - Shell command (provides `{{.command}}`, `{{.command_output}}`)
- `prompt` (string, optional) - Go template with placeholders
- `shell` (string, optional) - Override global shell (must not be empty)
- `timeout` (int, optional) - Command timeout in seconds (range: 1-3600, **no default**)

**Constraints:**

- At least one of `file`, `command`, or `prompt` must be present (validated by Go at runtime)
- `shell` must not be empty string if provided
- `timeout` must be between 1 and 3600 seconds (if provided)

**Resolution Priority:** `prompt` > `file` > `command`

See: UTD pattern documentation in the start CLI repo for complete documentation.

### #Base

Shared metadata embedded by `#Role`, `#Context`, `#Agent`, `#Task`, and `#Skill`. Carries the fields common to every module type.

**Fields:**

- `description` (string, optional) - Human-readable description
- `tags` ([]string, optional) - Tags for categorization/search
- `origin` (string, optional) - Source module path for installed copies; empty/undefined means user-defined
- `uses` ([]string, optional) - Other library modules this module pulls in at runtime via `start get`

**Constraints:**

- Each `uses` entry must be a fully-qualified colon-form address `<category>:<path>` where category is one of `agents`, `roles`, `contexts`, `tasks`, `skills`; bare names and unknown categories are rejected

### #Index

Defines the structure for the module discovery index.

**Purpose:**

- Enable CLI search and discovery without OCI catalog API
- Map friendly "category/item" paths to full module URLs
- Support search by name, description, and tags

**Category Maps:**

- `agents`, `roles`, `contexts`, `tasks`, `skills` — each an optional map of `#IndexEntry`
- Skill keys use `domain/capability` form (e.g., `"finding/one-by-one"`); the domain is library taxonomy and does not appear in the installed path

**Index Keys:**

- Use `category/item` format (e.g., `"golang/code-review"`)
- Match user input exactly for direct lookup
- Match directory structure in repository

**Module Paths:**

- Include full category in module path
- Format: `github.com/p3bot/library/{category}/{name}@v{major}`
- Example: `github.com/p3bot/library/tasks/review/git-diff@v0`

**Resolution Logic:**

1. **Direct lookup**: `start task golang/code-review` → index lookup → install module
2. **Module URL**: `start task github.com/someone/task@v0` → skip index → direct install
3. **Search**: `start task review` → search index → show matches or auto-use single result

**Agent Detection:**

The `bin` field (optional, agents only) enables auto-setup by detecting installed AI CLI tools:

1. Fetch index from registry
2. Check each agent's `bin` value against PATH
3. Single match → auto-select, multiple → prompt user
4. Fetch selected agent's package

### #Role

Defines the schema for AI agent roles (system prompts). Embeds `#UTD` for content generation.

**Role Identification:**

- Roles are identified by their **map key** (e.g., `roles["code-reviewer"]`)
- There is no `name` field - the key IS the name
- Tasks reference roles by this key (e.g., `role: "code-reviewer"`)

**Fields:**

- **From #UTD:** `file`, `command`, `prompt`, `shell`, `timeout` (see #UTD above)
- `description` (string, optional) - Human-readable description
- `tags` ([]string, optional) - Tags for categorization/search

**Constraints:**

- At least one of `file`, `command`, or `prompt` must be present (inherited from #UTD)
- `shell` must not be empty string if provided (inherited from #UTD)
- `timeout` must be between 1 and 3600 seconds if provided (inherited from #UTD)

### #Context

Defines the schema for context documents. Embeds `#UTD` for content generation.

**Context Identification:**

- Contexts are identified by their **map key** (e.g., `contexts["environment"]`)
- There is no `name` field - the key IS the name

**Selection Behavior:**

- `required: true` = always included in every command
- `default: true` = included in plain `start`, not with `--context`
- `tags` = included when matching tag requested via `--context`

**Fields:**

- **From #UTD:** `file`, `command`, `prompt`, `shell`, `timeout` (see #UTD above)
- `description` (string, optional) - Human-readable description
- `tags` ([]string, optional) - Tags for grouping and selection (kebab-case)
- `required` (bool, optional) - Always included in all commands
- `default` (bool, optional) - Included in plain `start` only

**Constraints:**

- At least one of `file`, `command`, or `prompt` must be present (inherited from #UTD)
- `shell` must not be empty string if provided (inherited from #UTD)
- `timeout` must be between 1 and 3600 seconds if provided (inherited from #UTD)
- Tags must match pattern `[a-z0-9]+(-[a-z0-9]+)*`

**Tag Matching:**

- Case-insensitive: `--context GOLANG` matches tag `golang`
- Any match: context included if ANY of its tags match ANY requested tags
- Pseudo-tag `default`: `--context default` selects contexts with `default: true`

See: selection and tagging documentation in the start CLI repo for complete details.

### #Agent

Defines the schema for AI agent configurations. Agents are command templates that launch AI CLI tools.

Unlike other schemas, agents do NOT use UTD - they define command execution, not content generation.

**Agent Identification:**

- Agents are identified by their **map key** (e.g., `agents["claude"]`)
- There is no `name` field - the key IS the name
- Tasks reference agents by this key (e.g., `agent: "claude"`)

**Fields:**

- `command` (string, required) - Command template with placeholders
- `bin` (string, optional) - Binary name for auto-detection and `{{.bin}}` placeholder
- `description` (string, optional) - Human-readable description
- `tags` ([]string, optional) - Tags for categorization/search
- `default_model` (string, optional) - Default model when `--model` not specified
- `models` (map, optional) - Friendly names to full model identifiers

**Agent Placeholders:**

- `{{.bin}}` - The bin field value
- `{{.model}}` - Resolved model identifier
- `{{.prompt}}` - Composed prompt (from UTD resolution)
- `{{.role}}` - Role content (inline)
- `{{.role_file}}` - Role file path

**Constraints:**

- `command` must not be empty
- `bin` must not be empty if provided
- Tags must match pattern `[a-z0-9]+(-[a-z0-9]+)*`

### #Task

Defines the schema for task workflows. Embeds `#UTD` for content generation.

**Task Identification:**

- Tasks are identified by their **map key** (e.g., `tasks["code-review"]`)
- There is no `name` field - the key IS the name
- This avoids duplication and simplifies the schema

**Fields:**

- **From #UTD:** `file`, `command`, `prompt`, `shell`, `timeout` (see #UTD above)
- `description` (string, optional) - Human-readable description
- `tags` ([]string, optional) - Tags for categorization/search
- `role` (string, optional) - Reference to role name (validated at runtime)
- `agent` (string, optional) - Reference to agent name (validated at runtime)

**Constraints:**

- At least one of `file`, `command`, or `prompt` must be present (inherited from #UTD)
- `shell` must not be empty string if provided (inherited from #UTD)
- `timeout` must be between 1 and 3600 seconds if provided (inherited from #UTD)

### #Skill

Defines the schema for skill modules. Skills are Agent Skills (agentskills.io): a `SKILL.md` plus optional resources, published for start to materialise onto disk.

Unlike roles, contexts, and tasks, skills do **not** embed `#UTD`. There is no prompt to render.

**Skill Identification:**

- Skills are identified by their **map key** (e.g., `skills["finding/one-by-one"]`)
- There is no `name` field - the key IS the name
- User-facing address is `skills:<domain>/<capability>` with a mandatory domain segment

**Fields:**

- `description` (string, optional) - Library-discovery metadata (index, `get`, `describe`). Distinct from the SKILL.md description, which is the agent-facing trigger text
- `tags` ([]string, optional) - Tags for categorization/search
- `origin` (string, optional) - Source module path for installed copies
- `uses` ([]string, optional) - Other library modules this module pulls in at runtime via `start get`
- `file` (string) - Standard entry pointer `"@module/SKILL.md"`, emitted by `start get` and `start describe`

**Constraints:**

- Does not embed `#UTD`; `command`, `prompt`, `shell`, and `timeout` are not skill fields
- `file` is `"@module/SKILL.md"`; that is the standard entry path, not a schema default
- Agent Skills frontmatter (`name`, `description`, `license`, and so on) lives in SKILL.md and is not mirrored into CUE

Do not unify start `skills.cue` inventory records against `#Skill`. Those entries use `#SkillInstall`.

### #SkillInstall

Defines one installed-skill inventory entry in start's `skills.cue` (global `~/.config/start/`, local `./.start/`). This is user-config inventory, not the published library module type `#Skill`.

Start records installed skills keyed by library address `group/name` (for example `finding/one-by-one`). Each entry is origin and version only. Dest paths are not stored; disk plus agentdex is truth for where files live.

**Purpose:**

- Constrain start `skills.cue` inventory entries for doctor and other consumers
- Distinct from `#Skill` in `skill.cue`, which describes published library skill modules

**Fields:**

- `origin` (string, required) - CUE module path of the installed skill; must not be empty
- `version` (string, required) - Published version of the installed skill; must not be empty

**Constraints:**

- Does not embed `#Skill` or `#Base`
- Dest, targets, path, and file are not inventory fields

## Usage

### Validate Schemas

```bash
cd schemas
cue vet ./...
```

### Validate Examples

The example files in `docs/examples/` are illustrative only. They live outside the schemas module so they do not pollute the published package, which means they are not part of `cue vet ./...`. To vet an example against the schemas, pass the full schema package alongside the example file:

```bash
cd schemas
cue vet *.cue ../docs/examples/task_example.cue
cue vet *.cue ../docs/examples/role_example.cue
cue vet *.cue ../docs/examples/context_example.cue
cue vet *.cue ../docs/examples/agent_example.cue
cue vet *.cue ../docs/examples/index_example.cue
cue vet *.cue ../docs/examples/skill_example.cue
cue vet *.cue ../docs/examples/skill_install_example.cue
cue vet *.cue ../docs/examples/utd_example.cue
cue vet *.cue ../docs/examples/settings_example.cue
```

### Export Examples

```bash
cue export *.cue ../docs/examples/task_example.cue
cue export *.cue ../docs/examples/role_example.cue
cue export *.cue ../docs/examples/context_example.cue
cue export *.cue ../docs/examples/agent_example.cue
cue export *.cue ../docs/examples/index_example.cue
cue export *.cue ../docs/examples/skill_example.cue
cue export *.cue ../docs/examples/skill_install_example.cue
cue export *.cue ../docs/examples/utd_example.cue
cue export *.cue ../docs/examples/settings_example.cue
```

### Using #UTD Directly

```cue
// contexts/my_context.cue
package contexts

import "github.com/p3bot/library/schemas@v1"

context: schemas.#UTD & {
    file:    "./PROJECT.md"
    command: "git status --short"
    prompt: """
        Project: {{.file_contents}}

        Status: {{.command_output}}
        """
    timeout: 10
}
```

### In Library Modules

```cue
// tasks/golang/code-review/task.cue
package task

import "github.com/p3bot/library/schemas@v1"

// Concrete task ready to use
task: schemas.#Task & {
    description: "Review Go code changes"
    role: "code-reviewer"
    command: "git diff --staged -- '*.go'"
    prompt: """
        Review these Go code changes:

        {{.command_output}}

        Focus: {{.instructions}}
        """
    tags: ["golang", "review", "git"]
    timeout: 30  // Specific timeout for this task
}
```

### In User Config

```cue
// ~/.config/start/settings.cue
package config

import "github.com/p3bot/library/schemas@v1"

// Apply global defaults to all tasks via pattern constraint
tasks: [_]: schemas.#Task & {
    timeout: *120 | _         // Global default: 2 minutes
    shell:   *"/bin/bash" | _ // Global default shell
}

// Define tasks (key is the task name)
tasks: {
    "code-review": {
        description: "Review code changes"
        command: "git diff --staged"
        prompt: "Review: {{.command_output}}"
        tags: ["review"]
        // Uses timeout: 120 from global default
    }

    "quick-check": {
        command: "go vet ./..."
        prompt: "Check: {{.command_output}}"
        timeout: 10  // Override global default
    }
}
```

## Template Placeholders

Tasks support Go template syntax with these placeholders:

- `{{.instructions}}` - User's CLI arguments
- `{{.file}}` - Resolved file path
- `{{.file_contents}}` - Content of file
- `{{.command}}` - Command string
- `{{.command_output}}` - Output from executing command
- `{{.datetime}}` - Current ISO 8601 date and time
