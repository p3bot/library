# Ticket Writing Guide

This guide is for AI agents creating ticket documents. A ticket is handed to a different agent in a fresh session as its sole context. Everything they need must be in the document.

Profile is inferred from headings under the H1. Do not declare profile in frontmatter.

## Shared rules

- Bias toward the principled long-term solution that reduces maintenance and improves quality. Do not aim the reader at the smallest-diff resolution
- Right-size. Omit sections that do not apply, except headings that identify the profile
- Be explicit and complete. Do not reference conversation context. Phrases like "as discussed" or "you can see below" are meaningless to a fresh-session agent
- Record references when sources were consulted
- Token-efficient markdown: no bold, italic, emojis, or horizontal rules; heading depth `###` maximum; single blank lines between sections; no nested lists beyond 3 levels
- Direct language — "do X" or "do not do X", not "consider doing X"
- Profile is inferred from the headings present under the H1, matched against this guide
- Headings that identify a profile stay even when their body is empty. Omit-if-empty applies to the rest of that profile's list
- Tags are optional board lenses. Tag `design` when the ticket is a design. Do not require a tag for the other profiles
- Resolve settled issues into the body. Open questions are allowed when they are the work (investigate, decide) or when they still need an owner (design)

Pick one profile. Do not mix two full spines in one ticket. A capture may later be rewritten into another profile. A design decomposes into later tickets rather than growing an Implementation Plan in the same body.

Decision and Recommendation identify profiles. Fold finding content into the chosen profile. Do not paste finding-template headings (Decision, Options, Recommendation, Simple Explanation, Details) as ticket headings unless that profile owns them.

## File placement

Two cases:

- tk: the path `tk create` printed. Unmanaged File Placement does not apply. Fill under the existing H1. Do not paste a second heading. Do not hand-edit the fence
- Unmanaged: use the path they gave. If none, ask, offering to continue any existing `NN-<slug>.md` sequence at the repository root, else a short kebab-case name from what they named, or from Problem, Summary, or Goal. Do not gather a Goal just to name the file. Place it at the repository root unless they specified a different location

## How to choose a profile

- capture: a human or agent filed an idea with minimal content. Not ready to execute as a plan
- bug: something is wrong. Repro and expected versus actual matter more than a feature plan
- investigate: the deliverable is knowledge or a recommendation. No product change in this ticket
- decide: the deliverable is a recorded choice. A later ticket may build
- design: the deliverable is the shape of a solution. Tag `design`. Do not implement from this ticket
- implement: the deliverable is a change in the target system

If several readings fit, prefer the one whose done-condition matches what the owner wants from this ticket.

A Decision heading means decide, not investigate, including when Decision is still unfilled.

Match from headings under the H1, case-insensitive, ignoring numbering (`### 1. Goal` equals Goal). Tags are not the matcher. First hit in this order wins:

1. Decision → decide
2. Proposed Design, Goals and Non-Goals, or Alternatives Considered → design
3. Expected, Actual, Repro, Already done, or Blocked on → bug
4. Research questions, How this ticket is done, or Recommendation (and no Decision) → investigate
5. Requirements, Implementation Plan, or Acceptance Criteria → implement
6. Problem or Done when → capture
7. else stub

Done when is the capture/bug completion heading, including tickets written before this change. Overlay headings (Remaining, Done this session, Blockers, Next action) never identify a profile.

Do not add alias tables for historical headings. New writes and expand-on-request use the names in this guide.

## capture

Sections, in this order. Problem and Done when stay even when empty. Notes omit if empty.

- Problem
- Done when
- Notes

Valid in `draft` and `backlog`. Not a stub. Expand promotes it when someone is ready to plan.

`tk/id/build` on capture: if the ticket plus the codebase is enough to choose a later profile and finish that work without an owner decision, rewrite in place to that profile then continue; if an owner decision remains, stop and say so.

Done when a later session can tell what "done" meant. Capture is not ready to execute as a plan.

## bug

Sections, in this order. Expected, Actual, and Repro stay even when empty. Other sections omit if empty.

- Problem
- Expected
- Actual
- Repro
- Environment
- Already done
- Blocked on
- Done when
- Notes

