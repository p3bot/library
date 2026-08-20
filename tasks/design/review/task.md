# Design Document Review

Interactive review of a design document — the design for a new system or substantial feature — before it is accepted and decomposed into ticket documents. Finds unsound architecture, better alternatives that were dismissed or never considered, unstated tradeoffs and assumptions, and unmanaged risks — the flaws that would make this an unsound or under-argued design — then walks through each one and integrates the resolution into the design content.

Goal: catch the design-level flaws that would cost far more to unwind once implementation has begun. Routine implementation judgement — naming, defensive code, local refactors — belongs to the ticket documents this design produces, not here.

Finding no new issues is a valid outcome. If the design is sound and prior reviews have surfaced the real concerns, say so rather than invent findings to justify the run.

## Workflow

### Phase 1: Review

1. Identify the design document from the user's instructions. If they named a path, use it. If they asked you to find it, look where they pointed. Otherwise ask.
2. Read the design document thoroughly.
3. Run the Coherence Check (below). If it fires, still produce the report header and What this design does, then skip to Phase 4 and declare Split the design.
4. Analyse the design:
   - Validate the stated current state against the actual codebase
   - Test whether the chosen approach actually meets the stated goals and non-goals
   - Look for approaches the document did not consider, and pressure-test the reasons the considered alternatives were rejected
   - Research external facts only when the design turns on them — a dependency's behaviour, an API contract, a platform capability, a benchmark. Generic scans produce noise over repeated runs
5. Identify concerns that meet the Goal bar — issues that would make the design wrong, leave it under-argued, or expose an unmanaged risk. Apply the Articulation Test and Regret Filter (see Reviewer Guidance) before listing each one.
6. Produce a structured report using the Report Format (below) and present it inline. Do not write a report file unless Save applies.
7. If there are no actionable findings, skip to Phase 4 and declare Sound. Otherwise display the Top-level Prompt (see Commands).

### Coherence Check

Signals that a document covers more than one independent design and should be split into separate designs:

- Multiple independent systems or features with no shared architecture, each buildable on its own
- Distinct problem statements bundled under one Summary
- A sub-system nested inside the parent with its own alternatives and tradeoffs
- Proposed Design sections that partition cleanly with no cross-dependency

If these signals fire, the review short-circuits. Finer issues found against a design that is about to be split will mostly go stale.

### Phase 2: Remediation

Let `m` be the count of actionable findings. The top-level choice from Phase 1 selects how they are handled: `C` walks them one at a time, `A` applies the recommended resolution to every finding automatically. Letters are case-insensitive.

Continue (`C`) walks the findings one at a time. For each finding:

1. Re-read the relevant context — the design document and any referenced code — and critically re-evaluate the finding. The original may have been wrong, or rendered obsolete by an earlier fix. If the finding no longer holds, say so and revise or withdraw it before presenting.
2. Before presenting, lock the Recommendation: does it fix the design-level flaw (approach, assumption, tradeoff, risk), or only a surface wording? Name the cheapest alternative and reject it only if it is worse on soundness or long-term cost, not effort. If the finding still needs the design or code in the reader's head, rewrite until it does not — or withdraw it.
3. Present the finding using the Per-item Template (below) with `n` as the position in the walk and `m` as the total.
4. Display the Per-item Prompt (see Commands) and pause for an explicit decision. Never assume blanket approval from an earlier response. Accepting one finding does not authorise the next. If a response is ambiguous, ask which finding it applies to.

Per-item command semantics. Letters are case-insensitive. Outcomes are tracked in-session — they are not written to disk at the moment of decision. They surface in the Phase 4 summary table and in the Remediation Summary if the review is saved.

- An option letter (`A`, `B`, `C` …) — apply that specific option to the design document, fully integrating it so the underlying issue is covered by the new content. Switch the Proposed Design, add the rejected option to Alternatives Considered, record the missing tradeoff or assumption — whatever the option calls for. Do not leave an Issues Discovered section; resolved items become polished design content. Track as `Fixed`. Briefly confirm what was done.
- `R` — apply exactly what the Recommendation states, which may be a single option, a combination, or a blend. Otherwise identical to applying an option. Track as `Fixed`.
- `N` — acknowledge and move to the next finding. Track as `Skipped`.
- `G` — spin the finding out as a standalone follow-up design (Desi(g)n; see Design File Format below). Track as `Design: <filename>`. Move to the next finding without offering an inline resolution
- `T` — create a tk ticket for this finding (see Ticket (T) below). Track as `Ticket: <id>`. Move to the next finding without offering an inline resolution. Omit this command unless the Ticket (T) check succeeded
- `S` — see Save (below).

All (`A`) applies recommendations automatically. Work through the `m` findings in order without displaying the Per-item Prompt. For each finding:

