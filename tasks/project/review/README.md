# Project Review Task

This directory holds the project review task. This README documents the reasoning behind its design. The operational instructions live in `task.md`.

## Purpose

The task reviews a project document before implementation begins. The goal is a self-contained project document that an implementing agent, working in a fresh session with no other context, can execute successfully.

## Workflow Context

The task is designed to be run repeatedly against the same project document — typically five to ten times. Each run is a fresh pair of eyes looking for what earlier passes missed. Over successive runs, the review is expected to exhaust the set of real outliers that would cause implementation to fail.

Re-runs are a coverage strategy, not a drift problem. New issues on run seven are fine if they are real.

## The Core Tension

A review that finds too few issues lets real problems slip through to implementation. A review that finds too many low-value issues creates noise, triggers unnecessary rework, and erodes trust in the review itself. Getting the balance right is the hardest part of this design.

Over a multi-run cycle the asymmetry matters: a missed real issue surfaces on the next run, but noise compounds across runs. The task therefore errs on the side of suppressing low-value findings.

## Principles

### Trust the implementer

Routine implementation judgement — naming, defensive code, local refactors, style — stays with the implementer. The review targets design flaws, missing requirements, incorrect assumptions, and owner decisions.

### Goal bar

An issue is worth flagging only if leaving it unresolved would force significant rework, cause incorrect behaviour, or leave a critical requirement unmet. Everything below that bar is noise.

### Articulation test

If the reviewer cannot articulate what goes wrong when an item is left unresolved, the item does not belong in the list. Vague concerns are invention.

### Regret filter

Before finalising a finding, ask: would I regret not flagging this after implementation lands? If not, drop it.

### Permission to find nothing

Finding no new issues is a valid outcome. A late-run review that produces no findings is evidence the document is complete. Inventing findings to justify the run destroys the signal the process is built to produce.

### Conditional research

Research external facts only when the project's approach turns on them — a specific dependency version, API behaviour, or platform capability. Generic dependency scans produce phantom issues that multiply over reruns.

### Conditional suggested resolution

Decisions carry their options because alternatives are the point. Other categories carry a suggested resolution only when it clarifies the issue. Inventing a fix to make a finding feel substantive is a noise vector.

### Integrated resolutions

Findings are numbered within a run for reference during the walk; the numbers are not preserved in the project document. A resolution is integrated directly into the project content as polished prose rather than logged — no Issues Discovered section lingers. The review history lives in the saved reports under .start/reviews/, not in the project document itself.

## The Size Check

A project too broad for a single implementation pass will fail regardless of how cleanly each individual issue is found. The review detects breadth — multiple independent outcomes, partitionable plans, nested sub-features with their own scope — and short-circuits to a Split outcome before diving into finer findings. Details found against a project that is about to be split go stale.

Size is a property of the whole document, not any one section, so it cannot be surfaced by the standard issue list. It gets its own check and its own outcome.

## Outcomes

The review concludes with exactly one of three outcomes:

- Ready to implement — no blocking issues remain
- Issues to resolve — blocking issues listed for the owner to resolve
- Split the project — too broad for a single implementation pass

## Why This Design

Earlier versions of the task produced too many low-value findings. Each principle above is weak on its own. Layered together — goal bar, articulation test, regret filter, explicit permission to find nothing, conditional research, conditional resolutions, size short-circuit — they filter noise at every step while allowing genuine outliers to surface across repeated runs. The balance is maintained by the combination, not any single rule.