Done when the failure is fixed or the root-cause class is recorded and remaining work is a follow-up ticket. Do not force implement sections onto an incident.

## investigate

Sections, in this order. Research questions, How this ticket is done, and Recommendation stay even when empty. Other sections omit if empty.

- Goal (the question)
- Scope
- Current State
- References
- Research questions
- Options
- Constraints
- How this ticket is done
- Recommendation (filled when the work finishes)

No product change in this ticket. Done when a later session can act on the recommendation without re-deriving it.

## decide

Same spine as investigate (those sections omit if empty), then these headings always, even when unfilled:

- Decision
- Rationale
- Rejected alternatives
- Follow-up

A ticket with a Decision heading is decide from create time. Done when the choice is in the body. Follow-up names the implement or design tickets that should exist after, created only when the owner asks.

## design

Tag `design`. This profile owns the document shape.

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

Done when the shape is closed enough to decompose or to stop. Do not implement product code in this ticket. Decompose into later tickets after the owner accepts the design. Build, continue, and begin do not mark this profile done. Decompose marks it done after it writes the follow-ups.

Review of a design-profile ticket is `tasks:design/review`.

## implement

The implementer owns the how. The ticket sets direction. It does not dictate implementation. Trust the implementer's judgement on structure, naming, file placement, test names, and defensive checks. Code snippets are fine. Full source is not.

A ticket of this profile is a plan ready to implement, not a backlog of open questions.

Sections, in this order. Requirements, Implementation Plan, and Acceptance Criteria stay even when empty. Other sections omit if empty.

### Goal

What is being built or changed and why. One to three sentences. Focus on outcome and motivation, not tasks.

### Scope

What is in scope. What is explicitly out of scope. Boundaries prevent drift.

### Current State

The relevant existing state — files, infrastructure, dependencies, configuration. Enough context that the implementer can read the requirements with understanding.

### References

Sources that informed the ticket: cloned repositories, documentation, API references, external links, research findings. For each, give the location and a one-line description.

Omit this section if no external sources were consulted.

### Requirements

The deliverables. Each requirement is clear, verifiable, and states what the ticket must produce. Use numbered items.

### Constraints

Hard rules the implementer must follow: language and version requirements, target platforms, required tooling, organisational standards, compatibility requirements. If the implementer must not break this rule under any circumstances, it belongs here.

### Implementation Plan

Ordered steps to complete the ticket. Include step dependencies where they exist.

Keep steps at a level that gives direction without prescribing code. Snippets are acceptable to clarify a non-obvious integration. Specify outcomes and constraints, not keystrokes.

### Implementation Guidance

Soft guidance specific to this ticket — preferences or approaches that would not be obvious from reading the code. Omit this section if there is nothing to add.

Do not include generic implementation standards. Guidance that applies to every ticket in a repo belongs in the repo's agent-instruction file (e.g. AGENTS.md), not repeated in each ticket document.

### Acceptance Criteria

Observable outcomes that tell the implementer the ticket is complete. Verifiable without subjective judgement. Ticket-specific only — do not list universals like "build passes" or "tests pass".

Acceptance criteria verify completion, not quality. Quality is shaped by how the document frames the work.

Optional Progress when the work will span sessions or already has.

## Progress

Not a profile. Add under implement, or under a long design or investigate, when a later agent will continue the same ticket.

Place after the last profile section. Omit empty overlay headings.

Sections:

- Remaining
- Done this session
- Blockers
- Next action

Keep it short. Do not dump logs. Build and continue update this in the body before they stop. On a successful close, drop or empty Remaining. The implementation Report may still go to the owner in the session. The ticket is what the next agent reads.

## Stub test

A ticket matches this guide when a fresh-session agent can tell the profile from the headings and could do that profile's work from the document alone.

Treat it as a stub only if:

- No profile headings under the H1 (empty body, or only an H1)
- Primary content is a log, paste, or error dump
- Relies on conversation context ("as discussed", "you can see below")

A capture with Problem and Done when matches. A thin implement that has Goal, Requirements, and Acceptance Criteria matches. A decide ticket with an empty Decision heading matches. Quality of the plan is review, not expand.

Missing Requirements is not a stub if the headings match capture, bug, investigate, decide, or design.
