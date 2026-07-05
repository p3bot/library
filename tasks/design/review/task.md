# Design Document Review

Interactive review of a design document — the design for a new system or substantial feature — before it is accepted and decomposed into project documents. Finds unsound architecture, better alternatives that were dismissed or never considered, unstated tradeoffs and assumptions, and unmanaged risks — the flaws that would make this an unsound or under-argued design — then walks through each one and integrates the resolution into the design content.

Goal: catch the design-level flaws that would cost far more to unwind once implementation has begun. Routine implementation judgement — naming, defensive code, local refactors — belongs to the project documents this design produces, not here.

Finding no new issues is a valid outcome. If the design is sound and prior reviews have surfaced the real concerns, say so rather than invent findings to justify the run.

## Workflow

### Phase 1: Review

1. Identify the design document. Prefer the document named in the instructions or by the user. If none is named, look for clues in:
   - Design documents at the repo root: `design.md`, `rfc.md`, `adr/*.md`
   - Documentation folders: `docs/`, `.start/`
   - `AGENTS.md` — check for any reference to a current design or decision

   If multiple candidates are found, ask the user to confirm. If none are found, ask the user which document to review.
2. Read the design document thoroughly.
3. Run the Coherence Check (below). If it fires, skip to Phase 4 and declare Split the design.
4. Analyse the design:
   - Validate the stated current state against the actual codebase
   - Test whether the chosen approach actually meets the stated goals and non-goals
   - Look for approaches the document did not consider, and pressure-test the reasons the considered alternatives were rejected
   - Research external facts only when the design turns on them — a dependency's behaviour, an API contract, a platform capability, a benchmark. Generic scans produce noise over repeated runs
5. Identify concerns that meet the Goal bar — issues that would make the design wrong, leave it under-argued, or expose an unmanaged risk. Apply the Articulation Test and Regret Filter (see Reviewer Guidance) before listing each one.
6. Produce a structured report of findings using the Report Format (below) and present it inline. No disk writes.
7. If there are no actionable findings, skip to Phase 4 and declare Sound. Otherwise display the Top-level Prompt (see Commands).

### Coherence Check

Signals that a document is designing more than one independent thing and should be split into separate designs:

- Multiple independent systems or features with no shared architecture, each buildable on its own
- Distinct problem statements bundled under one Summary
- A sub-system nested inside the parent with its own alternatives and tradeoffs
- Proposed Design sections that partition cleanly with no cross-dependency

If these signals fire, the review short-circuits. Finer issues found against a design that is about to be split will mostly go stale.

### Phase 2: Remediation

Let `T` be the count of actionable findings. The top-level choice from Phase 1 selects how they are handled: `C` walks them one at a time, `A` applies the recommended resolution to every finding automatically. Letters are case-insensitive.

Continue (`C`) walks the findings one at a time. For each finding:

1. Re-read the relevant context — the design document and any referenced code — and critically re-evaluate the finding. The original may have been wrong, or rendered obsolete by an earlier fix. If the finding no longer holds, say so and revise or withdraw it before presenting.
2. Present the finding using the Per-item Template (below) with `n` as the position in the walk and `T` as the total.
3. Display the Per-item Prompt (see Commands) and pause for an explicit decision. Never assume blanket approval from an earlier response. Accepting one finding does not authorise the next. If a response is ambiguous, ask which finding it applies to.

Per-item command semantics. Letters are case-insensitive. Outcomes are tracked in-session — they are not written to disk at the moment of decision. They surface in the Phase 4 summary table and in the Remediation Summary if the review is saved.

- An option letter (`A`, `B`, `C` …) — apply that specific option to the design document, fully integrating it so the underlying issue is covered by the new content. Switch the Proposed Design, add the rejected option to Alternatives Considered, record the missing tradeoff or assumption — whatever the option calls for. Do not leave an Issues Discovered section; resolved items become polished design content. Track as `Fixed`. Briefly confirm what was done.
- `R` — apply exactly what the Recommendation states, which may be a single option, a combination, or a blend. Otherwise identical to applying an option. Track as `Fixed`.
- `N` — acknowledge and move to the next finding. Track as `Skipped`.
- `G` — spin the finding out as a standalone follow-up design (Desi(g)n; see Design File Format below). Track as `Design: <filename>`. Move to the next finding without offering an inline resolution.
- `S` — see Save (below).