1. Announce `(n of m) <short title>`.
2. Re-read the relevant context and critically re-evaluate the finding, as in the walk. If it no longer holds, say so and skip it, tracking as `Skipped`. Before applying, run the same Recommendation lock as step 2 of the walk.
3. Apply the recommended resolution — identical to `R` — and briefly confirm what was done. Track as `Fixed`.

The edit is the checkpoint. If you deny an edit, stop and discuss that finding; once it is resolved, resume the run for the remaining findings or switch to the one-at-a-time walk. For `decision` findings, the recommended alternative is applied — deny the edit to discuss if a different choice is wanted.

Remediation guidance:

- Bias recommendations toward the principled long-term design choice. Prefer changing the Proposed Design (and recording the loser in Alternatives Considered) over a local caveat that leaves the approach intact. Do not default to the smallest-diff edit
- Apply minimal, targeted edits to integrate the resolution. Refactor surrounding text only when required to make the resolution land cleanly.
- Integrating an alternative does not mean discarding the record. When the chosen approach changes, move the former approach into Alternatives Considered with the reason it lost — the comparison is part of the design.
- If a resolution would be too large or would open its own decision, recommend `G` to spin it out as a design, or `T` when `tk` is available to spin it out as a tk ticket

### Phase 3: Satisfaction Pass

After all findings have been processed, re-read the design document with fresh eyes. Surface any new issues the edits themselves introduced — an approach switched in one section but assumed in another, a tradeoff now stated that a goal contradicts, a rejected alternative still referenced downstream.

- Handle new findings using the mode chosen at the top level — walk them under `C`, auto-apply them under `A` (deny an edit to discuss)
- This pass is lightweight — catch regressions introduced by the fixes, not run a full second review

### Phase 4: Wrap-up

1. Declare the outcome:
   - Sound — no blocking issues remain; the design is ready to decompose into ticket documents
   - Revise — blocking issues remain; list them by number and title
   - Split the design — the document covers more than one independent design; summarise the seam

   An issue blocks acceptance if it would make the design wrong, leave a load-bearing part of it unargued, or expose a risk with no mitigation or accepted rationale.
2. Print a summary table of all findings and their outcomes (see Remediation Summary in the Report Format). Do not prompt to save.

## Reviewer Guidance

- Review the design, not the implementation — routine judgement on naming, defensive code, local refactors, and style belongs to the ticket documents this design produces
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

Findings are read by someone who has not opened the design document, cannot look anything up, and has to decide something after one read.

The bar: that reader can restate the problem in their own words after reading it once. A finding that fails this has failed, however accurate it is.

Open with the smallest concrete instance that shows the problem, then explain it. Four moves, in order:

1. Establish what correct looks like and show the break against it. A design is not running code, so the instance is usually a scenario rather than an output — the case the chosen approach handles worse than an alternative, the condition under which a stated assumption stops holding, the cost the document never admits. Where the design makes a claim about existing code, a command and its output with the expected value alongside is stronger. Contrast two cases when the rule is conditional; the contrast is usually what makes the break obvious
2. Give the Simple Explanation — one or two sentences in everyday language naming the problem, so the reader has the gist before any cause chain
3. Say what causes it, in the same terms
4. Say what it costs if the design ships as written

Writing rules:

- Name things by what they are, not by what they are called in the design. "the write path's ordering guarantee", not `R4`. Section names, symbols, and `file:line` follow the plain-language noun in parentheses as anchors; they never carry the explanation
- Spell out internal shorthand on first use. Requirement ids, section codes, and codebase acronyms mean nothing to the reader
- Never fabricate an observable. Do not dress a proposed type or structure up as command output — show the scenario instead
- Length follows comprehension. Cut padding, never cut the setup that makes the rest land
- Do not argue the finding is real or restate the design back to itself. The instance and the explanation carry it
- Separate each option with a blank line. Never collapse options onto one line

