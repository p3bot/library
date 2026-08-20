# Ticket Document Review

Interactive review of a ticket document before implementation begins. Finds design flaws, missing requirements, incorrect assumptions, and owner decisions that would force rework if discovered mid-implementation, then walks through each one and integrates the resolution into the ticket content.

Goal: catch issues that would force rework if discovered mid-implementation. Routine implementation judgement — naming, defensive code, local refactors — stays with the implementer.

Finding no new issues is a valid outcome. If the ticket document is complete and prior reviews have surfaced the real concerns, say so rather than invent findings to justify the run.

## Workflow

### Phase 1: Review

1. Identify the ticket document from the user's instructions. If they named a path, use it. If they asked you to find it, look where they pointed. Otherwise ask.

   A library ticket document is a standalone markdown plan for one implementation pass.
2. Read the ticket document thoroughly.
3. Run the Size and Coherence Check (below). If it fires, still produce the report header and What this ticket does, then skip to Phase 4 and declare Split the ticket.
4. Analyse the repository:
   - Validate the stated current state against the actual codebase
   - Check whether the proposed approach covers all stated requirements
   - Research external facts only when the ticket's approach turns on them — a specific dependency version, an API behaviour, or a platform capability. Generic dependency scans produce noise over repeated runs
5. Identify concerns that meet the Goal bar — issues that would force rework, cause incorrect behaviour, or leave a critical requirement unmet. Apply the Articulation Test and Regret Filter (see Reviewer Guidance) before listing each one.
6. Produce a structured report using the Report Format (below) and present it inline. Do not write a report file unless Save applies.
7. If there are no actionable findings, skip to Phase 4 and declare Ready to implement. Otherwise display the Top-level Prompt (see Commands).

### Size and Coherence Check

Signals that a ticket is too broad for a single implementation pass:

- Multiple independent outcomes that could ship separately
- Distinct code areas with no shared integration
- A refactor or sub-feature nested inside the parent with its own requirements, scope, and acceptance criteria
- Implementation Plan steps that partition cleanly with a natural handoff

If these signals fire, the review short-circuits. Finer issues found against a ticket that is about to be split will mostly go stale.

### Phase 2: Remediation

Apply safe items immediately, without prompting. Safe items are anything that does not touch application code:

- Tests — add, remove, or change
- Comments — add, remove, or change
- Documentation — add, remove, or change, excluding the ticket document itself

State what was applied for each safe item. Safe items do not count toward `m`.

Let `m` be the count of remaining actionable findings (everything not auto-applied above). The top-level choice from Phase 1 selects how they are handled: `C` walks them one at a time, `A` applies the recommended resolution to every finding automatically. Letters are case-insensitive.

Continue (`C`) walks the findings one at a time. For each finding:

1. Re-read the relevant context — the ticket document and any referenced code — and critically re-evaluate the finding. The original may have been wrong, or rendered obsolete by an earlier fix. If the finding no longer holds, say so and revise or withdraw it before presenting.
2. Before presenting, lock the Recommendation: is it the root fix in the ticket content, or a local patch that leaves the underlying gap? Name the cheapest alternative and reject it only if it is worse on maintenance or correctness, not effort. If the finding still needs the document or code in the reader's head to make sense, rewrite the instance, Simple Explanation, and Details until it does not — or withdraw it.
3. Present the finding using the Per-item Template (below) with `n` as the position in the walk and `m` as the total. `m` excludes safe items applied above.
4. Display the Per-item Prompt (see Commands) and pause for an explicit decision. Never assume blanket approval from an earlier response. Accepting one finding does not authorise the next. If a response is ambiguous, ask which finding it applies to.

Per-item command semantics. Letters are case-insensitive. Outcomes are tracked in-session — they are not written to disk at the moment of decision. They surface in the Phase 4 summary table and in the Remediation Summary if the review is saved.

- An option letter (`A`, `B`, `C` …) — apply that specific option to the ticket document, fully integrating it so the underlying issue is covered by the new content. Do not leave an Issues Discovered section; resolved items become polished ticket content. Track as `Fixed`. Briefly confirm what was done.
- `R` — apply exactly what the Recommendation states, which may be a single option, a combination, or a blend. Otherwise identical to applying an option. Track as `Fixed`.
- `N` — acknowledge and move to the next finding. Track as `Skipped`.
- `T` — create a tk ticket for this finding (see Ticket (T) below). Track as `Ticket: <id>`. Move to the next finding without offering an inline resolution. Omit this command unless the Ticket (T) check succeeded
- `S` — see Save (below).