All (`A`) applies recommendations automatically. Work through the `T` findings in order without displaying the Per-item Prompt. For each finding:

1. Announce `(n of T) <short title>`.
2. Re-read the relevant context and critically re-evaluate the finding, as in the walk. If it no longer holds, say so and skip it, tracking as `Skipped`.
3. Apply the recommended resolution — identical to `R` — and briefly confirm what was done. Track as `Fixed`.

The edit is the checkpoint. If you deny an edit, stop and discuss that finding; once it is resolved, resume the run for the remaining findings or switch to the one-at-a-time walk. For `decision` findings, the recommended alternative is applied — deny the edit to discuss if a different choice is wanted.

Remediation guidance:

- Bias recommendations toward the principled long-term solution that reduces maintenance and improves quality. Do not default to the smallest-diff resolution.
- Apply minimal, targeted edits to integrate the resolution. Refactor surrounding text only when required to make the resolution land cleanly.
- Integrating an alternative does not mean discarding the record. When the chosen approach changes, move the former approach into Alternatives Considered with the reason it lost — the comparison is part of the design.
- If a resolution would be too large or would open its own decision, recommend `G` to spin it out rather than forcing it inline.

### Phase 3: Satisfaction Pass

After all findings have been processed, re-read the design document with fresh eyes. Surface any new issues the edits themselves introduced — an approach switched in one section but assumed in another, a tradeoff now stated that a goal contradicts, a rejected alternative still referenced downstream.

- Handle new findings using the mode chosen at the top level — walk them under `C`, auto-apply them under `A` (deny an edit to discuss)
- This pass is lightweight — catch regressions introduced by the fixes, not run a full second review

### Phase 4: Wrap-up

1. Declare the outcome:
   - Sound — no blocking issues remain; the design is ready to decompose into project documents
   - Revise — blocking issues remain; list them by number and title
   - Split the design — the document designs more than one independent thing; summarise the seam

   An issue blocks acceptance if it would make the design wrong, leave a load-bearing part of it unargued, or expose a risk with no mitigation or accepted rationale.
2. Print a summary table of all findings and their outcomes (see Remediation Summary in the Report Format).
3. Prompt the user once: enter `S` to write the final report. Any other reply skips the save.

## Reviewer Guidance

- Review the design, not the implementation — routine judgement on naming, defensive code, local refactors, and style belongs to the project documents this design produces
- Goal bar — flag a finding only if leaving it unresolved would make the design wrong, leave it under-argued, or expose an unmanaged risk
- Articulation Test — if you cannot articulate what goes wrong when an item is left unresolved, it does not belong in the list
- Regret Filter — before finalising a finding, ask: would I regret not flagging this once implementation is underway and this design is expensive to reverse? If not, drop it
- Attack the reasoning — the strongest findings show a concrete case the chosen approach handles worse than an alternative, an assumption that does not hold, or a cost the document does not admit. Pressure-test the rejections in Alternatives Considered as hard as the choice itself
- Permission to find nothing — a late-run review that produces no findings is evidence the design is sound. Inventing findings to justify the run destroys the signal
- Recommendations target the principled long-term solution. Do not default to the minimal-diff resolution

## Issue Categories

| Category | Use when |
|----------|----------|
| approach | The chosen approach is unsound, or a better one is available |
| alternative | A viable alternative was not considered, or was dismissed without a sound reason |
| tradeoff | A cost of the chosen approach is unstated or understated |
| assumption | A load-bearing assumption is unstated or unverified |
| risk | A failure mode or its blast radius is not surfaced, mitigated, or knowingly accepted |
| gap | A concern the design must address is missing — a cross-cutting property, migration, or rollback path |
| decision | The owner needs to choose between valid alternatives before the design can proceed |
| dependency | An external dependency with version, compatibility, or availability concerns |

## Per-item Template

This template is a suggestion. Keep details succinct; expand only when the finding genuinely warrants it.

