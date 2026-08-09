# Design Writing Guide

This guide is for AI agents writing design documents.

A design document specifies something new before it is built — a complete system designed from scratch, or a substantial feature added to an existing one. It captures the whole shape of that thing: what it does, how it is structured, how its parts fit together, and the reasoning that led to the design.

Reach for a design document when there is genuine design work to settle first — the shape is not yet obvious, and more than one approach is worth weighing. When the approach is already clear and only the build remains, skip the design and write a ticket document directly. The trigger is design uncertainty, not size.

The document is written after an interactive design session — ideas thrown around, concepts settled — and captures the result. It is then read cold: by a reviewer in a fresh session, and by the agent that decomposes it into the ticket documents that build it. Everything needed to understand and judge the design must be in the document itself.

A design document describes a solution. A ticket document schedules the work that builds part of it. Keep them separate. The design document owns the solution's shape and the reasoning behind it. It hands Goal, Current State, Constraints, and References forward to one or more ticket documents, which own the Requirements, Implementation Plan, and Acceptance Criteria this document deliberately omits.

## Principles

The value of a design document is the reasoning it makes explicit and the solution it commits to, not the format. Hold to these.

- Design the whole solution, then commit to it. Settle on one coherent design rather than presenting a menu. The directions you weighed belong in Alternatives Considered with the reason each lost; the body describes the design you chose.
- Weigh real alternatives before committing. Consider at least two genuine directions for the shape, not one plus strawmen built to lose. Designing something new — a system or a feature — you have real design freedom, and the most to lose from anchoring on the first idea.
- Make tradeoffs explicit. Every design gives something up. State what the chosen shape costs, not only what it wins. A design with no stated downside is one not yet understood.
- Surface load-bearing assumptions. Name the facts the design rests on — a dependency's behaviour, a scale target, a platform capability. If one is wrong the solution fails, so state it where review can test it.
- Argue with evidence, not confidence. Prefer a measured number, a citation, or a small worked example over assertion. Confident prose hides weak designs, and review exists to find them.
- Design the solution, not the code. Specify the architecture, the components and their responsibilities, and the interfaces and data that define the system. Leave function signatures, naming, file placement, and defensive detail to the ticket documents and their implementers.
- Right-size to the design. A large system earns every section. A focused feature needs a Summary, a Proposed Design, the alternatives weighed, and the seams it touches, and little else. Omit sections that do not apply.
- Be explicit and complete. The document is read cold. Do not reference the session that produced it. "The approach we settled on" means nothing to a fresh-session reader.
- Resolve what you can; surface what you cannot. Fold settled questions into the body. Genuinely open decisions that need an owner go in Open Questions, not scattered through the prose.
- Record references. Prior art, similar systems, benchmarks, and documentation that shaped the design belong in the document so the reviewer can check the sources.

## Sections

Include sections in the order below. Omit any that do not apply.

### 1. Summary

The solution and its shape in one paragraph, readable on its own. A reader should finish it knowing what the system does and how it is structured, before any detail.

### 2. Problem

What the solution is for, why it is needed, and why now. The forces that motivate building it. Do not describe the solution here.

### 3. Goals and Non-Goals

What the solution must achieve, stated observably where possible. What it explicitly will not do. Non-goals bound the design and pre-empt scope creep.

### 4. Current State

What already exists around the design. For a feature, the system it extends and the seams — interfaces, data, call sites — it plugs into. For a system built from scratch, the surrounding environment it must fit and the constraints reality imposes. Enough that the reader can judge the design against what is already there. Omit only if the design stands entirely alone.

### 5. Proposed Design

The solution, in depth. This is the core of the document. Cover the architecture, the key components and their responsibilities, the interfaces and data that define the system, and the control or data flow that makes it work. Snippets and text diagrams are acceptable to clarify a non-obvious point; full source code is not.

### 6. Alternatives Considered

The other directions weighed for the solution's shape. For each, one or two sentences on how it worked and the concrete reason it lost. Include at least one real alternative. This section is the evidence that the design was chosen rather than defaulted into.

### 7. Tradeoffs

What the chosen design gives up relative to the alternatives, and why that cost is acceptable. Name the downsides plainly. Distinguish costs paid once from costs paid continuously.

### 8. Cross-Cutting Concerns

How the design handles the properties it touches: security, privacy, performance, reliability, observability, cost. Include only the concerns the solution actually affects, and say how each is addressed.

### 9. Risks and Mitigations

What could go wrong, the blast radius if it does, and how each risk is contained. Distinguish risks you mitigate from risks you knowingly accept.

### 10. Rollout

How the design reaches production: build order and phasing, and what a first usable increment looks like. For a feature landing in a live system, add migration of existing data or callers, backward compatibility, and how the feature is switched on. Omit if it ships in one piece with nothing to stage.

### 11. Open Questions

Decisions that genuinely need an owner's input before or during implementation. Not a backlog — only questions that block or would reshape the design.

### 12. References

Prior art, similar systems, benchmarks, and documentation consulted. Give the location and a one-line description for each. Omit if no external sources informed the design.

## Handoff to Implementation

A design document is not implemented directly. Once the solution is settled, decompose it into one or more ticket documents using the ticket writing guide at `contexts:ticket/writing`. Those documents carry the Requirements, Implementation Plan, and Acceptance Criteria this document leaves out. Carry Goal, Current State, Constraints, and References forward so the ticket documents do not re-derive them.

## File Placement

Save the design document under the name settled during the session. If no name was chosen, ask the user what to call the file before saving. Place it at the repository root unless the user wants it elsewhere.

## Formatting

- Markdown headings with consistent hierarchy, `###` maximum
- Short paragraphs and bullet points
- Numbered lists for ordered steps
- Direct language — "do X" or "do not do X", not "consider doing X"
- No filler or hedging — every sentence actionable or informative
- Token-efficient — no bold, italic, emojis, or horizontal rules
- Single blank lines between sections
- No nested lists beyond 3 levels
