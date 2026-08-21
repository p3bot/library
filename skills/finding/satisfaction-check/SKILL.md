---
name: satisfaction-check
description: Critical fresh-eyes self-review of the work just produced, surfacing what is wrong rather than reassuring. Triggered by `sat`. Produces a findings list for remediation.
---

# Satisfaction Check — sat

Review the work just produced as if it were someone else's and your job is to find what is wrong. This skill is a critic, not a fixer: it surfaces a findings list, then offers the one-by-one top-level menu so the user can walk, apply, save, or ticket that list.

Targets can be code or prose — application source, or documents, prompts, specs, and skill files. The dimensions and checks below adapt to which.

Work in scope = the changes produced in the current session: files written or edited, decisions made, and anything claimed done. Not a fresh full-repository audit — a regression check on what this session introduced.

## Trigger

`sat` — Satisfaction Check. Treat as a command, not chat. Don't ask for confirmation; run the review and produce the findings.

## Stance

Apply fresh eyes. The work has an author and it is not you; your job is to find what they got wrong. Be honest, not generous.

- Assume there is something wrong and go looking for it. A clean pass is a conclusion you earn, not a starting position.
- Do not reassure, congratulate, or soften. "Looks good" is not a finding; if the work is sound, say what you checked and why it holds.
- Judge the work as built against what was asked, not against a charitable reading of your own intent.
- Surface uncertainty as a finding. "I could not verify X" is more useful than silent confidence.

## Review dimensions

Scale the lenses to what changed — a prose edit has no concurrency surface, a one-line fix needs no architecture pass. Walk the dimensions that apply and skip those that do not, stating which you skipped and why.

### Correctness and completeness

- Does the work actually do what was asked, end to end? Are there requirements quietly dropped or only half-met?
- Are there half-finished implementations, stubs, placeholder values, or TODO/FIXME markers left behind?
- Are there hidden assumptions, silent failures, swallowed errors, "this can't happen" branches, or unhandled edge and boundary cases?
- Off-by-one, wrong operator, inverted condition, wrong order of operations — the small logic errors that survive a confident read.

### Tests and verification

- Is everything that can be tested, tested? Do the tests cover the behaviour, not just execute the code for coverage's sake?
- Were the tests actually run, and did they pass? If a step was skipped or a suite not run, say so plainly.
- Are edge cases and failure paths tested, or only the happy path?
- Is the production code testable, or did its shape force the tests to be shallow?

### Principled quality

- Did you cut a corner or default to the smallest-diff fix when a principled, structural solution was warranted? (See Principled bias.)
- Did human-calendar effort tip a decision toward a workaround it should not have? (See Agent-time.)
- Names: does every name still mean what it says after this change? A name that no longer fits is a defect, not a nitpick.
- Did the change add comment bloat, or restate what the code already says? (See Comment discipline.)
- Duplication introduced that should be consolidated — or a speculative abstraction added for a variant that has not arrived.

### Fit and consequence

- Would a senior engineer push back on this in review? On what, specifically?
- Does it fit the existing patterns and structure, or does it fight them?
- Blast radius: anything irreversible, production-affecting, or destructive that was done without enough care or confirmation?
- Would future-you regret any of these decisions?

## Standards the work is held to

These are the same standards one-by-one applies when fixing, stated here as the bar the review measures against. A finding is a gap between the work and one of these.

### Principled bias

The bar is the principled long-term solution, not the smallest-diff resolution.

- Land at the root of the problem, not the symptom. A fix to the assertion that surfaced a bug, rather than the broken invariant, is a finding.
- Names are contracts. A misleading or stale name is a defect equal in weight to a bug.
- Abstractions earn their place by reducing total complexity now. Three similar lines today beat a speculative abstraction for a fourth variant that may never arrive — and the reverse, copy-paste that should have been consolidated, is equally a finding.
- Errors and edge cases get the same care as the happy path. Fail loud; flag any swallowed exception or silent failure.

### Agent-time

Estimate in agent-time, not human-time, when judging whether a corner was justified.

- A workaround excused by "the proper fix is too much work" is a finding. Typing is not the expensive axis; mechanical volume — renames, codemods, boilerplate — is cheap.
- The expensive axes are specification, verification, reversibility, runtime cost, and human comprehension. A shortcut is only justified by cost on one of those, never by authoring effort.
- Cheap to write is not a licence to write more. Gratuitous volume — more code, more abstraction, more comments than the problem needs — is also a finding.

### Comment discipline

- Comments document WHY, not WHAT. A comment that restates the identifier or paraphrases the next line is noise — flag it.
- No roadmap, ticket, PR, or conversation references; no commented-out code; no apologetic or decorative comments.
- No TODO or FIXME stubs left behind.
- Respect tool-mandated doc-comment forms (godoc, rustdoc, Sphinx, TypeDoc) on public APIs — their absence on a new public symbol is a finding.

## Output: the findings list

Report what you find as a findings table. Use the same shape one-by-one consumes, so the list is ready to hand off directly:

```
| # | Category / Severity | Location | Finding |
|---|---------------------|----------|---------|
| 1 | Correctness | <file:line> | <one-line summary of what is wrong> |
| 2 | Tests | <file:line> | <one-line summary> |
```

- Category is the review dimension the finding came from (Correctness, Tests, Principled, Comments, Fit, …). Add a severity if it clarifies priority.
- Order by severity, most serious first.
- Keep each finding to one line in the table; expand below the table only where a finding needs context to act on.
- If the review is genuinely clean, say so and state what you checked to reach that — do not invent findings to fill the table.

## Handoff to one-by-one

The findings table is the list obo consumes. Do not fix anything inline — sat finds, obo fixes.

If this skill is running as the satisfaction pass inside an already-started one-by-one walk, present the table and return any new findings to that walk. Do not display the Top-level Prompt. Do not load or fetch one-by-one. The current walk handles them under the mode already chosen.

Otherwise, when there is at least one finding, run `command -v tk`, display the Top-level Prompt, and wait. Include the Ticket line only if that check succeeded. Do not mention tk when it is absent. Letters are case-insensitive. Treat `obo` or `one-by-one` as C.

```
 (C)ontinue — walk the findings one at a time
 (A)ll — apply the recommended resolution to every finding (principled bias; deny an edit to pause and discuss)
 (S)ave — bundle the findings into a ticket document and stop
 (T)icket — create a tk ticket for the remaining findings and stop
```

The user's letter is the handoff. Follow the one-by-one skill with this list and this mode. Skip its Phase 1 re-prompt: do not reprint the table, do not wait for a second choice. If that skill is not already in context, run `start get skills:finding/one-by-one` and follow it.
