# Project Document Review

Interactive review of a project document before implementation begins. Finds design flaws, missing requirements, incorrect assumptions, and owner decisions that would force rework if discovered mid-implementation, then walks through each one and integrates the resolution into the project content.

Goal: catch issues that would force rework if discovered mid-implementation. Routine implementation judgement — naming, defensive code, local refactors — stays with the implementer.

Finding no new issues is a valid outcome. If the project document is complete and prior reviews have surfaced the real concerns, say so rather than invent findings to justify the run.

## Workflow

### Phase 1: Review

1. Identify the project document. If the user named one — in the task instructions or the conversation — use it. Otherwise look for clues in:
   - `AGENTS.md` — check for any reference to a current or active project
   - Repository root — scan for a project or specification document among the markdown or document files present
   - Agent directories: `.agents/`, `.claude/`, `.cursor/`, `.gemini/`, or similar
   - Documentation folders: `docs/`

   The project may be described as "active", "current", "in progress", "working on", or similar terms. Do not assume a fixed filename. If exactly one clear candidate is found, use it. If multiple candidates are found, or none can be identified with confidence, ask the user which file to use.
2. Read the project document thoroughly.
3. Run the Size and Coherence Check (below). If it fires, skip to Phase 4 and declare Split the project.
4. Analyse the repository:
   - Validate the stated current state against the actual codebase
   - Check whether the proposed approach covers all stated requirements
   - Research external facts only when the project's approach turns on them — a specific dependency version, an API behaviour, or a platform capability. Generic dependency scans produce noise over repeated runs
5. Identify concerns that meet the Goal bar — issues that would force rework, cause incorrect behaviour, or leave a critical requirement unmet. Apply the Articulation Test and Regret Filter (see Reviewer Guidance) before listing each one.
6. Produce a structured report of findings using the Report Format (below) and present it inline. No disk writes.
7. If there are no actionable findings, skip to Phase 4 and declare Ready to implement. Otherwise display the Top-level Prompt (see Commands).

### Size and Coherence Check

Signals that a project is too broad for a single implementation pass:

- Multiple independent outcomes that could ship separately
- Distinct code areas with no shared integration
- A refactor or sub-feature nested inside the parent with its own requirements, scope, and acceptance criteria
- Implementation Plan steps that partition cleanly with a natural handoff

If these signals fire, the review short-circuits. Finer issues found against a project that is about to be split will mostly go stale.

### Phase 2: Remediation

Apply safe items immediately, without prompting. Safe items are anything that does not touch application code:

- Tests — add, remove, or change
- Comments — add, remove, or change
- Documentation — add, remove, or change, excluding the project document itself

State what was applied for each safe item. Safe items do not count toward `T`.

Let `T` be the count of remaining actionable findings (everything not auto-applied above). The top-level choice from Phase 1 selects how they are handled: `C` walks them one at a time, `A` applies the recommended resolution to every finding automatically. Letters are case-insensitive.

Continue (`C`) walks the findings one at a time. For each finding:

1. Re-read the relevant context — the project document and any referenced code — and critically re-evaluate the finding. The original may have been wrong, or rendered obsolete by an earlier fix. If the finding no longer holds, say so and revise or withdraw it before presenting.
2. Before presenting, lock the Recommendation: is it the root fix in the project content, or a local patch that leaves the underlying gap? Name the cheapest alternative and reject it only if it is worse on maintenance or correctness, not effort. If the finding still needs the document or code in the reader's head to make sense, rewrite the instance, Simple Explanation, and Details until it does not — or withdraw it.
3. Present the finding using the Per-item Template (below) with `n` as the position in the walk and `T` as the total. `T` excludes safe items applied above.
4. Display the Per-item Prompt (see Commands) and pause for an explicit decision. Never assume blanket approval from an earlier response. Accepting one finding does not authorise the next. If a response is ambiguous, ask which finding it applies to.

