# Multi-Agent Review Orchestrator

Orchestrate a comprehensive code review by discovering relevant review types, spawning parallel review agents, consolidating their findings into a single prioritised summary, and walking through fixing them.

## Step 1: Discover Edit Agent

Run the following command to find installed agents:

```
start config list agents
```

Select an agent with "edit" in the name. Edit agents auto-accept file writes while maintaining other safety permissions.

Do not use "unattended" or "bypass-permissions" variants.

If no edit agent is installed, list the available agents from the registry:

```
start library agents
```

Pick an agent with "edit" in the name and install it:

```
start install <name>
```

If no edit agent is available at all, use a standard agent.

Record the selected agent name for use in Step 5.

## Step 2: Discover Review Tasks

Run the following command to list available review tasks:

```
start search review/
```

Extract review task names from the output. Exclude any task with "orchestrator" in the name.

## Step 3: Install Missing Modules

Check installed modules:

```
start list
```

Install each review task from Step 2 that is not already installed:

```
start install review/<name>
```

## Step 4: Analyse Codebase for Relevance

Analyse the project structure, source files, dependencies, and patterns to determine which of the discovered review types apply. Select only the reviews that are relevant to what the project actually contains.

## Step 5: Spawn Parallel Reviews

Create the output directory:

```bash
mkdir -p .start/reviews
```

Launch each selected review as a separate shell tool call so they can be monitored independently:

```bash
start task review/<type> --agent <agent> "Write your review report to .start/reviews/ using the filename pattern YYYY-MM-DD-<type>-NN.md where NN is a zero-padded sequential count starting at 01 based on existing matching files. Tag every finding with a severity (critical, high, medium, low, or info) and a file:line location. Severity reflects impact, not category — most reviews will not reach critical or high, and a finding with no real severity weight is info. Use low-token markdown: headings, lists, tables, code blocks, callout prefixes (NOTE:, WARNING:, IMPORTANT:). Do not use bold, italic, horizontal rules, emojis, HTML comments, or nested lists beyond 3 levels."
```

Replace `<type>` with each selected review name and `<agent>` with the agent from Step 1. Execute one shell tool call per review so each runs as a separate background process.

## Step 6: Monitor Progress

As reviews complete, report progress using this format:

```
Status: <N> done, <N> running, <N> pending

| Review      | Status  | Output                                    |
|-------------|---------|-------------------------------------------|
| security    | Done    | .start/reviews/YYYY-MM-DD-security-01.md  |
| correctness | Running | —                                         |
| holistic    | Pending | —                                         |
```

After each review completes, verify:

- The expected output file exists in `.start/reviews/`
- The file is not suspiciously small (under ~200 bytes may indicate an error)

Mark any review with a missing or empty output file as failed and record it for the Coverage section in Step 7.

## Step 7: Synthesise Findings

After all reviews complete, read every generated report in `.start/reviews/`.

Collect every finding across all reports into a single set. Assign each a globally-unique ID: its severity letter (`C`, `H`, `M`, `L`, `I`) plus a running per-severity number — `C1`, `C2`, `H1`, `H2`, `M1`, `L1`, `I1`. There is only one `C1` across the whole summary. The ID carries the severity, so severity is not repeated as a separate column.

Severity reflects impact. Most reviews will not reach critical or high; descriptive reviews such as documentation, readability, and duplication naturally cluster at low and info. Normalise across reports: backfill a severity for any finding that arrived untagged, and adjudicate a sub-agent's classification down or up where the cross-report view warrants it. Info items are recorded for awareness only and are not walked.

Present the consolidated summary using the Summary Format (below).

If synthesis turns up no actionable findings — only info items, or none at all — report that and skip to Step 10. Otherwise, display the Top-level Prompt (see Commands).

## Step 8: Remediation

Apply safe items immediately, without prompting. Safe items are anything that does not touch application code:

- Tests — add, remove, or change
- Comments — add, remove, or change
- Documentation — add, remove, or change

State what was applied for each safe item. Safe items do not count toward `T`.

Let `T` be the count of remaining actionable findings — the critical, high, medium, and low items, excluding info items (recorded only) and the safe items applied above. The top-level choice selects how they are handled: `C` walks them one at a time in severity order, `A` applies the recommended resolution to every finding automatically.

Continue (`C`) walks the findings one at a time in severity order. For each finding:

1. Verify the finding first. It came from another agent's report, not your own analysis — re-read the actual code at the location, and the source report if useful, to confirm the issue is real and current. If it no longer holds, say so and withdraw it before presenting.
2. Build the Options and Recommendation from the verified issue and the code you just read, then present using the Per-item Template (below) with `n` as the position in the walk and `T` as the total.
3. Display the Per-item Prompt (see Commands) and pause for an explicit decision. Never assume blanket approval from an earlier response. Accepting one finding does not authorise the next. If a response is ambiguous, ask which finding it applies to.

Per-item command semantics. Outcomes are tracked in-session and surface in the Step 10 outcome table.