Describe every finding from the perspective of someone who does not have the design in their head. Lead with the smallest concrete instance that makes the problem undeniable — the case the chosen approach handles worse than an alternative, the assumption stated as fact with nothing behind it, the cost the document never admits. Show it; do not argue it. Then add only what is needed to decide: one line of cause, and one line of impact when it is not already obvious. Do not recap intent or restate the design back to itself — the evidence carries the finding. Keep it scannable.

```
### Finding n of T: <short title>

Category: <approach | alternative | tradeoff | assumption | risk | gap | decision | dependency>
Location: <section heading, or file:line for a current-state claim>

<evidence — the smallest concrete instance of the problem: a case the approach
handles badly, an alternative that beats it on a stated goal, an assumption with
nothing behind it, a cost left unstated. Show it; do not describe it.>

**Cause**

<one sentence: why it happens, only when the reader needs it to decide>

**Impact**

<one line: the consequence if the design ships as written, only when not obvious>

**Decision**

<the single question being put to the reader>

**Options**

A. <option — what it does, its tradeoff>
B. <option>

**Recommendation (B)**

<option letter, then one clause on why, focused on the principled long-term solution>
```

Display the Per-item Prompt (see Commands) immediately after presenting the finding.

For decisions, the Options block lists the alternatives the owner is choosing between, labelled from `A`. For other categories, include an Options block only when alternatives clarify the choice — otherwise omit it and lead with a single Recommendation that `R` accepts. The Recommendation names the option letter or letters it favours, and may combine options (for example `Recommendation (B + C)`).

## Report Format

Structure the inline review report as follows:

```
## Design Document Review

Design: <path to design document>
Intent: <one sentence on what the design sets out to do>
Findings: <count by category, e.g. 1 approach, 2 tradeoff, 1 assumption>

## Findings

A complete list of every finding — list all of them, do not truncate. The detail for each actionable finding (Issue, Options, Recommendation) is presented one at a time during the Phase 2 walk, not here.

| # | Category | Finding |
|---|----------|---------|
| 1 | <category> | <one-line summary> |
| 2 | <category> | <one-line summary> |
| 3 | <category> | <one-line summary> |

## Assessment

<overall assessment of the design, noting where the reasoning is strong and where it is thin>
```

When the report is saved after remediation begins, append the section below. Outcome values:

- `Fixed` — the resolution was applied to the design document
- `Skipped` — the finding was acknowledged with `N` and left unresolved
- `Design: <filename>` — spun out as a standalone follow-up design
- `Pending` — `S` was invoked before the finding had been processed

```
## Remediation Summary

| # | Category | Finding | Outcome |
|---|----------|---------|---------|
| 1 | approach | Brief description | Fixed |
| 2 | tradeoff | Brief description | Skipped |
| 3 | decision | Brief description | Design: 02-cache-invalidation.md |
| 4 | risk | Brief description | Pending |
```

## Design File Format

When `G` is selected during remediation, write a standalone file for the follow-up design, placed beside the design under review. Ask the user what to name it, offering the finding's short title lowercased and hyphenated as a starting point (e.g. "Cache invalidation strategy" becomes `cache-invalidation-strategy.md`).

The file must be self-contained so a fresh session can pick up the design with no extra context. Draw its structure from the design document itself: state the Problem, the Current State, and the Alternatives in play, and leave the Proposed Design open where deferring the approach is the point of spinning it out.

## Save

When `S` is invoked at any phase:

1. Discover the next available filename: `.start/reviews/YYYY-MM-DD-design-review-NN.md` where `YYYY-MM-DD` is today's date and `NN` starts at `01`, incrementing based on existing files matching the date and type
2. Write the current report. If remediation has started, include the Remediation Summary section with current outcomes. Findings not yet processed are recorded as `Pending`
3. Confirm the filename written

## Commands

### Top-level Prompt

Display verbatim at the end of Phase 1:

```
- (C)ontinue — walk through the findings one at a time
- (A)ll — apply the recommended resolution to every finding automatically
- (S)ave — write the report to .start/reviews/ and stop
```

### Per-item Prompt

Display verbatim after presenting each finding:

```
(R)ecommended  (N)ext  Desi(g)n  (S)ave
```
