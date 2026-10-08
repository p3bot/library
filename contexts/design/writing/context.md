# Design Writing Guide

This guide is for AI agents running a design session. The session produces a design document. It is read cold: by a reviewer in a fresh session, and by the agent that decomposes it. Everything needed to understand and judge the design must be in that document.

Reach for a design session when there is genuine design work to settle first — the shape is not yet obvious, and more than one approach is worth weighing. When the approach is already clear and only the build remains, skip the design and write an implement-profile ticket. The trigger is design uncertainty, not size.

Do not implement product code from the design document.

## Principles

The value of a design is the reasoning it makes explicit and the solution it commits to, not the format. Hold to these.

- Design the whole solution, then commit to it. Settle on one coherent design rather than presenting a menu. The directions you weighed belong in Alternatives Considered with the reason each lost; the body describes the design you chose
- Weigh real alternatives before committing. Consider at least two genuine directions for the shape, not one plus strawmen built to lose. Designing something new — a system or a feature — you have real design freedom, and the most to lose from anchoring on the first idea
- Make tradeoffs explicit. Every design gives something up. State what the chosen shape costs, not only what it wins. A design with no stated downside is one not yet understood
- Surface load-bearing assumptions. Name the facts the design rests on — a dependency's behaviour, a scale target, a platform capability. If one is wrong the solution fails, so state it where review can test it
- Argue with evidence, not confidence. Prefer a measured number, a citation, or a small worked example over assertion. Confident prose hides weak designs, and review exists to find them
- Design the solution, not the code. Specify the architecture, the components and their responsibilities, and the interfaces and data that define the system. Leave function signatures, naming, file placement, and defensive detail to later implement tickets
- Right-size to the design. A large system earns every section. A focused feature needs a Summary, a Proposed Design, the alternatives weighed, and the seams it touches, and little else
- Be explicit and complete. The document is read cold. Do not reference the session that produced it
- Resolve what you can; surface what you cannot. Fold settled questions into the body. Genuinely open decisions that need an owner go in Open Questions
- Record references. Prior art, similar systems, benchmarks, and documentation that shaped the design belong in the document so the reviewer can check the sources
- Token-efficient markdown: no bold, italic, emojis, or horizontal rules; heading depth `###` maximum; single blank lines between sections; no nested lists beyond 3 levels
- Direct language — "do X" or "do not do X", not "consider doing X"
- Headings that identify the document stay even when their body is empty. Omit-if-empty applies to the rest

## Document

This guide owns the document shape.

Sections, in this order. Goals and Non-Goals, Proposed Design, and Alternatives Considered stay even when empty. Other sections omit if empty.

### Summary

The solution and its shape in one paragraph, readable on its own. A reader should finish it knowing what the system does and how it is structured, before any detail.

### Problem

What the solution is for, why it is needed, and why now. The forces that motivate building it. Do not describe the solution here.

### Goals and Non-Goals

What the solution must achieve, stated observably where possible. What it explicitly will not do. Non-goals bound the design and pre-empt scope creep.

### Current State

What already exists around the design. For a feature, the system it extends and the seams — interfaces, data, call sites — it plugs into. For a system built from scratch, the surrounding environment it must fit and the constraints reality imposes. Enough that the reader can judge the design against what is already there.

### Proposed Design

The solution, in depth. Cover the architecture, the key components and their responsibilities, the interfaces and data that define the system, and the control or data flow that makes it work. Snippets and text diagrams are acceptable to clarify a non-obvious point; full source code is not.

### Alternatives Considered

The other directions weighed for the solution's shape. For each, one or two sentences on how it worked and the concrete reason it lost. Include at least one real alternative. This section is the evidence that the design was chosen rather than defaulted into.

### Tradeoffs

What the chosen design gives up relative to the alternatives, and why that cost is acceptable. Name the downsides plainly. Distinguish costs paid once from costs paid continuously.

### Cross-Cutting Concerns

How the design handles the properties it touches: security, privacy, performance, reliability, observability, cost. Include only the concerns the solution actually affects, and say how each is addressed.

### Risks and Mitigations

What could go wrong, the blast radius if it does, and how each risk is contained. Distinguish risks you mitigate from risks you knowingly accept.

### Rollout