- An option letter (`A`, `B`, `C` …) — apply that specific option. Track as `Fixed`. Briefly confirm what was done.
- `R` — apply exactly what the Recommendation states, which may be a single option, a combination, or a blend. Track as `Fixed`.
- `N` — acknowledge and move to the next finding. Track as `Skipped`.
- `P` — spin the finding out as its own standalone project file (see Project File Format below), then continue to the next finding. Track as `Project: <filename>`.
- `S` — see the Save behaviour below.

All (`A`) applies recommendations automatically. Work through the `T` findings in severity order without displaying the Per-item Prompt. For each finding:

1. Announce `(n of T) <ID> <short title>`.
2. Verify the finding against the code as in the walk. If it no longer holds, say so and skip it, tracking as `Skipped`.
3. Apply the recommended resolution — identical to `R` — and briefly confirm what was done. Track as `Fixed`.

The edit is the checkpoint. If you deny an edit, stop and discuss that finding; once it is resolved, resume the run for the remaining findings or switch to the one-at-a-time walk.

Save (`S`) writes the outstanding findings to a project file and stops. Outstanding findings are those not yet fixed or skipped. Verify each outstanding finding and build its Issue, Options, and Recommendation, then write them all into a single multi-finding project file (see Project File Format below). Findings already fixed, skipped, or spun out are recorded in an Already Handled block for context. Confirm the filename written.

Remediation guidance:

- Bias recommendations toward the principled long-term solution that reduces maintenance and improves quality. Do not default to the smallest-diff resolution
- Apply minimal, targeted edits to integrate the resolution. Refactor surrounding code only when required to make the resolution land cleanly
- If a resolution would be too large or risky to apply inline, recommend `P` to spin it out rather than attempting it inline
- Keep each fix focused on the issue being addressed and related code

## Step 9: Satisfaction Pass

After all findings have been processed on the `C` or `A` path, do a focused re-check on only the code that was modified by fixes during Step 8. Skip this step entirely if `S` was chosen, since no code was edited.

- Only examine the lines and immediate context touched by fixes, not a full re-review
- Handle new findings using the mode chosen at the top level — walk them under `C`, auto-apply them under `A` (deny an edit to discuss)
- This pass is lightweight — catch regressions introduced by the fixes themselves
- After fixes are applied, run any formatters or linters the project has configured on the touched files and address any new violations they surface

## Step 10: Wrap-up

1. Print the outcome table of all findings and their outcomes
2. If any finding was skipped or left outstanding, prompt the user once: enter `S` to write those findings to a project file. Any other reply skips the save
3. Remind the user to review the changes before committing

Outcome table:

```
| ID | Review        | Finding           | Outcome                                    |
|----|---------------|-------------------|--------------------------------------------|
| C1 | security      | Brief description | Fixed                                      |
| H1 | correctness   | Brief description | Skipped                                    |
| M1 | readability   | Brief description | Project: 01-race-condition-in-refresh.md   |
| L1 | documentation | Brief description | Pending                                    |
```

Outcome values:

- `Fixed` — the change was applied
- `Skipped` — the finding was acknowledged with `N` and left unresolved
- `Project: <filename>` — spun out as a standalone project file
- `Pending` — `S` was invoked before the finding had been processed

## Guidance

- The sub-agent reports are your input, but the findings are second-hand — verify each against the actual code before acting on it
- Recommendations target the principled long-term solution. Do not default to the minimal-diff resolution
- Severity reflects impact, not category. Not every review produces findings at every severity level — use the levels that fit rather than forcing findings into categories that do not apply
- It is acceptable to find no issues. Do not manufacture findings to justify the review
- The Findings table lists every finding in severity order; the count line summarises the totals

## Per-item Template

Findings are read by someone who has not opened the code, cannot look anything up, and has to decide something after one read. This applies with extra force here — the finding arrives from a subagent that read the code, and the reader did not.

The bar: that reader can restate the problem in their own words after reading it once. A finding that fails this has failed, however accurate it is.

Open with the smallest concrete instance that shows the problem, then explain it. Three moves, in order:

1. Establish what correct looks like and show the break against it. Where the code runs, that is a command and its output, a call and its return, or a request and its response, with the expected value alongside — `ParseDuration("500ms") → 0s (want 500ms)`. Where the change is structural and produces no output, it is the scenario it would break, in plain language. Contrast two cases when the behaviour is conditional; the contrast is usually what makes the break obvious
2. Say what causes it, in the same terms
3. Say what it costs

Writing rules:

- Name things by what they are, not by what they are called in the code. "the retry counter", not `svc.rc`. Symbols and `file:line` follow the plain-language noun in parentheses as anchors; they never carry the explanation
- Spell out internal shorthand on first use. Requirement ids, ticket numbers, and project acronyms mean nothing to the reader. A subagent's own abbreviations never survive into the presented finding
- Never fabricate an observable. If the code path cannot be run as written, do not dress a structure diff up as command output — show the scenario instead
- Length follows comprehension. Cut padding, never cut the setup that makes the rest land
- Do not argue the finding is real or recap intent. The instance and the explanation carry it

