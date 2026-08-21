---
name: one-by-one
description: Walk a list of findings or issues one at a time and resolve each with a principled fix. Triggered by "obo", "one by one", or a request to remediate the most recent review, list, or output in the session.
---

# One-By-One (obo)

Walk an existing list of findings and resolve each one. This skill is a remediation engine, not a reviewer: it consumes a list that already exists in the session and works it item by item.

Targets can be code or prose — application source, or documents, prompts, specs, and skill files. The fixes and checks below adapt to which.

Issues = items in the most recent review, list, or output referenced in this session. If multiple candidate lists exist, ask which one before starting.

## Principled bias

Every fix targets the principled long-term solution, not the smallest-diff resolution. The working distillation:

- Land at the root of the problem, not the symptom. Fix the broken invariant, not the assertion that surfaced it.
- Names are contracts. Rename when meaning shifts; a misleading name is a defect.
- Abstractions earn their place by reducing total complexity now. Prefer three similar lines today over a speculative abstraction.
- Errors and edge cases get the same care as the happy path. Fail loud; no swallowed exceptions or silent failures.
- Accept friction at the moment of writing in exchange for less friction across the life of the code.

You own the how. The finding defines the problem; you decide structure, naming, placement, and whether defensive code is warranted.

### Agent-time

Estimate in agent-time, not human-time. Once the fix is defined, writing and refactoring code is fast and cheap; do not reject the principled option because it looks like "a lot of work".

- Never let human-calendar effort ("too big a change", "a lot of work") tip a recommendation toward the small-diff workaround. Typing is not the expensive axis.
- Treat mechanical volume — renames, codemods, boilerplate across many files — as cheap. Recommend the option you would pick if writing the code were free.
- Spend the saved effort where cost actually lives: getting the fix right, verifying it, and keeping it comprehensible. Scale verification to the blast radius, not to the diff size.

### Comment discipline

Fixes must not introduce comment bloat. When you edit code:

- Document WHY, not WHAT. Code shows what it does; a comment exists only for a non-obvious constraint, invariant, or rejected alternative.
- Do not restate the identifier or paraphrase the next line.
- No roadmap, future-work, ticket, PR, or conversation references; no commented-out code; no apologetic or decorative comments.
- Leave no TODO or FIXME stubs behind. Resolve the issue or spin it out via T.
- Respect tool-mandated doc-comment forms (godoc, rustdoc, Sphinx, TypeDoc) on public APIs.
- Compress a genuine WHY to one short line.

## Phase 1: Enumerate and triage

When the caller already presented this list and the user already chose C, A, S, or T — the satisfaction-check handoff — skip steps 2 and 4. Keep the caller's list. Still apply safe-to-apply items (step 3), compute m, and proceed under the chosen mode.

1. Identify the list. Enumerate the issues and state the total count K.
2. Display the full findings table before any action — every issue, including safe-to-apply and info-only items (distinguished by the Category / Severity column; neither counts toward the walk total m):

```
| # | Category / Severity | Location | Finding |
|---|---------------------|----------|---------|
| 1 | <as carried, or omit> | <file:line> | <one-line summary> |
```

3. Apply all safe-to-apply issues in one pass, without prompting. State what was applied for each. Safe items do not count toward the walk.
4. Let m be the count of issues to walk: K minus the auto-applied safe items and any info-only items. Source-list IDs such as a pre-commit `M2` are independent of this count. Display the Top-level Prompt and wait for the choice.

If the source list carries info-only items (for example the `info` severity from a pre-commit review), record them but do not walk them by default and do not count them in m. Fold them in only if the user asks (see Steering the walk).

### Safe-to-apply

Safe to apply = a change that is mechanical and needs no decision: applying it cannot alter behaviour or meaning, and a reviewer would not weigh alternatives. Everything else is walked. The test is the nature of the change, not the file extension — file type is only a heuristic for it. When unsure whether a change carries a decision, walk it.

In a code repository:

- Auto-apply: tests, comments, docstrings, formatters, lint config, .gitignore, lockfiles.
- Walk one-by-one: application runtime code (business logic, API handlers, services, models, entry points), and always CI/CD config, Dockerfiles, IaC, dependency manifests, migrations, secrets and env files.

When the target is a document, prompt, spec, or skill file, its prose is the substance — the equivalent of runtime code. Do not blanket-apply just because it is "docs":

- Auto-apply: typos, grammar, formatting, dead links, whitespace — fixes that leave the meaning unchanged.
- Walk one-by-one: anything that changes what the document says or how it behaves — requirements, instructions, logic, structure, naming, or a choice between wordings.

## Phase 2: The walk

The top-level choice selects how the m remaining findings are handled. `C` walks them one at a time; `A` applies the recommended resolution to every finding. Letters are case-insensitive.

Both modes process the findings in severity order (critical, high, medium, low) when the source list carries a severity; otherwise keep the list's existing order.

### Continue (C)

Walk the findings one at a time. For each finding:

1. Re-read the relevant context — the finding's target code and any related files — and critically re-evaluate it. The original may have been wrong or rendered obsolete by an earlier fix. If it no longer holds, say so and revise or withdraw it before presenting.
2. Lock the Recommendation under Principled bias and Agent-time above. Prefer the root fix over a symptom patch. Name the cheapest alternative and reject it only if it is worse on maintenance or correctness, not effort. If the finding still needs the target in the reader's head, rewrite until it does not — or withdraw it.
3. Present the finding using the Per-item Template, with k as the position in the walk and m as the total.
4. Display the Per-item Prompt and pause for an explicit decision. Never assume blanket approval from an earlier response. Accepting one finding does not authorise the next. If a response is ambiguous, ask which finding it applies to.

### All (A)

Apply recommendations automatically. Work through the m findings in order without displaying the Per-item Prompt. `A` is not a blind "just do it": it carries the principled bias, the safe-item handling, and the edit-as-checkpoint rule below. For each finding:

1. Re-read the relevant context and critically re-evaluate the finding, as in the walk. If it no longer holds, say so and skip it; track as Skipped. Before presenting, run the same Recommendation lock as step 2 of the walk.
2. Present the finding using the Per-item Template — including its options and recommendation — so the choice is visible before it is applied. Do not display the Per-item Prompt or pause.
3. Apply the recommended resolution — identical to `R` — and briefly confirm what was done. Track as Fixed.

The edit is the checkpoint. If the user denies an edit (declines it at the permission prompt), stop and discuss that finding; once resolved, continue the run for the remaining findings or switch to the one-at-a-time walk.

### Per-item command semantics

Letters are case-insensitive. Outcomes are tracked in-session and surface in the Phase 4 summary.

- An option letter (A, B, C …) — apply that specific option. Track as Fixed. Briefly confirm what was done.
- R — apply exactly what the Recommendation states, which may be a single option, a combination, or a blend. Track as Fixed.
- N — acknowledge and move to the next finding. Track as Skipped.
- T — create a tk ticket for this finding (see Ticket (T) below). Track as `Ticket: <id>`. Move on without an inline resolution. Omit this command unless the Ticket (T) check succeeded.
- S — bundle the remaining findings into a ticket document and stop (see S: spin out the remaining set).

After applying a fix, run whatever checks the project has for the touched files — linters, formatters, type checks, tests — skipping any that do not apply to the target (a prose target may have none). In the C walk, run them after each fix. In A mode, run the fast checks per item but the full test suite once at the end of the run — sooner if a fix is high-risk. Address whatever they surface.

Remediation guidance:

- Bias recommendations toward the principled long-term solution. Do not default to the minimal-diff resolution.
- Apply minimal, targeted edits to integrate the resolution. Refactor surrounding code only when required to make the fix land cleanly.
- If a resolution would be too large or risky to apply inline, recommend T when `tk` is available, otherwise S for the remaining set

### Steering the walk

