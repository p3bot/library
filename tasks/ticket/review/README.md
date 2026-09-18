# Ticket Review Task

This directory holds the ticket review task. This README documents the reasoning behind its design. The operational instructions live in `task.md`.

## Purpose

The task reviews a ticket document against its matched profile. The goal is a self-contained ticket a fresh-session agent can act on. Design-profile tickets dispatch to `tasks:design/review`. Capture may wrap as not ready to implement rather than a findings walk.

## Workflow Context

The task is designed to be run repeatedly against the same ticket document — typically five to ten times. Each run is a fresh pair of eyes looking for what earlier passes missed. Over successive runs, the review is expected to exhaust the set of real outliers that would force a fresh session to rework or guess.

Re-runs are a coverage strategy, not a drift problem. New issues on run seven are fine if they are real.

## The Core Tension

A review that finds too few issues lets real problems reach a fresh session that cannot do that profile's work. A review that finds too many low-value issues creates noise, triggers unnecessary rework, and erodes trust in the review itself. Getting the balance right is the hardest part of this design.

Over a multi-run cycle the asymmetry matters: a missed real issue surfaces on the next run, but noise compounds across runs. The task therefore errs on the side of suppressing low-value findings.

## Principles

### Trust the implementer

Routine implementation judgement — naming, defensive code, local refactors, style — stays with the implementer when the work is implement, or a bug whose work is a fix. The review targets issues that would force a fresh session to rework or guess. Missing Requirements is not a gap on capture, bug, investigate, decide, or design. Empty Decision, Recommendation, Expected, Actual, or Repro is the work on those profiles, not a defect.

### Goal bar

An issue is worth flagging only if leaving it unresolved would force a fresh session to rework or guess. Everything below that bar is noise.

### Articulation test

If the reviewer cannot articulate what goes wrong when an item is left unresolved, the item does not belong in the list. Vague concerns are invention.

### Regret filter

Before finalising a finding, ask: would I regret not flagging this after that profile's work lands? If not, drop it.

### Permission to find nothing

Finding no new issues is a valid outcome. A late-run review that produces no findings is evidence the document is complete. Inventing findings to justify the run destroys the signal the process is built to produce.

### Conditional research

Research external facts only when the ticket's approach turns on them — a specific dependency version, API behaviour, or platform capability. Generic dependency scans produce phantom issues that multiply over reruns.

### Conditional suggested resolution

Decisions carry their options because alternatives are the point. Other categories carry a suggested resolution only when it clarifies the issue. Inventing a fix to make a finding feel substantive is a noise vector.

### Integrated resolutions

Findings are numbered within a run for reference during the walk; the numbers are not preserved in the ticket document. A resolution is integrated directly into the ticket content as polished prose rather than logged — no Issues Discovered section lingers. The review is presented inline. A report file is written only when asked, or when the run is instructed to proceed without intervention — not into the ticket document itself.

## The Size Check

A ticket too broad for a single implementation pass will fail regardless of how cleanly each individual issue is found. The review detects breadth — multiple independent outcomes, partitionable plans, nested sub-features with their own scope — and short-circuits to a Split outcome before diving into finer findings. Details found against a ticket that is about to be split go stale.

Size is a property of the whole document, not any one section, so it cannot be surfaced by the standard issue list. It gets its own check and its own outcome.

## Outcomes

The review concludes with exactly one wrap-up:

- Ready to implement — implement, or bug when the work is a fix, and no blocking issues remain
- Ready to diagnose — bug whose work is not yet a fix, and a fresh session can diagnose. Expected, Actual, or Repro may be empty
- Ready to decide — decide, and a fresh session can make the choice. Decision may be empty
- Ready to investigate — investigate, and a fresh session can research. Recommendation may be empty
- Not ready to implement — capture, or a stub that was not expanded
- Issues to resolve — blocking issues remain
- Split the ticket — too broad for a single implementation pass

## Why This Design

Earlier versions of the task produced too many low-value findings. Each principle above is weak on its own. Layered together — goal bar, articulation test, regret filter, explicit permission to find nothing, conditional research, conditional resolutions, size short-circuit — they filter noise at every step while allowing genuine outliers to surface across repeated runs. The balance is maintained by the combination, not any single rule.
