# Ticket Writing Guide

This guide is for AI agents creating ticket documents.

A ticket document will be handed to a different agent in a fresh session as its sole context. The implementer will have no access to the conversation that produced the document. Everything they need to understand and execute the ticket must be in the document itself.

The implementer aims at whatever the document points to. Point them at the principled long-term solution, not the smallest-diff resolution.

## Principles

- Bias toward the principled long-term solution that reduces maintenance and improves quality. Frame requirements, constraints, and acceptance criteria so the implementer aims at that outcome. Do not let the document read as a request for the smallest-diff resolution.
- Define the what and why. The implementer owns the how. The ticket sets direction. It does not dictate implementation.
- Right-size the document to the work. Not every ticket needs every section. Omit sections that do not apply. A one-file refactor does not need a References section if no external sources were consulted. Match the document to the size and shape of the task.
- Trust the implementer's judgement. If a competent implementer would reach the same decision by reading the surrounding code, do not specify it. Exact function signatures, doc-comment wording, file placement, test names, defensive checks for unreachable cases — these belong to implementation. Specify outcomes and constraints, not keystrokes.
- Code snippets are fine. Full source code is not. A snippet illustrates intent or clarifies a non-obvious integration point. Writing full implementation boxes the implementer into a fixed solution.
- Be explicit and complete. Do not reference conversation context. Phrases like "as discussed" or "the approach we agreed on" are meaningless to a fresh-session agent.
- Resolve issues into the body. When concerns surface as the document develops, fold the resolution into the relevant section rather than parking unresolved items in the document. A ticket document is a plan ready to implement, not a backlog of open questions.
- Record all references. If research was conducted, repositories cloned, or documentation consulted, list them. Do not leave the implementer without the sources that shaped the plan.

## Sections

Include sections in the order below. Omit any that do not apply.

### 1. Goal

What is being built or changed and why. One to three sentences. Focus on outcome and motivation, not tasks.

### 2. Scope

What is in scope. What is explicitly out of scope. Boundaries prevent drift.

### 3. Current State

The relevant existing state — files, infrastructure, dependencies, configuration. Enough context that the implementer can read the requirements with understanding.

### 4. References

Sources that informed the ticket: cloned repositories, documentation, API references, external links, research findings. For each, give the location and a one-line description.

Omit this section if no external sources were consulted.

### 5. Requirements

The deliverables. Each requirement is clear, verifiable, and states what the ticket must produce. Use numbered items.

### 6. Constraints

Hard rules the implementer must follow: language and version requirements, target platforms, required tooling, organisational standards, compatibility requirements. If the implementer must not break this rule under any circumstances, it belongs here.

### 7. Implementation Plan

Ordered steps to complete the ticket. Include step dependencies where they exist.

Keep steps at a level that gives direction without prescribing code. Snippets are acceptable to clarify a non-obvious integration. Specify outcomes and constraints, not keystrokes.

### 8. Implementation Guidance

Soft guidance specific to this ticket — preferences or approaches that would not be obvious from reading the code. Omit this section if there is nothing to add.

Do not include generic implementation standards. Guidance that applies to every ticket in a repo belongs in the repo's agent-instruction file (e.g. AGENTS.md), not repeated in each ticket document.

### 9. Acceptance Criteria

Observable outcomes that tell the implementer the ticket is complete. Verifiable without subjective judgement. Ticket-specific only — do not list universals like "build passes" or "tests pass".

Acceptance criteria verify completion, not quality. Quality is shaped by how the document frames the work.

## File Placement

Place the ticket document at the repository root unless the user specifies a different location. Use the filename the user provides. If none is given, continue the repo's existing `NN-<slug>.md` numbering when that convention is already in use, otherwise use a short kebab-case name derived from the goal.

## Formatting

- Markdown headings with consistent hierarchy
- Short paragraphs and bullet points
- Numbered lists for ordered steps
- Direct language — "do X" or "do not do X", not "consider doing X"
- No filler or hedging — every sentence actionable or informative
- Token-efficient — no bold, italic, emojis, or horizontal rules
- Single blank lines between sections
- No nested lists beyond 3 levels
