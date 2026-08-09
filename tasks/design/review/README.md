# Design Review Task

This directory holds the design review task. This README documents the reasoning behind its design. The operational instructions live in `task.md`.

## Purpose

The task reviews a design document — the design for a new system or substantial feature — before it is accepted and decomposed into ticket documents. The goal is a design whose architecture is sound, whose alternatives were genuinely weighed, and whose tradeoffs, assumptions, and risks are on the page rather than in someone's head.

## Position in the Workflow

A design document specifies a new system or feature before it is built; a ticket document schedules the work that builds part of it. Design review sits at the seam between them. It is the last cheap moment to change the design — once it is decomposed into tickets and implementation begins, reversing it means unwinding work, not editing prose.

That position sets the bar. The task does not look for implementation defects; those belong to the ticket documents and to `ticket/review`. It looks for design defects: an unsound architecture, a better alternative left unexplored, a cost never admitted, an assumption that does not hold.

## The Core Tension

A review that finds too few issues lets a bad design through to implementation, where it is expensive to reverse. A review that finds too many low-value issues creates noise, triggers churn on a design that was already sound, and erodes trust in the review. The asymmetry favours catching real design flaws over suppressing noise more than `ticket/review` does, because a missed design flaw costs more downstream than a missed implementation detail — but invented findings still compound across reruns, so the noise filters stay.

## Principles

### Review the design, not the implementation

Naming, defensive code, local refactors, and style belong to the ticket documents this design produces. The review targets the approach and its justification.

### Goal bar

A finding is worth flagging only if leaving it unresolved would make the design wrong, leave a load-bearing part of it unargued, or expose an unmanaged risk. Everything below that bar is noise.

### Attack the reasoning

The strongest findings are concrete: a case the chosen approach handles worse than an alternative, an assumption stated as fact with nothing behind it, a cost the document does not admit. The rejections in Alternatives Considered get pressure-tested as hard as the choice itself — a weak rejection is how the second-best approach wins by default.

### Articulation test

If the reviewer cannot articulate what goes wrong when an item is left unresolved, the item does not belong in the list.

### Regret filter

Before finalising a finding, ask: would I regret not flagging this once implementation is underway and the design is expensive to reverse? If not, drop it.

### Permission to find nothing

Finding no new issues is a valid outcome. A late-run review that produces no findings is evidence the design is sound. Inventing findings to justify the run destroys the signal.

### Integrated resolutions

Findings are numbered within a run for reference during the walk; the numbers are not preserved in the design document. A resolution is integrated directly into the design content — an alternative promoted into the Proposed Design, a tradeoff or assumption recorded in its section — rather than logged in an Issues Discovered list. When the approach changes, the former approach moves into Alternatives Considered with the reason it lost; the comparison is part of the design. The review history lives in the saved reports under `.start/reviews/`.

## The Coherence Check

A document that covers more than one independent design will produce tangled findings no matter how cleanly each is written. The review detects that — independent systems or features bundled under one Summary, a nested sub-system with its own alternatives, a Proposed Design that partitions cleanly — and short-circuits to a Split outcome before diving into finer findings. Details found against a design about to be split go stale.

Coherence is a property of the whole document, not any one section, so it gets its own check and its own outcome.

## Outcomes

The review concludes with exactly one of three outcomes:

- Sound — no blocking issues remain; the design is ready to decompose into ticket documents
- Revise — blocking issues remain for the owner to resolve
- Split the design — the document covers more than one independent design and should be separated

## Why This Design

The task mirrors the ticket review machinery — the interactive walk, the integrated resolutions, the save format — because the shape works and the two reviews sit in the same lifecycle. What changes is the lens: the issue categories name design flaws rather than implementation flaws, the goal bar is set by the cost of reversing an accepted design, and the guidance pushes the reviewer to attack the reasoning rather than audit the code. The design that survives this review is one whose approach was chosen, not defaulted into.