The walk responds to natural-language scoping. Honour requests that narrow, reorder, or extend the set without requiring exact command syntax. Treat these as the user steering which findings are in play; still apply each fix under the same principled bias and edit-as-checkpoint rule. Examples:

- "just fix M2" — jump to that finding.
- "include the information items" — fold info-only items into the walk.
- "skip the low-severity ones" — drop those from the walk.
- "do 1, 3 and 5" — walk only those, in that order.

## Phase 3: Satisfaction pass

After all findings are processed, run the `sat` satisfaction check over the work touched by the fixes. Skip this pass when no work was touched — for example when every finding was deferred via T. Nested sat must not re-prompt; it returns new findings to this walk. Handle them under the mode chosen at the top level — walk them under C, auto-apply under A. This is a regression check on the changes the fixes introduced, not a fresh full review.

## Phase 4: Wrap-up

Print a summary table of all findings and their outcomes. Rows cross-reference the Phase 1 findings table by `#`.

```
| # | Finding | Outcome |
|---|---------|---------|
| 1 | Brief description | Fixed |
| 2 | Brief description | Skipped |
| 3 | Brief description | Ticket: lib-a3 |
| 4 | Brief description | Bundled: 02-<slug>.md |
```

Outcome values: `Fixed`, `Skipped`, `Ticket: <id>` (one finding spun out via T), `Bundled: <filename>` (deferred into the S set).

## S: spin out the remaining set

When S is selected at the top level or mid-walk, bundle the findings — all of them at the top level, or the unprocessed remainder mid-walk — into a single ticket document whose scope is to resolve them one-by-one later. This differs from T: T creates a tk ticket; S writes a file. Safe items applied in Phase 1 are already on disk and are not part of the bundle.

1. Run `start get contexts:ticket/writing` and follow that guide to author the document. File Placement applies
2. Frame the ticket's scope as walking the listed findings one at a time (obo) under this skill
3. Re-check each remaining finding with the same Recommendation lock as the walk. Skip any that no longer hold. Write each that still holds with its instance, Simple Explanation, Details, Options, and Recommendation so a fresh session can walk the set
4. Use the path they gave. If none, ask, offering `NN-<slug>.md` at the repository root (`NN` continues any existing `NN-` sequence, else `01`). Print the Phase 4 summary, then stop.

## Ticket (T)

Before showing either prompt, run `command -v tk`. Offer `T` only if it succeeds. Omit it from both prompts otherwise. Do not mention tk when it is absent.

Per-item `T` creates one tk ticket for that finding and continues the walk. Top-level `T` creates one tk ticket covering the remaining findings and stops.

When `T` is selected:

1. Run `tk create` with a title from the finding's short title (per-item) or a title covering the remaining set (top-level)
2. Then `start get contexts:ticket/writing`. Never fetch the writing guide at walk start
3. The writing guide's File Placement section does not apply. The path is the one `tk create` printed
4. Fill under that H1. Do not paste a second heading
5. The writing guide supplies principles, section purpose, and formatting only
6. Track as `Ticket: <id>`
7. If `tk status mode` is `tk-driven`, `tk sync` after the body fill

Per-item fill: the ticket is that finding. Carry the instance, Simple Explanation, Details, Options, and Recommendation already presented.

Top-level fill: re-check each remaining finding with the same Recommendation lock as the walk. Skip any that no longer hold. Write each that still holds with its instance, Simple Explanation, Details, Options, and Recommendation so a fresh session can walk the set. Then stop.

## Per-item Template

Carry the source list's own identifier and category or severity if it has one; otherwise number the finding by its position in the walk.

Findings are read by the person directing the agent, not by whoever wrote the code or drafted the document. They do not have the target in their head, will not re-read it to decode the finding, and have to decide something after one read.

The bar: that reader can restate the problem in their own words after reading it once. A finding that fails this has failed, however accurate it is.

Open with the smallest concrete instance that shows the problem, then explain it. Four moves, in order:

1. Establish what correct looks like and show the break against it. Where the target runs, that is a command and its output, a call and its return, or a request and its response, with the expected value alongside — `ParseDuration("500ms") → 0s (want 500ms)`. Where the target is a document, prompt, or spec, it is the passage as it stands against what it should say, or the scenario a reader following it would get wrong. Contrast two cases when the behaviour is conditional; the contrast is usually what makes the break obvious
2. Give the Simple Explanation — one or two sentences in everyday language naming the problem, so the reader has the gist before any cause chain
3. Say what causes it, in the same terms
4. Say what it costs

Writing rules:

- Name things by what they are, not by what they are called in the target. "the retry counter", not `svc.rc`. Symbols, section names, and `file:line` follow the plain-language noun in parentheses as anchors; they never carry the explanation
- Spell out internal shorthand on first use. Source-list ids, ticket numbers, and project acronyms mean nothing to the reader — an id like `M2` labels the finding, it does not explain it
- Never fabricate an observable. If the target does not run, do not dress a structure diff up as command output — show the passage or the scenario instead
- Length follows comprehension. Cut padding, never cut the setup that makes the rest land
- Do not argue the finding is real or recap intent. The instance and the explanation carry it
- Separate each option with a blank line. Never collapse options onto one line

```
### Finding k of m — <id or short title>

Category / Severity: <as carried by the source list, or omit>
Location: <file:line, or section>

<the smallest concrete instance: command → output, call → return, or request →
response with the expected value alongside where the target runs; the offending
passage or the scenario it breaks where it does not. Show it; do not describe
it.>

**Simple Explanation**

<one or two sentences naming the problem in everyday language — enough that the
reader can restate it without reading Details. No cause chain, no options.>

**Details**

<continuous prose: what causes it and what it costs, in the same plain terms as
the instance above. As long as it needs to be to land, and no longer.>

**Decision**

<the single question being put to the reader>

**Options**

A. <option — what it does, its tradeoff>

B. <option>

**Recommendation (B)**

<option letter, then one clause on why, focused on the principled long-term solution>
```

Worked example:

```
### Finding 2 of 5 — M1: ParseDuration truncates sub-second values to zero

Category / Severity: medium
Location: internal/timeutil/parse.go:42

  ParseDuration("500ms")  → 0s     (want 500ms)
  ParseDuration("1500ms") → 1s     (want 1.5s)

**Simple Explanation**

Sub-second durations are silently rounded down to whole seconds, so a 500ms
timeout becomes no timeout at all.

**Details**

The result is assembled in whole seconds, so the millisecond remainder is
dropped before the duration is built. Any caller passing a sub-second timeout
gets no timeout at all, and the failure is silent — the call returns a valid
duration, just the wrong one.

**Decision**

Rebuild from nanoseconds, or carry a float through?

**Options**

A. Build the duration from nanoseconds, then convert — exact, and mirrors how
   the standard library parses the same strings.

B. Keep seconds and add a separate milliseconds field — wider change, more
   surface for the same result.

**Recommendation (A)**

A nanosecond base matches `time.ParseDuration` and drops no precision.
```

Include an Options block only when alternatives clarify the choice; otherwise omit it and lead with a single Recommendation that R accepts. When present, label options from `A` and separate each with a blank line. The Recommendation names the option letter(s) it favours and may combine them (for example `Recommendation (B + C)`).

## Commands

### Top-level Prompt

Display at the end of Phase 1. Include the Ticket line only if the Ticket (T) check succeeded.

```
 (C)ontinue — walk the findings one at a time
 (A)ll — apply the recommended resolution to every finding (principled bias; deny an edit to pause and discuss)
 (S)ave — bundle the findings into a ticket document and stop
 (T)icket — create a tk ticket for the remaining findings and stop
```

### Per-item Prompt

Display after presenting each finding. Include Ticket only if the Ticket (T) check succeeded.

```
 A, B, C … — apply the matching option
 (R)ecommendation — apply exactly what was recommended
 (N)ext — skip this finding and move on
 (T)icket — create a tk ticket for this finding
 (S)ave — bundle the remaining findings into a ticket document and stop
```