```
### Issue n of T — <ID>: <short title>

Review: <e.g. security, correctness>
Location: <file:line>

<the smallest concrete instance: command → output, request → response, call →
return, with the expected value alongside — or the scenario the change breaks
where nothing runs. Show it; do not describe it.>

**Issue**

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
### Issue 1 of 4 — H1: Session cookie is issued without the Secure flag

Review: security
Location: internal/http/session.go:88

  $ curl -i https://app.local/login -d 'user=demo&pass=demo'
  → Set-Cookie: sid=abc123; HttpOnly; Path=/
                                     (want: ; Secure)

**Issue**

The cookie is built with HttpOnly but never sets Secure, so the browser will
send it back over plain HTTP as well as HTTPS. Anyone able to induce a single
http:// request to the domain — a stray link, a mixed-content asset, a captive
portal — sees the session identifier in clear text and can replay it.

**Decision**

Set Secure unconditionally, or only outside local development?

**Options**

A. Always set Secure, and serve local development over HTTPS. One code path,
   no environment-dependent security posture.
B. Set Secure unless a development flag is set. Keeps plain-HTTP local setup
   working, at the cost of a weaker configuration that can ship by accident.

**Recommendation (A)**

Option A: a flag that disables a security control is the kind that eventually
reaches production, and local HTTPS is a one-time setup cost.
```

Display the Per-item Prompt (see Commands) immediately after presenting the finding.

Include an Options block only when alternatives clarify the choice — otherwise omit it and lead with a single Recommendation that `R` accepts. When present, label options from `A`. The Recommendation names the option letter or letters it favours, and may combine options (for example `Recommendation (B + C)`).

## Summary Format

Structure the consolidated summary as follows:

```
## Review Summary

Reviews: <N> run, <N> skipped, <N> failed
Findings: <count per severity, e.g. 2 critical, 1 high, 3 medium, 1 low, 4 info>

## Coverage

Selected: <review — rationale for each selected review>
Skipped: <review — rationale for each skipped review>
Failed: <review — what went wrong, or none>

## Findings

| ID | Review        | Location       | Finding            |
|----|---------------|----------------|--------------------|
| C1 | security      | src/auth.go:88 | <one-line summary> |
| H1 | correctness   | src/calc.go:12 | <one-line summary> |
| I1 | documentation | README.md:1    | <one-line summary> |

## Assessment

<overall assessment across all reviews, noting both strengths and weaknesses>
```

List every finding in severity order — do not truncate. Info items are included in the table but are recorded for awareness only and are not walked. The detail for each actionable finding (Issue, Options, Recommendation) is presented one at a time during the Step 8 walk, not here.

## Project File Format

Both `P` and `S` write standalone project files at the repository root named `NN-<slug>.md`, where:

- `NN` starts at `01` and increments based on existing files matching the pattern, shared across all project files
- `<slug>` is the title lowercased and hyphenated (for example "Race condition in token refresh" becomes `race-condition-in-token-refresh`)

`P` writes a single finding. Use the `<short title>` from the Per-item Template as the title. The file must be fully self-contained so a new agent session can pick it up with no extra context. Include only the sections that apply — right-size the document to the scope of the finding.

```
# <title>

Source: multi-agent review on YYYY-MM-DD
Severity: <critical | high | medium | low>
Review: <e.g. security, correctness>
Location: <file:line>

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

`S` writes the outstanding findings as one multi-finding file. Generate a concise descriptive title for the review as a whole. Each finding carries the verified Issue, Options, and Recommendation built during the walk.

```
# <title>

Source: multi-agent review on YYYY-MM-DD
Reviews: <reviews run>
Findings: <count per severity>

## Goal

One to three sentences on remediating the issues found across the codebase.

## Scope

What is in scope; what is explicitly out of scope.

## Constraints

Hard rules: language version, target platforms, required tooling, compatibility requirements.

## Already Handled

Findings resolved before the save, for context. Omit if none.

- C2 Fixed — <brief>
- M3 Skipped — <brief>
- L1 Project: 02-<slug>.md

## Findings

### C1 — <short title>

Review: <e.g. security>
Location: <file:line>

Issue
<verified description and why it matters>

Options
A. <option>
B. <option>

Recommendation (B): <which option, brief why>

## Acceptance Criteria

Observable, verifiable outcomes that signal the remediation is complete.
```

Writing guidelines:

- Define outcomes and constraints, not keystrokes. The implementing agent owns implementation details
- Be explicit and complete — do not reference the conversation that produced the finding
- Code snippets are acceptable for clarification; full implementations are not
- Use direct language: "do X", not "consider doing X"

## Commands

### Top-level Prompt

Display verbatim after the summary:

```
- (C)ontinue — walk the findings one at a time, fixing each
- (A)ll — apply the recommended fix to every finding automatically
- (S)ave — write the findings to a project file for later and stop
```

### Per-item Prompt

Display verbatim after presenting each finding:

```
(R)ecommended  (N)ext  (P)roject  (S)ave
```
