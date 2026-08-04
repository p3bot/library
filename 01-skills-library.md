# Project: Skills Category in the Library

## Goal

Introduce the skills category to the p3bot library: the schema, the agent
skill-path attribute, the index extension, and a first published skill module. This is
the library half of the skills feature; the start CLI consumes it via the CUE Central
Registry.

## Scope

In scope:

- A `#Skill` schema.
- A `skills` attribute on the `#Agent` schema.
- A `skills` map on the `#Index` schema.
- One example skill module: `skills/workflows/one-by-one`.
- The `skills` attribute populated on the claude agent variants.
- Registration of the new skill in `index/index.cue`.
- A `skills` map declaration in `index/index.cue` so the existing index validator vets
  skills entries.
- Publishing of the new and changed modules and the index.

Out of scope:

- Any start CLI code. The CLI work is separate projects that consume these published
  modules.
- The agy (Google Antigravity CLI) agent module. agy is the agent that reads
  `~/.agents/skills`, and authoring it requires Antigravity CLI specifics. It is its own
  project (`library/02-agy-agent.md`). Claude's `skills` attribute, delivered here, is
  sufficient to exercise the feature end to end without agy.
- `skills` attributes for gemini, copilot, and aichat. Add them when each tool's skill
  directory paths are confirmed.

## Current State

- The library is a CUE-only repository published to the CUE Central Registry as
  `github.com/p3bot/library`. Each module is a directory with a `*.cue` definition,
  a `cue.mod/module.cue`, and optional markdown, importing
  `github.com/p3bot/library/schemas@v1`.
- `schemas/` holds base, utd, agent, role, context, task, index, and settings schemas.
  `#Base` provides description, tags, origin, and uses. `#UTD` provides file, command,
  prompt, shell, timeout. Roles, contexts, and tasks embed both; agents do not embed
  `#UTD`.
- `#Agent` currently carries command, bin, default_model, and models. A claude variant
  looks like:

  ```cue
  agent: schemas.#Agent & {
  	bin:         "claude"
  	command:     "{{.bin}} --model {{.model}} ... {{.prompt}}"
  	description: "..."
  	default_model: "sonnet"
  	models: {haiku: "haiku", sonnet: "sonnet", opus: "opus"}
  	tags: [...]
  }
  ```

- `agents/` contains claude, gemini, copilot, and aichat, each with interactive, edit,
  bypass-permissions, non-interactive, and unattended variants. agy is absent.
- `#Index` has agents, roles, contexts, and tasks maps of `#IndexEntry`
  (module, description, tags, version, optional bin). `index/index.cue` holds the
  published entries.
- `scripts/validate-index` runs `cue vet` on the index and asserts the non-TTY
  default-resolution contract for agents in pure CUE.
- The publishing procedure is owned by the task `start get contexts:start/library/publishing`:
  validation, version determination, tag preflight, mandatory index update, a single
  module-plus-index commit, tag pushes, registry publish, verification.

## References

- `/home/grant/Projects/p3bot/design-skills.md` — the authoritative skills design.
  Read it first; this project implements its library half.
- https://agentskills.io/specification — the Agent Skills format that SKILL.md must
  follow.
- `library/AGENTS.md` — module patterns, address scheme, validation and publishing
  commands.

## Requirements

1. A `schemas/skill.cue` defining `#Skill` as `#Base` plus an entry pointer
   `file: string | *"@module/SKILL.md"`. It must not embed `#UTD`.
2. `#Agent` extended with an optional `skills` attribute carrying a `global` and a
   `local` path string. An agent that omits it is not a skill target.
3. `#Index` extended with an optional `skills` map of `#IndexEntry`, consistent with the
   other category maps.
4. An example skill module at `skills/workflows/one-by-one`. Its directory name is the
   leaf `one-by-one`. It contains a `SKILL.md` whose frontmatter has `name: one-by-one`
   and a description, a `skill.cue` providing the library metadata, and a
   `cue.mod/module.cue`. The SKILL.md body provides a usable skill; it should mirror the
   one-by-one remediation workflow (walk a list of findings one at a time, resolve each
   with a principled fix).