How the design reaches production: build order and phasing, and what a first usable increment looks like. For a feature landing in a live system, add migration of existing data or callers, backward compatibility, and how the feature is switched on.

### Open Questions

Decisions that genuinely need an owner's input before or during implementation. Not a backlog — only questions that block or would reshape the design.

### References

Prior art, similar systems, benchmarks, and documentation consulted. Give the location and a one-line description for each.

### Follow-up

The later tickets this design should produce after the owner accepts. Decompose creates them. Do not grow an Implementation Plan in this body.

Done when the shape is closed enough to decompose or to stop. Do not implement product code from this document.

## Placement

Two cases:

- Design document: the path `tk design create` printed. The unmanaged case does not apply. Fill under the existing H1. Do not paste a second heading. Do not hand-edit the fence. Set status with `tk design mark`. Set `produces` with `tk design meta add` and `tk design meta remove`
- Unmanaged: use the path they gave. If none, ask, offering to continue any existing `NN-<slug>.md` sequence at the repository root, else a short kebab-case name from what they named, or from Problem, Summary, or Goal. Do not gather a Goal just to name the file. Place it at the repository root unless they specified a different location

## Status

A new design is a design document. `tk design create` scaffolds `design/<id>-<slug>.md` with status `draft`. The file stays in `design/`. Statuses are `draft`, `accepted`, `decomposed`, and `superseded`, set with `tk design mark`. Any of the four may be marked from any of the four. A ticket status is a usage error.

Writing and review leave it `draft`. The owner accepts with `tk design mark accepted`. Decompose writes the follow-up tickets, then `tk design meta add <design-id> produces <full-ticket-id>` for each ticket that now exists, then `tk design mark decomposed`. `produces` is one way. There is no back-link on the ticket. Do not put a design id on `depends` or `related`.

Stopping after a breakdown proposal does not mark `decomposed`. Leave `accepted` if the owner already accepted the design, and `draft` if they have not. A replacement design, including a split, marks the old file `superseded`.

`tk design create` and edits under the H1 do not self-commit. On a tk-driven scope, `tk sync`. `tk design mark` and `tk design meta add|remove` self-commit and do not push. `tk get` does not open a design. `tk design get` does not open a ticket. Two design files that share a short id make `get`, `mark`, and `meta` refuse and print no path. `design_id:` and no path: stop. Do not `tk mark`. A path with `parse_error:` for that id: stop. The fence is quarantined. Do not mark, do not edit the fence, and do not run the design session or the review. `tasks:tk/board/groom` is the exception: it may propose the in-place repair it describes, keeping the path, the id, and `created`, and restoring status and `produces` only when the broken text already shows them. A fence with conflict markers stays a stop for the owner. `parse_error: N unparseable` does not quarantine the file just fetched. A path with no per-id `parse_error:` is the design document.

A legacy design-profile ticket is a board ticket that already has these headings. It stays a ticket until it is migrated. Decompose of that ticket still ends with `tk mark done`. Do not create another one. New design work is `tk design create`.

Review is `tasks:design/review`.

## Progress

Not part of the document shape. Add it when a later agent will continue the same design document.

Place after the last document section. Omit empty overlay headings.

Sections:

- Remaining
- Done this session
- Blockers
- Next action

Keep it short. Do not dump logs. On a successful close, drop or empty Remaining.

## Handoff

If this session was started against an existing design document, or against an existing design-profile ticket, fill that file. Do not `tk design create` or `tk create` another. Leave a design document `draft`. Do not run `tk design mark accepted` in this session. Do not mark it `decomposed`. Leave a legacy design-profile ticket's status unchanged. Do not `tk mark done` it from this session.

Otherwise, once the session has settled the shape, write the document in Document, place it with Placement, and leave status to Status.

If `command -v tk` succeeds and they did not ask for an unmanaged path, `tk design create` with a title from the shape and fill under the H1 it printed. Leave status `draft`. Otherwise use Placement's unmanaged case.

Leave the design `draft`. The owner accepts with `tk design mark accepted`. Decompose runs that command when the owner accepts there, records `produces`, and marks that design `decomposed` after it writes the follow-ups. A legacy design-profile ticket is still `tk mark done` after the follow-ups. Do not implement from the design.
