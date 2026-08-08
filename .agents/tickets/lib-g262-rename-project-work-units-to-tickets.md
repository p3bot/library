---
id: lib-g262
status: in-progress
order: "a0"
tags: [rename, ticket, terminology]
created: "2026-08-08T22:18:28+10:00"
summary: Hard-cut rename of work-unit modules project/* to ticket/* across library and local stack
---
# Rename project work-units to tickets

## Goal

Retire the library's invented work-unit term "project" in favour of "ticket", so module paths, agent prose, index keys, aliases, and local skills match industry language and the existing `tk` CLI. After this work, agents and humans say ticket for a unit of work and project only for repositories, applications, and GitLab/GitHub projects.

## Scope

In scope:

- Rename the six work-unit modules from `project/*` to `ticket/*` (paths, CUE module identity, index keys, tags, descriptions, prose)
- Hard-cut: remove old `project/*` index keys after the new modules are published; do not dual-register or leave aliases forever
- Change interactive-walk command letter from `(P)roject` to `(T)icket` everywhere that letter is defined for spinning out work units (including outcome tags, Project File Format section titles, companion prompts, and review Save/Source slugs such as `project-doc-review` → `ticket-doc-review`)
- In `tasks/chore/comment/prune`, rename the tracker disposition from `(T)ickets` to `(I)ssues` so `T` is reserved for work-unit spin-out; describe tracker filing as issues (Jira/GitLab/GitHub), not tickets
- Update all library consumers of the work-unit sense (design lifecycle, READMEs, AGENTS.md, walk templates, chore spin-out)
- Update the full personal stack that points at these modules: `~/.config/start`, `~/.agents`, `~/.claude` skills, environment guides, aliases
- Publish to the CUE Central Registry in one coordinated cutover: the six new `ticket/*` modules at v1.0.0, version bumps for every published consumer this work edits, index hard cut (add `ticket/*`, remove `project/*` work-unit keys, bump consumer versions), then registry publish
- Published consumers that change content (must version-bump and republish), with SemVer class fixed by the publishing guide:
  - Major (prompt-semantic / interactive-letter breaks): `tasks:review/pre-commit`, `tasks:review/multi-agent/orchestrator`, `tasks:chore/comment/prune`
  - Minor (handoff prose and `ticket/*` address retarget only): `contexts:design/writing`, `tasks:design/review`
- Sentence-level prose rewrite so software/repo "project" is preserved and work-unit "project" becomes "ticket"

Out of scope:

- Teaching create/begin/review to discover tickets via `tk` (scopes, frontmatter, archive/, statuses). Leave discovery heuristics as document-file scans for now; a later ticket will align tasks with `tk`
- Changing the `tk` CLI itself
- Renaming historical git tags, commit messages, or archived review reports under `.start/reviews/`
- Bulk rewriting of user ticket/project markdown files that already exist in other repos
- Changing software/repo sense language (Go project layout, Project-specific roles, GitLab project path, "what the project does" in README tasks, etc.)

## Current State

### Work-unit modules (to rename)

| Current address | Role | Approx. prose |
| --- | --- | --- |
| `contexts:project/writing` | Canonical work-unit document shape | 81 lines |
| `contexts:project/implementation` | How to implement a work-unit document | 123 lines |
| `tasks:project/create` | Create a work-unit document | 64 lines |
| `tasks:project/begin` | Locate and implement current work unit | 30 lines |
| `tasks:project/decompose` | Design → set of work-unit documents | 267 lines |
| `tasks:project/review` | Review work unit before implement | 356 lines + README |

Filesystem roots today:

- `contexts/project/{writing,implementation}/`
- `tasks/project/{begin,create,decompose,review}/`

Each has CUE module path `github.com/p3bot/library/.../project/...@v1` and an index entry under the bare key `project/...`.

Published versions (index at investigation time): writing v1.1.0, implementation v1.3.0, create v1.0.0, begin v1.0.0, decompose v1.0.0, review v1.3.0.

### Runtime `uses` edges

- `tasks/project/create` → `contexts:project/writing`
- `tasks/project/decompose` → `contexts:project/writing`
- `tasks/project/begin` → `contexts:project/implementation`

### Library consumers of the work-unit sense

- `contexts/design/writing` — design hands off to "project documents"; points at `contexts:project/writing`
- `tasks/design/review` and its README — contrast with `project/review`; "project documents"
- `AGENTS.md` — Interactive Walk Template lists `tasks/project/review/task.md`
- `tasks/README.md` — `### project/` section
- `docs/item-by-item-template.md` — history path includes `tasks/project/review`
- `tasks/chore/comment/prune` — dispositions today include `(P)roject` (work-unit document) and `(T)ickets` (file in Jira/GitLab/GitHub). After the rename those cannot both claim `T`; tracker option becomes `(I)ssues`
- Shared walk templates that offer Project spin-out: `tasks/project/review`, `tasks/review/pre-commit`, `tasks/review/multi-agent/orchestrator`, `docs/item-by-item-template.md`, and local `one-by-one` skills. Design review uses `(G)` for design spin-out, not `(P)`
- Published modules edited by this work (beyond the six renames): `design/writing` (index v1.0.0), `design/review` (v1.3.0), `review/pre-commit` (v1.10.0), `review/multi-agent/orchestrator` (v1.7.0), `chore/comment/prune` (v1.0.0). Repo-only docs (`AGENTS.md`, `tasks/README.md`, `docs/item-by-item-template.md`) need no registry publish

### Local stack (personal machine, must update)

| Surface | Work-unit references |
| --- | --- |
| `~/.config/start/contexts.cue` | `project/writing`, `project/implementation` |
| `~/.config/start/tasks.cue` | `project/{begin,create,decompose,review}` plus descriptions/`uses` |
| `~/.config/start/aliases/aliases.cue` | Keys `pbf`, `pjbid`, `pjbn`, `pjrn`, `pr`, `prf` point at `project/*`. Three instruction strings still call the dead `pj` CLI (`pj get`, `pj next`, `pj next --claim`); `pj` is not on PATH, `tk` is |
| `~/.agents/environment.md` | `start get project/writing`, `project/implementation`; scoped-commit example `project/implementation` |
| `~/.agents/skills/one-by-one/SKILL.md` | `(P)roject` spin-out; `start get project/writing` |
| `~/.claude/skills/one-by-one/SKILL.md` | same |
| `~/.claude/skills/pj/SKILL.md` | legacy pj skill (retire if still present; may already be gone) |
| `~/.agents/skills/tk/SKILL.md` | already ticket-native; keep as canonical ticket skill |

### Already ticket-native

- `tk` CLI at `/home/linuxbrew/.linuxbrew/bin/tk`
- This repo's tk scope: `lib` at `.agents/tickets/` (repo-driven)
- Skill `tk` under `~/.agents/skills/tk` (and claude copy if installed)

### Two senses of the word (do not collapse)

| Sense | Meaning | Action |
| --- | --- | --- |
| Work unit | Standalone markdown plan for one agent implementation pass | Rename to ticket |
| Software/repo | Application, repository, Go layout, GitLab project, "project-specific role" | Keep as project |

Blind find-replace is forbidden. Mixed sense appears inside the same files (especially `contexts/project/implementation` and `contexts/project/writing`).

### Ambiguous phrases inside work-unit docs

| Phrase | Target |
| --- | --- |
| project document / current project / active project | ticket document / current ticket / active ticket |
| Split the project / micro-projects / project breakdown | ticket equivalents |
| what the project must produce / complete the project | the ticket |
| project-specific preference (Implementation Guidance) | ticket-specific |
| guidance that applies to every project in a repo | every ticket in a repo |
| what the project already owns / project-local logic / life of the project (deps) | codebase/repo — keep project or reword to codebase |
| Project-specific role / Go project layout / GitLab project | keep project |

## References

- Investigation session findings for this rename (module inventory, hit counts, external refs)
- Project writing guide (still at `contexts:project/writing` until this ticket lands) — structure for this document
- `tk` skill: `~/.agents/skills/tk/SKILL.md` and `tk skill`
- Library conventions: `AGENTS.md`, publishing via `start get contexts:start/library/publishing`
- Existing parallel: `tk` CLI and skill already use "ticket"; `pj` skill is legacy

## Requirements

1. Six new modules exist on disk and in the index under `ticket/*`:
   - `contexts:ticket/writing`
   - `contexts:ticket/implementation`
   - `tasks:ticket/create`
   - `tasks:ticket/begin`
   - `tasks:ticket/decompose`
   - `tasks:ticket/review`
2. Each new module's CUE path is `github.com/p3bot/library/.../ticket/...@v1`, package names match deepest directory segment rules, CUE pin remains `v0.16.0`, schemas imported from `github.com/p3bot/library/schemas@v1`.
3. Work-unit prose in those modules uses ticket terminology; software/repo sense of project is preserved or reworded to codebase/repo where "project" was ambiguous.
4. `uses` fields and in-prose `start get` / `contexts:` / `tasks:` references point at `ticket/*` addresses only.
5. Design lifecycle modules (`contexts:design/writing`, `tasks:design/review`) describe tickets, not projects, for the work-unit handoff.
6. Interactive walk letter for spinning a finding into a work unit is `(T)icket` (not `(P)roject`) in every library task and every local skill that defines that letter for this purpose. Companion vocabulary moves with the letter: outcome tags (`Ticket: <filename>`), section titles (Ticket File Format), prompts that list the letter, and review Save/Source stamps that today say `project-doc-review` (Source line and `.start/reviews/YYYY-MM-DD-project-doc-review-NN.md` become `ticket-doc-review` / `.start/reviews/YYYY-MM-DD-ticket-doc-review-NN.md` in `tasks:ticket/review`).
7. In `tasks/chore/comment/prune`, the disposition that files into an external tracker is `(I)ssues` (not `(T)ickets`). `T` means only work-unit ticket spin-out. Prose for that disposition says issues/tracker items, not tickets.
8. Library docs that name the modules or category (`AGENTS.md`, `tasks/README.md`, `docs/item-by-item-template.md`, review READMEs) use `ticket/*`.
9. Old filesystem trees `contexts/project/` and `tasks/project/` are removed from the repo once the new trees are correct.
10. Index hard cut: no `project/writing`, `project/implementation`, `project/create`, `project/begin`, `project/decompose`, or `project/review` keys remain in `index/index.cue` after publish of the replacements. Tags that meant the work-unit category use `ticket` instead of `project`.
11. Registry cutover per the library publishing workflow, covering:
    - Six new modules under `ticket/*` at `v1.0.0`
    - Version bumps and republish for every published consumer this work edits, with bump class locked (derive the numeric version from the remote at publish time; do not default everything to minor):
      - Major: `review/pre-commit`, `review/multi-agent/orchestrator`, `chore/comment/prune` — walk letter `(P)`→`(T)`, companion Ticket File Format / outcome vocabulary, and prune tracker disposition `(T)ickets`→`(I)ssues` change prompt semantics. These are the library's first CUE majors: for each, the major is not only the version number. Change the module path suffix from `@v1` to `@v2` in that module's `cue.mod/module.cue` and in the index entry's `module` field (e.g. `github.com/p3bot/library/tasks/review/pre-commit@v2`), then set `version` to the next major from the remote (e.g. `v1.10.0` → `v2.0.0`). `cue mod publish` requires the publish version's major to match the path suffix; publishing `v2.0.0` while the path still ends in `@v1` fails. The publishing workflow tags before publish — a path mistake after the tag is pushed spends the tag
      - Minor: `design/writing`, `design/review` — handoff prose and `ticket/*` addresses only; design-review walk letter stays `(G)`. Keep `@v1` on the module path; bump only the `version` field (e.g. `v1.0.0` → `v1.1.0`)
    - Index update in the same cutover: six `ticket/*` keys, six `project/*` work-unit keys removed, consumer `version` fields bumped, and for the three majors the index `module` field rewritten to `@v2`
    - Prefer one commit (or the minimum the publishing workflow allows) that lands all module trees + index together; publish each module, then the index, so the registry never advertises half-migrated prose
    - Before pushing any major's git tag, preflight that module with `cue mod publish --dry-run <version>` (or equivalent) so a path/version mismatch fails before the tag is spent
12. Local stack hard cut after registry is live:
    - `~/.config/start` contexts/tasks map keys hard-cut with the modules: rename each of the six work-unit keys from `project/*` to `ticket/*` (or delete the old keys and install `ticket/*`), and in the same edit set origin, description, tags, and `uses` to the published `ticket/*` modules and the new consumer versions. After the edit, contexts.cue and tasks.cue must not contain any of `project/writing`, `project/implementation`, `project/begin`, `project/create`, `project/decompose`, or `project/review` as keys. `start update` alone is not enough: when the index drops a key, update leaves the installed entry in place
    - Aliases prefer ticket/tk naming; remove or replace `pj*` aliases that still call `project/*`
    - Alias rewrite covers every array element, not only the module path: instruction strings that call `pj get`, `pj next`, or `pj next --claim` become the matching `tk` commands (`tk get`, `tk next`, `tk next --claim`), and work-unit wording in those strings uses ticket language (ticket document, not project document). After the rewrite, no alias payload contains the token `pj `
    - `~/.agents/environment.md` guide commands use `ticket/writing` and `ticket/implementation`
    - `one-by-one` skills use `(T)icket` and `start get contexts:ticket/writing` (or equivalent fully-qualified form)
    - Legacy `pj` skill removed or clearly retired if `tk` is the sole ticket skill (do not leave two competing skills)
13. After the cut, `start search --refresh ticket` (and related lookups) finds the six modules; `start search --refresh project` no longer lists the six work-unit modules (it may still match software-sense descriptions elsewhere). Any post-publish `start search` or `start get` used to verify the registry must pass `--refresh` so the 24h index cache cannot still advertise the pre-cut `project/*` set; `start install` and `start update` already resolve the index live (`--refresh` is inert on those commands)
14. Progress section in this ticket is updated as work completes so a resumed agent can see done vs remaining without re-deriving state.

## Constraints

- No global find-replace of the string "project"
- Do not invent `name` fields on modules; index keys are identity
- Do not add defaults into schema definitions
- Agent-facing markdown: no bold, italic, horizontal rules, or emojis; heading depth max `###`; single blank lines between sections
- Import schemas only as `github.com/p3bot/library/schemas@v1`, never by relative path
- Recursive runtime fetches use fully-qualified colon form and are declared in `uses`
- Publishing follows `start get contexts:start/library/publishing` (validate, version, index, commit, tag, publish, verify)
- Commits use Scoped Commits (`<scope>: <description>`); do not commit unless the operator asks, except as required inside the publish workflow the operator runs or authorises
- Repo mode for this library's tk scope is `repo-driven`: host git owns commits; do not use `tk sync` for this scope
- Do not hand-edit ticket frontmatter; use `tk mark` / `tk meta` for status and meta changes
- Do not hand-rename ticket files
- Leave tk-based discovery/placement for a future ticket; do not expand create/begin to require `tk` scopes in this work
- Hard cut only after new modules are published and local consumers can retarget — do not leave the operator with no resolvable writing/implementation guide mid-migration for longer than a single coordinated cutover

## Implementation Plan

### Phase A — Author ticket modules (library)

1. Create `contexts/ticket/writing` and `contexts/ticket/implementation` from the current project counterparts; rewrite prose and descriptions for ticket terminology; keep software/repo "project" where it means codebase.
2. Create `tasks/ticket/{create,begin,decompose,review}` the same way; retarget `uses` and `start get` lines to `contexts:ticket/*`; rewrite dense glossary sections (especially decompose "What a Project Is" → ticket; review titles and walk letter to T; review Source/Save slug `project-doc-review` → `ticket-doc-review`).
3. Validate each new module with `cue mod tidy` and `cue vet ./...` from its directory.

### Phase B — Retarget library consumers

4. Update `contexts/design/writing` and `tasks/design/review` (+ README) for ticket handoff language and `ticket/*` addresses.
5. Update `AGENTS.md`, `tasks/README.md`, `docs/item-by-item-template.md`, walk templates (`tasks/ticket/review`, `tasks/review/pre-commit`, `tasks/review/multi-agent/orchestrator`), and any other library file that references work-unit `project/*` or `(P)roject` spin-out; rename companion Project File Format / `Project:` outcome language to ticket equivalents. In `tasks/ticket/review`, rename the Save report slug and Source stamp from `project-doc-review` to `ticket-doc-review` (Source line and `.start/reviews/YYYY-MM-DD-ticket-doc-review-NN.md`).
6. Update `tasks/chore/comment/prune`: work-unit disposition becomes `(T)icket`; tracker disposition becomes `(I)ssues` with issue/tracker wording (not "tickets").
7. Grep the library for work-unit leftovers (`project/writing`, `project/implementation`, `project/create`, `project/begin`, `project/decompose`, `project/review`, `contexts:project`, `tasks:project`, "project document", "project-doc-review", "(P)roject", "(T)ickets" as the prune tracker label) and fix true positives only.

### Phase C — Index hard cut, consumer versions, remove old trees

8. Register the six `ticket/*` modules in `index/index.cue` at `v1.0.0` with accurate descriptions and `ticket` tags.
9. Remove the six `project/*` work-unit index keys.
10. For every published consumer edited in Phase B, apply the locked classes from Requirement 11 and derive each number from the remote latest tag:
    - Minor (`design/writing`, `design/review`): bump only the index `version` field (e.g. `v1.0.0` → `v1.1.0`); leave `module` at `@v1`
    - Major (`review/pre-commit`, `review/multi-agent/orchestrator`, `chore/comment/prune`): rewrite the path in that module's `cue.mod/module.cue` from `@v1` to `@v2`; rewrite the same module's index `module` field to `@v2`; set index `version` to the next major (e.g. pre-commit `v1.10.0` → `v2.0.0`). Do not bump a major consumer's version while leaving its path on `@v1`
11. Delete `contexts/project/` and `tasks/project/` from the working tree once the `ticket/*` trees fully replace them.
12. Run `scripts/validate-index` and module validation for all changed modules (six new + five consumers).

### Phase D — Publish

13. Publish per `contexts:start/library/publishing`: validate; re-derive next versions from the remote using the major/minor classes in Requirement 11 (never tag a letter-change consumer as minor); for each of the three majors confirm `cue.mod` path and index `module` field are `@v2` and the publish version major matches; tag-collision preflight; `cue mod publish --dry-run <version>` for each major (and ideally each module) before any tag is pushed; commit all new `ticket/*` trees, updated consumer modules (including `@v2` path edits), and `index/index.cue` together; tag each module and the index; push; `cue mod publish` each module then the index.
14. Confirm registry resolves `contexts:ticket/*` and `tasks:ticket/*` at the published versions, that the three major consumers resolve under their `@v2` module paths at the published major versions, and that republished consumers serve ticket terminology. Smoke with a live index: `start get --refresh` on `contexts:ticket/writing`, `contexts:ticket/implementation`, design/writing, design/review, and one walk or prune task (pre-commit or prune). Do not use bare `start get`/`start search` for this check — without `--refresh`, the 24h index cache can still list `project/*` and omit `ticket/*` for up to a day after publish.

### Phase E — Local stack hard cut

15. Hard-cut `~/.config/start/contexts.cue` and `tasks.cue` map keys, not only field values: rename each of the six work-unit keys from `project/*` to `ticket/*` (or delete those keys and install `ticket/*`), and in the same edit set origin, description, tags, and `uses` to the published `ticket/*` modules and the new consumer versions (refresh from registry with a live index, or edit to match published origins). Reject any remaining key among `project/writing`, `project/implementation`, `project/begin`, `project/create`, `project/decompose`, `project/review`. Do not rely on `start update` for this rename — when the index no longer lists a key, update skips that installed entry and leaves it serving the old module.
16. Rewrite `~/.config/start/aliases/aliases.cue`: point at `ticket/*`; rename aliases from pj/project branding to ticket/tk branding where that is the operator's convention; ensure no alias still invokes `project/*` work-unit tasks. Rewrite instruction strings in the same pass: `pj get` → `tk get`, `pj next` → `tk next`, `pj next --claim` → `tk next --claim`, and project-document wording → ticket-document wording. Reject a path-only edit that leaves any `pj ` token in an alias payload.
17. Update `~/.agents/environment.md` guide commands and any scoped-commit examples that cite `project/implementation` as a work-unit module path.
18. Update `one-by-one` skills under `~/.agents` and `~/.claude` for `(T)icket` and `contexts:ticket/writing`.
19. Retire the legacy `pj` skill if it still describes project documents as the work unit; leave `tk` as the only ticket skill.
20. Smoke-check with a live index (`--refresh` on every `search`/`get`): `start search --refresh ticket`, `start get --refresh contexts:ticket/writing`, `start get --refresh contexts:ticket/implementation`, and one task address (e.g. `tasks:ticket/begin`) resolve correctly; `start search --refresh project` no longer lists the six retired modules under registry (global must already be key-hard-cut per step 15); republished consumers no longer instruct work-unit "project" language.

### Phase F — Close out

21. Mark progress items done; set this ticket to `done` via `tk mark` when acceptance criteria pass.
22. Optionally file a follow-up ticket for tk-aware discovery/placement in create/begin/review (explicitly not done here).

## Implementation Guidance

- Prefer authoring new `ticket/*` trees and switching the index in one cutover rather than half-renaming live modules mid-flight.
- Treat the six creates and five consumer updates as one publish set. Do not publish `ticket/*` while design/review/walk/prune modules still ship "project" work-unit prose from the registry.
- Consumer SemVer: major when interactive letters or disposition labels change (`pre-commit`, `multi-agent/orchestrator`, `chore/comment/prune`); minor when only handoff prose and addresses change (`design/writing`, `design/review`). Tags are immutable — get the class right on the first publish. A major is a CUE path change as well as a version number: `@v1` → `@v2` in `cue.mod/module.cue` and in the index `module` field, then `cue mod publish v2.x.x`. This library has never published a major before — treat the three majors as the first `@v2` modules and dry-run publish before tagging.
- When rewriting mixed-sense sentences, prefer "codebase" or "repository" over "project" if "project" would be ambiguous after the rename.
- Glossary for consistency across modules:
  - ticket — the work unit
  - ticket document — the markdown file an implementer receives as sole context
  - current / active ticket — the ticket in progress for begin/review discovery
  - ticket-specific — preference local to one ticket (old "project-specific" in Implementation Guidance)
  - `(T)icket` — walk letter to spin a finding into a ticket document (also prune work-unit disposition)
  - `(I)ssues` — prune disposition for filing into an external tracker; never call those "tickets" in agent prose after this rename
  - `ticket-doc-review` — Save report slug and Source stamp in `tasks:ticket/review` (replaces `project-doc-review`; path `.start/reviews/YYYY-MM-DD-ticket-doc-review-NN.md`)
- Dense files first for rewrite quality: `tasks/ticket/decompose`, `tasks/ticket/review`, then the two context guides, then thin tasks.
- Local start config: the map key is the address. Renaming only origin strings under `project/*` keys leaves `start get project/writing` and `start search project` listing the retired work units. Rename or delete the keys; field-only retarget is incomplete. `start update` cannot perform the rename — it only refreshes modules still present in the index
- Post-publish smoke: start's registry index cache is fresh for 24h. `start search` and `start get` read that cache unless `--refresh` is set; without it, cutover checks can still show `project/*` and miss `ticket/*` after a successful publish. Always pass `--refresh` on those commands when verifying the hard cut. `start install` and `start update` already resolve the index live
- Aliases: mirror existing behaviour with new names (e.g. begin/review shortcuts) rather than inventing a large new alias surface in this ticket. Path retarget alone is not enough — instruction strings that still say `pj next` / `pj get` stay broken because `pj` is not installed; rewrite them to `tk` in the same edit.
- Do not expand create/begin file placement to require tk scopes; keep "document among markdown files / AGENTS.md clues" behaviour, with wording updated to ticket.
- Progress section below is the resume aid — tick items as you finish phases or significant steps so a later session does not re-inventory the world.

## Acceptance Criteria

1. `start get --refresh contexts:ticket/writing` and `start get --refresh contexts:ticket/implementation` return guides that describe tickets, not project work-units.
2. `start get --refresh tasks:ticket/create`, `tasks:ticket/begin`, `tasks:ticket/decompose`, and `tasks:ticket/review` resolve; each `uses` only `ticket/*` contexts where applicable.
3. Index has the six `ticket/*` keys and does not have the six old `project/*` work-unit keys; `scripts/validate-index` passes.
4. Repo contains `contexts/ticket/` and `tasks/ticket/`; it does not contain `contexts/project/` or `tasks/project/` work-unit trees.
5. Design writing and design review prose hand off to tickets and reference `ticket/*` only — both in the repo and via `start get --refresh` of the published versions.
6. No library agent-facing doc still instructs `start get project/writing` or `project/implementation` for the work-unit guides.
7. Every interactive-walk definition that spun work into a project document now uses `(T)icket` for that action, with matching Ticket File Format / outcome-tag vocabulary; `tasks:ticket/review` uses Source/Save slug `ticket-doc-review` (not `project-doc-review`); published walk modules (pre-commit, multi-agent orchestrator, ticket/review) serve that language from the registry.
8. `tasks/chore/comment/prune` uses `(T)icket` for work-unit spin-out and `(I)ssues` for tracker filing; no disposition still labelled `(T)ickets`; published prune matches.
9. Local config and skills no longer invoke `project/*` work-unit modules: contexts.cue and tasks.cue have no keys among the six retired `project/*` work-unit addresses (only `ticket/*` equivalents); environment guide points at `ticket/*`; local origins pin the new consumer versions where relevant. No start alias still points at `project/*` work-unit tasks, and no alias instruction string still contains `pj ` or tells the agent to run the retired `pj` CLI.
10. `start search --refresh project` does not list the retired six work-unit modules; software-sense hits may remain.
11. A fresh agent can implement a ticket using only `contexts:ticket/implementation` without encountering "project document" as the name of the work unit.
12. Index versions for the five republished consumers match the tags published to the registry; `scripts/validate-index` passes after the cutover. The three letter/disposition consumers are major bumps with module paths and index `module` fields on `@v2` (not `@v1` with a v2.x.x version alone); design/writing and design/review are minor bumps still on `@v1`.

## Progress

Use this list as the resume checklist. Mark items `[done]` when finished; leave `[todo]` otherwise. Update this section as you work.

### Library modules

- [todo] Author `contexts/ticket/writing`
- [todo] Author `contexts/ticket/implementation`
- [todo] Author `tasks/ticket/create`
- [todo] Author `tasks/ticket/begin`
- [todo] Author `tasks/ticket/decompose`
- [todo] Author `tasks/ticket/review`
- [todo] `cue mod tidy` + `cue vet` on all six new modules

### Library consumers

- [todo] Update `contexts/design/writing`
- [todo] Update `tasks/design/review` (+ README)
- [todo] Update `AGENTS.md`, `tasks/README.md`, `docs/item-by-item-template.md`
- [todo] Update spin-out letter to `(T)icket` in library walk templates (review, pre-commit, multi-agent, item-by-item template); review Source/Save slug `ticket-doc-review`
- [todo] Prune: `(T)icket` work-unit + `(I)ssues` tracker dispositions
- [todo] Grep pass for work-unit leftovers in the library (include `project-doc-review`)

### Index and removal

- [todo] Register six `ticket/*` index entries at v1.0.0
- [todo] Remove six `project/*` index entries
- [todo] Minor consumers: bump index version only (design/writing, design/review stay `@v1`)
- [todo] Major consumers: `@v1` → `@v2` in each `cue.mod/module.cue` and index `module` field; set next major version (pre-commit, multi-agent/orchestrator, chore/comment/prune)
- [todo] Delete `contexts/project/` and `tasks/project/` trees
- [todo] `scripts/validate-index`

### Publish

- [todo] Dry-run `cue mod publish` for each major (path major matches version major) before tagging
- [todo] Publish six `ticket/*` creates + five consumer updates + index (coordinated cutover; majors/minors and `@v2` paths per Requirement 11)
- [todo] Verify registry resolution with `start get --refresh` / `start search --refresh` for `ticket/*`, `@v2` majors, and republished consumers

### Local stack

- [todo] `~/.config/start` contexts.cue and tasks.cue: rename or replace the six `project/*` keys with `ticket/*` (origins/descriptions/tags/`uses`); reject leftover `project/*` work-unit keys (`start update` will not purge them)
- [todo] Rewrite aliases off `project/*` / pj branding (paths, keys, and `pj`→`tk` instruction strings)
- [todo] `~/.agents/environment.md` → ticket guide commands
- [todo] `one-by-one` skills → `(T)icket` + ticket writing guide
- [todo] Retire legacy `pj` skill if still present
- [todo] Smoke-check with `--refresh`: search/get ticket modules; search project no longer lists the six retired work units

### Close

- [todo] Acceptance criteria verified
- [todo] Optional follow-up ticket filed for tk-aware discovery
- [todo] This ticket marked done
