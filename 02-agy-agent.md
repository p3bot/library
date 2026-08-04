# Project: agy Agent Module

## Goal

Add the agy agent (Google Antigravity CLI) to the library as an agent module suite,
including its skills attribute. agy reads `~/.agents/skills`, so adding it makes that
directory a real skill install target and gives the skills feature a second consuming
agent beyond claude.

## Scope

In scope:

- An agy agent module suite following the existing agent variant taxonomy, for the
  variants the Antigravity CLI genuinely supports.
- The `skills` attribute on each agy variant, pointing at `~/.agents/skills` and
  `.agents/skills`.
- Registration of the agy entries in `index/index.cue`, satisfying the non-TTY
  default-resolution contract.
- Publishing of the new modules and the index.

Out of scope:

- The `#Skill` schema, the `#Agent.skills` attribute definition, and the example skill.
  Those belong to the skills library project; this project consumes the attribute.
- Any start CLI changes.

## Dependencies

- The skills library project must land first: it defines the `#Agent.skills` attribute
  that the agy variants set.

## Current State

- Agents live under `agents/<tool>/<variant>`. claude, gemini, and copilot each provide
  interactive, edit, bypass-permissions, non-interactive, and unattended variants;
  aichat provides interactive. agy is absent.
- A variant is a `#Agent` with bin, a command template using placeholders
  (`{{.bin}}`, `{{.model}}`, `{{.prompt}}`, `{{.role}}`, `{{.role_file}}`), description,
  default_model, models, and tags. After the skills library project, `#Agent` also has
  an optional `skills` attribute with global and local path strings.
- `docs/agent-patterns.md` defines the variant taxonomy: interactivity (interactive
  versus non-interactive) and permissions (default, auto-edit, bypass).
- `scripts/validate-index` asserts the non-TTY default-resolution contract: every bin in
  two or more agent index entries must have at least one entry whose key ends
  `/interactive` or is a bare name.
- `index/index.cue` registers published agents with module, version, description, tags,
  and bin.

## References

- `/home/grant/Projects/p3bot/design-skills.md` — explains why agy and
  `~/.agents/skills` matter to the skills feature.
- `docs/agent-patterns.md` — the variant naming and taxonomy to follow.
- The Antigravity CLI documentation — the source for the binary name, invocation,
  permission modes, model selection, and role or system-prompt injection. The implementer
  must locate and consult it; do not infer the command shape.

## Requirements

1. Confirm the Antigravity CLI specifics from its documentation: the binary name (expected
   to be agy), how it takes a one-shot prompt, how it selects a model, how it injects a
   system prompt or role file, and which permission or interactivity modes it supports.
   Record the findings in the commit or an authoring note.
2. Author agy variants matching the existing taxonomy for the modes the CLI actually
   supports. Provide at least an interactive variant. Add edit, bypass-permissions,
   non-interactive, and unattended variants only where the CLI has a genuine equivalent.
3. Each variant sets `skills: {global: "~/.agents/skills", local: ".agents/skills"}`.
4. Command templates use the standard placeholders consistent with the other agents and
   reflect the real Antigravity invocation, not a fabricated one.
5. Register the agy variants in `index/index.cue` with bin for PATH detection, satisfying
   the non-TTY contract.
6. The index validator passes with the agy entries present.
7. The new modules and the index are published and resolvable.

## Constraints

- Every `cue.mod/module.cue` pins the library CUE language version and depends on
  `schemas@v1`. Import schemas from `github.com/p3bot/library/schemas@v1`. Package
  names match the deepest directory segment with hyphens removed.
- Follow the variant taxonomy in `docs/agent-patterns.md`.
- Do not invent CLI flags or modes. If Antigravity has no equivalent for a permission or
  interactivity variant, omit that variant rather than approximating it.
- Commits use scoped commit format; a module change and its index entry land together.
  Versioning follows SemVer.

## Implementation Plan

1. Research the Antigravity CLI and record the binary name, invocation, model selection,
   role injection, and supported modes.
2. Author the interactive variant first; validate with `cue mod tidy` and `cue vet ./...`.
3. Add the remaining variants the CLI supports, each with the skills attribute.
4. Register the variants in `index/index.cue` and run `scripts/validate-index`.
5. Publish using the publishing task.

## Implementation Guidance

- The skills attribute is the same on every agy variant, mirroring how claude repeats its
  skills paths across variants. This redundancy is expected.
- agy is the canonical consumer of `~/.agents/skills`; getting its paths right is the
  point of the project. Verify both the global and local forms against how Antigravity
  discovers skills.

## Acceptance Criteria

- The agy variants build and pass `cue vet ./...`, and each carries
  `skills.global` and `skills.local` pointing at the agents skills directories.
- `index/index.cue` contains the agy entries with bin set, and `scripts/validate-index`
  passes including the non-TTY contract.
- The agy modules and the index are published and resolvable from the registry.
- The command templates reflect the documented Antigravity CLI invocation.