Per-item command semantics. Letters are case-insensitive. Outcomes are tracked in-session — they are not written to disk at the moment of decision. They surface in the Phase 4 summary table and in the Remediation Summary if the review is saved.

- An option letter (`A`, `B`, `C` …) — apply that specific option to the project document, fully integrating it so the underlying issue is covered by the new content. Do not leave an Issues Discovered section; resolved items become polished project content. Track as `Fixed`. Briefly confirm what was done.
- `R` — apply exactly what the Recommendation states, which may be a single option, a combination, or a blend. Otherwise identical to applying an option. Track as `Fixed`.
- `N` — acknowledge and move to the next finding. Track as `Skipped`.
- `P` — spin the finding out as a standalone follow-up file (see Project File Format below). Track as `Project: <filename>`. Move to the next finding without offering an inline resolution.
- `S` — see Save (below).

All (`A`) applies recommendations automatically. Work through the `T` findings in order without displaying the Per-item Prompt. For each finding:

1. Announce `(n of T) <short title>`.
2. Re-read the relevant context and critically re-evaluate the finding, as in the walk. If it no longer holds, say so and skip it, tracking as `Skipped`. Before applying, run the same Recommendation lock as step 2 of the walk.
3. Apply the recommended resolution — identical to `R` — and briefly confirm what was done. Track as `Fixed`.

The edit is the checkpoint. If you deny an edit, stop and discuss that finding; once it is resolved, resume the run for the remaining findings or switch to the one-at-a-time walk. For `decision` findings, the recommended alternative is applied — deny the edit to discuss if a different choice is wanted.

Remediation guidance:

- Bias recommendations toward the principled long-term solution in the project document — correct the design or requirement at the root, not a downstream workaround the implementer would paper over. Do not default to the smallest-diff edit. Prefer the option you would pick if rewriting the section were free
- Apply minimal, targeted edits to integrate the resolution. Refactor surrounding text only when required to make the resolution land cleanly.
- If a resolution would be too large or risky to apply inline, recommend `P` to spin it out rather than attempting it inline.

### Phase 3: Satisfaction Pass

After all findings have been processed, re-read the project document with fresh eyes. Surface any new issues the edits themselves introduced — internal inconsistencies, gaps created by removed content, contradictions with sections that were not touched.

- Handle new findings using the mode chosen at the top level — walk them under `C`, auto-apply them under `A` (deny an edit to discuss)
- This pass is lightweight — catch regressions introduced by the fixes, not run a full second review

### Phase 4: Wrap-up

1. Declare the outcome:
   - Ready to implement — no blocking issues remain
   - Issues to resolve — blocking issues remain; list them by number and title
   - Split the project — the document is too broad for a single implementation pass; summarise the seam

   An issue blocks implementation if proceeding without resolving it would force significant rework, cause incorrect behaviour, or leave a critical requirement unmet.
2. Print a summary table of all findings and their outcomes (see Remediation Summary in the Report Format).
3. Prompt the user once: enter `S` to write the final report. Any other reply skips the save.

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
| gap | A requirement, step, or detail that is missing from the project document |
| risk | A potential problem that may not occur but should be acknowledged |
| dependency | An external dependency with version, compatibility, or availability concerns |

## Per-item Template

Findings are read by someone who has not opened the project document, cannot look anything up, and has to decide something after one read.

The bar: that reader can restate the problem in their own words after reading it once. A finding that fails this has failed, however accurate it is.

Open with the smallest concrete instance that shows the problem, then explain it. Four moves, in order:

1. Establish what correct looks like and show the break against it. Where the target runs, that is a command and its output with the expected value alongside. Where it does not — a plan, a proposed design, a document — it is the scenario the change would break, in plain language. Contrast two cases when the rule is conditional; the contrast is usually what makes the break obvious
2. Give the Simple Explanation — one or two sentences in everyday language naming the problem, so the reader has the gist before any cause chain
3. Say what causes it, in the same terms
4. Say what it costs

Writing rules:

- Name things by what they are, not by what they are called in the code. "the providers column", not `KnownAgent.Provider`. Symbols and `file:line` follow the plain-language noun in parentheses as anchors; they never carry the explanation
- Spell out internal shorthand on first use. Requirement ids, section codes, and project acronyms mean nothing to the reader
- Never fabricate an observable. If the thing under review does not run yet, do not dress a structure diff up as command output — show the scenario instead
- Length follows comprehension. Cut padding, never cut the setup that makes the rest land
- Do not argue the finding is real or recap the project's intent. The instance and the explanation carry it
- Separate each option with a blank line. Never collapse options onto one line

```
### Finding n of T: <short title>

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

Structure the inline review report as follows:

```
## Project Document Review

Project: <path to project document>
Intent: <one sentence on what the project sets out to do>
Findings: <count by category, e.g. 1 decision, 2 design, 1 gap>
Safe items: <changes to apply on remediation, or "None">

## Findings

A complete list of every finding — list all of them, do not truncate. The detail for each actionable finding (Simple Explanation, Details, Options, Recommendation) is presented one at a time during the Phase 2 walk, not here.

| # | Category | Finding |
|---|----------|---------|
| 1 | <category> | <one-line summary> |
| 2 | <category> | <one-line summary> |
| 3 | <category> | <one-line summary> |

## Assessment

<overall assessment of the project document, noting strengths and weaknesses>
```

When the report is saved after remediation begins, append the section below. Outcome values:

- `Fixed` — the resolution was applied to the project document
- `Skipped` — the finding was acknowledged with `N` and left unresolved
- `Project: <filename>` — spun out as a standalone follow-up
- `Pending` — `S` was invoked before the finding had been processed

```
## Remediation Summary

| # | Category | Finding | Outcome |
|---|----------|---------|---------|
| 1 | design | Brief description | Fixed |
| 2 | decision | Brief description | Skipped |
| 3 | gap | Brief description | Project: 01-add-rate-limiting.md |
| 4 | risk | Brief description | Pending |
```

## Project File Format

When `P` is selected during remediation, write a standalone file at the repository root named `NN-<slug>.md` where:

- `NN` starts at `01` and increments based on existing files matching the pattern
- `<slug>` is the short title lowercased and hyphenated (e.g. "Race condition in token refresh" becomes `race-condition-in-token-refresh`)

The file must be fully self-contained so a new AI agent session can pick it up with no extra context. Include only the sections below that apply — right-size the document to the scope of the finding.

```
# <title>

Source: project-doc-review on YYYY-MM-DD
Category: <decision | design | gap | risk | dependency>
Location: <file:line, or section heading>

## Goal

One to three sentences on what is being built or changed and why. Focus on outcome and motivation, not tasks.

## Scope

What is in scope; what is explicitly out of scope.

## Current State

Relevant existing state — files, configuration, and the finding itself — enough that the implementer can read the requirements with understanding.

## Requirements

Numbered, clear, verifiable deliverables. State what must be produced, not how.

## Implementation Plan

Ordered steps at a level that gives direction without prescribing code. Snippets are acceptable to clarify non-obvious integration. Omit if the requirements are self-explanatory.

## Constraints

Hard rules: language version, target platforms, required tooling, compatibility requirements. Items that cannot be violated without breaking the project.

## Acceptance Criteria

Observable, verifiable outcomes that signal completion. Project-specific only — do not list universals like "build passes" or "tests pass".
```

Writing guidelines:

- Define outcomes and constraints, not keystrokes. The implementing agent owns implementation details
- Be explicit and complete — do not reference the conversation that produced the finding
- Code snippets are acceptable for clarification; full implementations are not
- Use direct language: "do X", not "consider doing X"

## Save

When `S` is invoked at any phase:

1. Discover the next available filename: `.start/reviews/YYYY-MM-DD-project-doc-review-NN.md` where `YYYY-MM-DD` is today's date and `NN` starts at `01`, incrementing based on existing files matching the date and slug
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
(R)ecommended  (N)ext  (P)roject  (S)ave
```