```
### Finding n of m: <short title>

Category: <approach | alternative | tradeoff | assumption | risk | gap | decision | dependency>
Location: <section heading, or file:line for a current-state claim>

<the smallest concrete instance: the scenario the design handles badly, the
condition that breaks a stated assumption, the cost left unstated — or, for a
claim about existing code, command → output with the expected value alongside.
Show it; do not describe it.>

**Simple Explanation**

<one or two sentences naming the problem in everyday language — enough that the
reader can restate it without reading Details. No cause chain, no options.>

**Details**

<continuous prose: what causes it and what it costs if the design ships as
written, in the same plain terms as the instance above. As long as it needs to
be to land, and no longer.>

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
### Finding 1 of 3: Ordering guarantee assumes a single writer

Category: assumption
Location: Proposed Design — Write path

  one region   → one writer per key, writes land in order
  two regions  → two writers, same key, no rule stated for which wins

**Simple Explanation**

The design promises ordered writes under a single writer, then adds a second
region that also accepts writes without saying which write wins.

**Details**

The design promises that updates to a record are applied in the order they were
made, and gets that for free while there is exactly one writer. The rollout
section then adds a second region that also accepts writes, without saying how
the two are ordered against each other.

Two users editing the same record from different regions can therefore end up
with either edit winning, and neither the design nor the acceptance criteria say
which is correct — so the implementation cannot be wrong, and cannot be verified
either.

**Decision**

How are concurrent writes to the same record ordered across regions?

**Options**

A. Pin each record to a home region — writes elsewhere forward to it. Preserves
   the single-writer guarantee unchanged; adds cross-region latency on write.

B. Accept last-write-wins on a shared clock and state it as the guarantee.
   Cheaper, but weakens a promise other sections already rely on.

**Recommendation (A)**

Option A: the ordering guarantee is load-bearing for the reconciliation design
downstream, and B would quietly invalidate it.
```

Display the Per-item Prompt (see Commands) immediately after presenting the finding.

For decisions, the Options block lists the alternatives the owner is choosing between, labelled from `A`. For other categories, include an Options block only when alternatives clarify the choice — otherwise omit it and lead with a single Recommendation that `R` accepts. Separate each option with a blank line. The Recommendation names the option letter or letters it favours, and may combine options (for example `Recommendation (B + C)`).

## Report Format

Structure the inline review report as follows. After the header, bullet what the design does before listing findings. Each bullet is one outcome or change the design would put in place — not a restatement of the Proposed Design and not a dump of the alternatives.

```
## Design Document Review

Design: <path to design document>
Intent: <one sentence on what the design sets out to do>
Findings: <count by category, e.g. 1 approach, 2 tradeoff, 1 assumption>

## What this design does

- <outcome or change>
- <outcome or change>

## Findings

A complete list of every finding — list all of them, do not truncate. The detail for each actionable finding (Simple Explanation, Details, Options, Recommendation) is presented one at a time during the Phase 2 walk, not here.

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
- `Ticket: <id>` — spun out as a tk ticket
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

When `G` is selected during remediation, write a standalone file for the follow-up design. Use the path they gave. If none, ask, offering a name beside the design under review (finding's short title lowercased and hyphenated, e.g. "Cache invalidation strategy" becomes `cache-invalidation-strategy.md`).

The file must be self-contained so a fresh session can pick up the design with no extra context. Draw its structure from the design document itself: state the Problem, the Current State, and the Alternatives in play, and leave the Proposed Design open where deferring the approach is the point of spinning it out.

## Ticket (T)

Before showing either prompt, run `command -v tk`. Offer `T` only if it succeeds. Omit it from both prompts otherwise. Do not mention tk when it is absent.

Per-item `T` creates one tk ticket for that finding and continues the walk. Top-level `T` creates one tk ticket covering the remaining findings and stops.

When `T` is selected:

1. Run `tk create` with a title from the finding's short title (per-item) or a title covering the remaining set (top-level)
2. Then `start get contexts:ticket/writing`. Never fetch the writing guide at review start
3. The writing guide's File Placement section does not apply. The path is the one `tk create` printed
4. Fill under that H1. Do not paste a second heading
5. The writing guide supplies principles, section purpose, and formatting only
6. Track as `Ticket: <id>`
7. If `tk status mode` is `tk-driven`, `tk sync` after the body fill

Per-item fill: the ticket is that finding. Carry the instance, Simple Explanation, Details, Options, and Recommendation already presented.

Top-level fill: re-check each remaining finding with the same Recommendation lock as the walk. Skip any that no longer hold. Write each that still holds with its instance, Simple Explanation, Details, Options, and Recommendation so a fresh session can walk the set. Then stop.

## Save

Write the report only when the user asked to save it — including by invoking `S` — or when they instructed this run to proceed without intervention.

Use the path they gave. If they asked to save but named no path, ask. If they instructed this run to proceed without intervention and named no path, write to `.start/reviews/YYYY-MM-DD-design-review-NN.md` (`NN` starts at `01`, incrementing against existing files matching the date and type).

When writing after remediation has started, include the Remediation Summary with current outcomes. Findings not yet processed are recorded as `Pending`. Confirm the filename written.

## Commands

### Top-level Prompt

Display at the end of Phase 1. Include the Ticket line only if the Ticket (T) check succeeded.

```
- (C)ontinue — walk through the findings one at a time
- (A)ll — apply the recommended resolution to every finding automatically
- (S)ave — write the report and stop
- (T)icket — create a tk ticket for the remaining findings and stop
```

### Per-item Prompt

Display after presenting each finding. Include Ticket only if the Ticket (T) check succeeded.

```
(R)ecommended  (N)ext  Desi(g)n  (T)icket  (S)ave
```