5. The claude agent variants declare `skills: {global: "~/.claude/skills", local: ".claude/skills"}`.
   Because `#Agent` is a closed definition, the attribute will not validate until each
   variant's `cue.mod` dependency is bumped to the new `schemas` version and re-tidied. All
   five variants (interactive, edit, bypass-permissions, non-interactive, unattended) are
   republished at their next version, and their five `version` fields in `index/index.cue`
   are bumped to match, each riding in its own module-plus-index commit.
6. `index/index.cue` registers the skill under the `skills` map keyed `workflows/one-by-one`,
   with module path, version, description, and tags.
7. `index/index.cue` declares `skills: [string]: schemas.#IndexEntry`, mirroring the
   existing agents, roles, contexts, and tasks declarations, so `scripts/validate-index`
   vets the skills map through its existing `cue vet ./...` with no script change. The
   non-TTY agent contract stays agent-only and does not apply to skills.
8. All new and changed modules and the index published to the registry and resolvable.

## Constraints

- Every `cue.mod/module.cue` pins the CUE language version used across the library
  (v0.16.0) and depends on `schemas@v1`.
- Import schemas from `github.com/p3bot/library/schemas@v1`. Package names match the
  deepest directory segment with hyphens removed.
- SKILL.md follows the Agent Skills specification, not the library agent-doc markdown
  rules. Its `name` must equal the parent directory name and satisfy the spec's name and
  description constraints.
- skill.cue comments and any authored library docs follow the library agent-doc markdown
  conventions.
- Commits use scoped commit format. A module change and its index entry land in one
  commit. Versioning follows SemVer; a new module starts at its initial published
  version.
- The schema change to `#Agent` and `#Index` is additive and optional, so it must not
  break existing modules. Agents that do not gain a skills attribute (gemini, copilot,
  aichat) keep validating against their pinned schema version and are not republished. The
  claude republishes are a deliberate feature change under requirement 5, not a forced
  consequence of the schema bump.

## Implementation Plan

1. Add `schemas/skill.cue`. Extend `schemas/agent.cue` with the optional `skills`
   attribute and `schemas/index.cue` with the optional `skills` map.
2. Validate the schemas with `cue vet`, adding a skill example under `docs/examples`
   consistent with the existing example-and-vet pattern.
3. Author the `skills/workflows/one-by-one` module: SKILL.md, skill.cue, cue.mod. Run
   `cue mod tidy` and `cue vet ./...` in the module.
4. Validate the SKILL.md frontmatter against the Agent Skills rules (name equals
   directory, character set, description length).
5. Bump each claude variant's `cue.mod` dependency to the new `schemas` version, run
   `cue mod tidy`, then add the `skills` attribute. The dependency bump must precede the
   attribute or `cue vet` rejects it as a field not allowed.
6. Add the `skills: [string]: schemas.#IndexEntry` declaration to `index/index.cue` and
   register the skill entry under it. Run `scripts/validate-index`; no script edit is
   needed.
7. Publish using the publishing task. Publish the schema module first, since both the
   example skill and the re-tidied claude variants depend on the new version. Then publish
   the five claude variants (each carrying its index `version` bump) and the new skill
   module (carrying its skills index entry). The index changes for each module ride in that
   module's commit, per the module-plus-index rule.

## Implementation Guidance

- The example skill is the reference other skills will be modelled on, so keep its
  layout clean and its frontmatter exemplary. Demonstrating an optional resource
  directory (for example a `references/` file) is welcome but not required.
- agy is handled by its own project (`library/02-agy-agent.md`). The schema change here
  is what unblocks it: ensure the `#Agent.skills` attribute is optional so existing
  agents that omit it remain valid.

## Acceptance Criteria

- `cue vet` passes for the skill schema and its example, and for the extended agent and
  index schemas.
- `scripts/validate-index` passes with the skills map present.
- The `skills/workflows/one-by-one` module builds (`cue vet ./...`) and its SKILL.md
  satisfies the Agent Skills frontmatter rules with `name` equal to the directory name.
- Each claude agent variant carries `skills.global` and `skills.local`, depends on the new
  `schemas` version, and its `index/index.cue` entry carries the bumped `version`.
- `index/index.cue` contains the `workflows/one-by-one` skills entry.
- The schema, skill, and index changes are published and resolvable from the registry.