All (`A`) applies recommendations automatically. Work through the `m` findings in order without displaying the Per-item Prompt. For each finding:

1. Announce `(n of m) <short title>`.
2. Re-read the relevant context and critically re-evaluate the finding, as in the walk. If it no longer holds, say so and skip it, tracking as `Skipped`. Before applying, run the same Recommendation lock as step 2 of the walk.
3. Apply the recommended resolution — identical to `R` — and briefly confirm what was done. Track as `Fixed`.

The edit is the checkpoint. If you deny an edit, stop and discuss that finding; once it is resolved, resume the run for the remaining findings or switch to the one-at-a-time walk. For `decision` findings, the recommended alternative is applied — deny the edit to discuss if a different choice is wanted.

Remediation guidance:

- Bias recommendations toward the principled long-term solution in the ticket document — correct the design or requirement at the root, not a downstream workaround the implementer would paper over. Do not default to the smallest-diff edit. Prefer the option you would pick if rewriting the section were free
- Apply minimal, targeted edits to integrate the resolution. Refactor surrounding text only when required to make the resolution land cleanly.
- If a resolution would be too large or risky to apply inline, recommend `T` when `tk` is available, otherwise leave it for Save or a later pass

### Phase 3: Satisfaction Pass

After all findings have been processed, re-read the ticket document with fresh eyes. Surface any new issues the edits themselves introduced — internal inconsistencies, gaps created by removed content, contradictions with sections that were not touched.

- Handle new findings using the mode chosen at the top level — walk them under `C`, auto-apply them under `A` (deny an edit to discuss)
- This pass is lightweight — catch regressions introduced by the fixes, not run a full second review

### Phase 4: Wrap-up

1. Declare the outcome:
   - Ready to implement — no blocking issues remain
   - Issues to resolve — blocking issues remain; list them by number and title
   - Split the ticket — the document is too broad for a single implementation pass; summarise the seam

   An issue blocks implementation if proceeding without resolving it would force significant rework, cause incorrect behaviour, or leave a critical requirement unmet.
2. Print a summary table of all findings and their outcomes (see Remediation Summary in the Report Format). Do not prompt to save.

## Reviewer Guidance

- Trust the implementer — routine judgement on naming, defensive code, local refactors, and style stays with them
- Goal bar — flag a finding only if leaving it unresolved would force significant rework, cause incorrect behaviour, or leave a critical requirement unmet
- Articulation Test — if you cannot articulate what goes wrong when an item is left unresolved, it does not belong in the list
- Regret Filter — before finalising a finding, ask: would I regret not flagging this after implementation lands? If not, drop it
- Permission to find nothing — a late-run review that produces no findings is evidence the document is complete. Inventing findings to justify the run destroys the signal
- Recommendations target the principled long-term solution. Do not default to the minimal-diff resolution

## Issue Categories

| Category | Use when |
|----------|----------|
| decision | The owner needs to choose between valid alternatives |
| design | A flaw, weakness, or missing element in the design or architecture |
| gap | A requirement, step, or detail that is missing from the ticket document |
| risk | A potential problem that may not occur but should be acknowledged |
| dependency | An external dependency with version, compatibility, or availability concerns |

## Per-item Template

Findings are read by someone who has not opened the ticket document, cannot look anything up, and has to decide something after one read.

The bar: that reader can restate the problem in their own words after reading it once. A finding that fails this has failed, however accurate it is.

Open with the smallest concrete instance that shows the problem, then explain it. Four moves, in order:

1. Establish what correct looks like and show the break against it. Where the target runs, that is a command and its output with the expected value alongside. Where it does not — a plan, a proposed design, a document — it is the scenario the change would break, in plain language. Contrast two cases when the rule is conditional; the contrast is usually what makes the break obvious
2. Give the Simple Explanation — one or two sentences in everyday language naming the problem, so the reader has the gist before any cause chain
3. Say what causes it, in the same terms
4. Say what it costs

Writing rules:

- Name things by what they are, not by what they are called in the code. "the providers column", not `KnownAgent.Provider`. Symbols and `file:line` follow the plain-language noun in parentheses as anchors; they never carry the explanation
- Spell out internal shorthand on first use. Requirement ids, section codes, and codebase acronyms mean nothing to the reader
- Never fabricate an observable. If the thing under review does not run yet, do not dress a structure diff up as command output — show the scenario instead
- Length follows comprehension. Cut padding, never cut the setup that makes the rest land
- Do not argue the finding is real or recap the ticket's intent. The instance and the explanation carry it
- Separate each option with a blank line. Never collapse options onto one line

```
### Finding n of m: <short title>

Category: <decision | design | gap | risk | dependency>
Location: <file:line, or section heading if relevant>

<the smallest concrete instance: command → output with the expected value
alongside where the target runs; the scenario the change would break where it
does not. Show it; do not describe it.>

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
### Finding 2 of 4: Redesign drops the provider list the CLI prints

Category: design
Location: R3 Query, result, and detail types

  agents get claude-code                     → providers: anthropic
  agents get opencode --provider anthropic   → providers: anthropic   (today)
                                             → providers: <empty>     (under R3)

**Simple Explanation**

After the redesign, the CLI can no longer show which provider an agent is
using when that provider was passed on the command line rather than built in.

**Details**

The CLI prints a providers column for each agent. An agent like claude-code has
a built-in provider, anthropic, so the column shows anthropic. An agent like
opencode has no built-in provider — you tell it which one to use on the command
line, and the column should then show what you passed.

Today the library hands the CLI one ready-made field holding the providers
actually used: the built-in ones, or the ones you passed. The CLI prints that
field and nothing else. The redesign in R3 deletes that field and keeps only the
built-in list, which for opencode is empty, so nothing in the returned data
holds anthropic.

The CLI's only recourse is to detect the no-built-in-provider case itself and
substitute the value it passed in — which puts the provider-source decision back
in the CLI, the exact thing R3 set out to remove.

**Decision**

How does the returned agent expose the provider list the CLI prints?

**Options**

A. Add a resolved-providers field alongside the built-in list — always
   populated, holding the built-in providers or the ones passed in. Keeps both
   the declared and the resolved sets visible.

B. Replace the built-in list with the resolved one. Smaller surface, but the
   declared-versus-resolved distinction is lost.

**Recommendation (A)**

Option A: it restores the field the CLI already reads with no special-casing,
and keeps the built-in list as the capability fact it is.
```

Display the Per-item Prompt (see Commands) immediately after presenting the finding.

For decisions, the Options block lists the alternatives the owner is choosing between, labelled from `A`. For other categories, include an Options block only when alternatives clarify the choice — otherwise omit it and lead with a single Recommendation that `R` accepts. Separate each option with a blank line. The Recommendation names the option letter or letters it favours, and may combine options (for example `Recommendation (B + C)`).

## Report Format

Structure the inline review report as follows. After the header, bullet what the ticket does before listing findings. Each bullet is one outcome or change after the ticket lands — not the implementation plan and not a dump of the requirements.

```
## Ticket Document Review

Ticket: <path to ticket document>
Intent: <one sentence on what the ticket sets out to do>
Findings: <count by category, e.g. 1 decision, 2 design, 1 gap>
Safe items: <changes to apply on remediation, or "None">

## What this ticket does

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

<overall assessment of the ticket document, noting strengths and weaknesses>
```

When the report is saved after remediation begins, append the section below. Outcome values:

- `Fixed` — the resolution was applied to the ticket document
- `Skipped` — the finding was acknowledged with `N` and left unresolved
- `Ticket: <id>` — spun out as a tk ticket
- `Pending` — `S` was invoked before the finding had been processed

```
## Remediation Summary

| # | Category | Finding | Outcome |
|---|----------|---------|---------|
| 1 | design | Brief description | Fixed |
| 2 | decision | Brief description | Skipped |
| 3 | gap | Brief description | Ticket: lib-a3 |
| 4 | risk | Brief description | Pending |
```

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

Use the path they gave. If they asked to save but named no path, ask. If they instructed this run to proceed without intervention and named no path, write to `.start/reviews/YYYY-MM-DD-ticket-doc-review-NN.md` (`NN` starts at `01`, incrementing against existing files matching the date and slug).

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
(R)ecommended  (N)ext  (T)icket  (S)ave
```
