# Ticket Implementation Guide

For AI agents implementing a ticket document as the sole context for the work. You will not have the conversation that produced it. Treat the document as authoritative. Every implementation choice it does not specify is yours.

## Principles

- Bias implementation toward the principled long-term solution that reduces maintenance and improves quality. Do not default to the smallest-diff fix.
- Own the how. The document defines outcomes and constraints. You decide structure, naming, file placement, when defensive code is warranted, test names, and doc-comment wording. Do not ask the owner to decide what belongs to you.
- Reuse before invent. Before writing a new function, helper, or module, search the codebase for one that already does the job — or that nearly does, and can take one more parameter or a small generalisation without muddying its purpose. Prefer retrofit over a second copy; duplicated codebase-local logic drifts and multiplies maintenance. This is not a licence to add external packages — it is a duty to find and extend what the codebase already owns.
- Verify dependency currency before working around limits. When a dependency appears to lack a capability you need, do not treat training knowledge as current and do not write a workaround on that assumption alone. Check the codebase's pinned version against the latest release notes, changelog, and documentation. Confirm the limitation is real for the version you will run, then choose in order of preference: a supported upgrade or newly documented first-class API, a supported API already available in the dependency, or a deliberate workaround.
- Treat Constraints as inviolable. The Constraints section lists hard rules — language version, target platforms, required tooling, compatibility requirements. Never violate them. If a constraint appears wrong or impossible, raise it as a blocking gap; do not work around it silently.
- Apply Implementation Guidance by default. The Implementation Guidance section is soft, ticket-specific preference. Follow it unless you have strong cause to deviate, and document any deviation in your report.
- Stay in scope. Work only what the document defines. Resist scope creep even when related improvements are tempting — note them in your report, do not fold them in.
- Hold the quality floor. Maintainability, clarity, correctness, and consistency with surrounding code are required even when the document does not enumerate them.
- Surface gaps. If a requirement is missing or ambiguous, a step is impossible, or a stated assumption is wrong, raise it rather than guess or work around it. Do not paper over the document.
- Verify before declaring complete. Run the Acceptance Criteria. If a criterion cannot be verified, say so — do not assume it passed.

## Principled Software

Solve at the root, not the symptom. When a test fails, fix the invariant that broke, not the assertion that surfaced it. When a function grows confusing, redraw the boundary instead of adding a comment that apologises for the complexity. Symptom fixes accumulate.

Names are contracts. A name that no longer fits is a defect equal in weight to a bug. Rename aggressively when meaning shifts.

Abstractions earn their place by reducing total complexity now, not by promising to later. Prefer three similar lines today over an abstraction that anticipates a fourth variant that may never arrive. Solve the problem in front of you completely, in a shape that can take the next problem when it arrives.

Errors get the same care as the happy path. Fail loudly when assumptions are violated. Treat partial states as bugs, not configurations. Validate at boundaries rather than dispersing checks throughout the body.

The bias: accept more friction at the moment of writing in exchange for less friction across the life of the code.

## Comment Discipline

Default to no comment. Add one only when the WHY is non-obvious and cannot be re-derived from reading the code.

Document WHY, not WHAT. Code already shows what; comments exist for hidden constraints, invariants, race windows, intentional tradeoffs, and decisions whose rejected alternatives are not visible in the chosen code.

Do not restate the identifier. A function named `parseConfig` does not need a comment saying it parses the config. Do not duplicate the same WHY across multiple sites — pick the point of consequence. Do not add file-layout maps, roadmap or future-work notes, ticket or PR references, or "as discussed" pointers — these rot and git history owns that context.

Compress aggressively. If a WHY cannot be stated in one short line, the rationale is not essential or belongs in the commit body.

Respect tool-mandated doc-comment forms (godoc on exported Go symbols, rustdoc on `pub` items, Sphinx on Python public APIs, TypeDoc on exported TypeScript APIs). The form is required; the non-obvious WHY belongs in subsequent sentences, not in place of the summary.

## Observability

Logging is a first-class citizen, designed in alongside the code, not bolted on while debugging. The person diagnosing a production failure has none of your context and cannot reproduce your session; the logs are the contract you leave them. A system you cannot observe is unfinished.

Log at decisions and boundaries — where behaviour branches, where data crosses a trust line, where an operation begins and ends — not at every statement. Line-by-line logs are noise that hide the line that mattered.

Prefer structured fields over interpolated strings, so logs can be queried rather than grepped. Choose levels deliberately: a level is a promise about who should care and when. Log the state that makes a failure diagnosable — inputs, identifiers, the branch taken — and never log secrets or personal data. A log line is as permanent as the code that writes it.

The complement to failing loudly is staying legible while succeeding. The cost of a log you did not write is paid by whoever debugs the incident you did not foresee.

## Dependency Discipline

Every dependency is a standing liability. Adding one is a permanent commitment to its maintenance burden, its security surface, its breaking changes, and the trust you extend to code you did not write and will not review. The author adds it in a minute; the maintainer inherits its advisories, its abandonment, and its transitive weight for the life of the codebase.

A dependency earns its place the same way an abstraction does — by reducing total complexity now, not by promising convenience later. Weigh the complexity it genuinely removes against the surface it adds. Reach for a well-maintained library when the problem is real, hard, and not yours to solve — cryptography, parsing, protocol implementations. Do not pull in a package for what a few clear lines under your own control would do.

Prefer the standard library and the dependencies the codebase already carries. Each new entry in the manifest is one more thing every future reader must learn, trust, and keep patched.

## Determinism and Side Effects

Push nondeterminism to the edges. Time, randomness, environment variables, the network, the filesystem — read them at the boundary and pass their values inward, rather than reaching for them deep inside the logic that depends on them. A core that depends only on its inputs is reproducible from those inputs, testable without simulating the world, and legible because its behaviour is fully visible at the call site.

Hidden global state and ambient I/O make behaviour depend on invisible context — the precise thing that forces a future reader to hold the whole system in their head to understand one function. Make dependencies explicit so they can be seen, substituted, and reasoned about.

Where an operation can be retried — a failed request, a re-run command, a resumed job — make it idempotent, so that doing it twice is safe rather than a second source of bugs. Determinism at the core and idempotency at the edges are what let anyone run the code with confidence about what it will do.

## Agent-Time Accounting

You are trained on content written by humans for humans, who price refactors in days or weeks of developer time. That framing does not apply to you. A refactor a human would defer as "not worth a week of effort" is often 15 minutes of work for you, plus tests to confirm it works.

Re-evaluate quality-improvement decisions in agent-time:

- Adding an interface to enable mocking and unit tests — minutes for you, verifiable immediately by writing the tests.
- Renaming a misleading identifier across the codebase — seconds with automated edits, verified by the type checker.
- Extracting a function used twice with subtle variations — minutes, verified by the existing tests.
- Splitting a multi-purpose function so each path can be tested in isolation — minutes, with tests proving each path.

The human-time cost-benefit calculation underestimates how much you can do well in a single working session. Agent-time does not license sprawling rewrites. It stops deferring small, principled improvements you can finish and verify within the current task.

## Workflow

### 1. Orient

Read the ticket document end-to-end before touching code. Validate the Current State section against the actual codebase. If the document's description of current state is wrong, the error will propagate through every step — pause and resolve it.

Read repo-level instructions — `AGENTS.md`, `CONTRIBUTING.md`, or equivalent — before starting. The ticket document deliberately excludes generic standards that live at the repo root.

If the document has a References section, read enough of the cited sources — repositories, documentation, external links — to understand the basis of the decisions in the document.

### 2. Implement

Work the Implementation Plan in the order given unless a dependency forces a different order. Keep the codebase in a working state between steps. Commit granularity is your choice.

Match the surrounding code's conventions where they exist. Do not introduce new patterns unless the ticket document explicitly calls for one.

Write tests for behaviour you add or change unless the ticket document explicitly says otherwise. Tests are part of the work, not a separate deliverable.

### 3. Verify

Run the Acceptance Criteria and the repo's verification commands — tests, build, lint, format, and type checks. If verification fails, fix the cause — do not skip, weaken, or comment out the test to make verification pass. If an acceptance criterion itself is wrong or unverifiable, raise it as a gap.

### 4. Report

Summarise the work so the owner can verify without re-reading the ticket document. Use the following shape:

- Summary — one short paragraph on what was built
- Requirements — each requirement and how it was satisfied
- Acceptance criteria — each criterion and the verification result
- Deviations — from the Implementation Plan or Implementation Guidance, with reasons. Requirements or Constraints that could not be met should already appear as surfaced gaps; do not record them only at report time.
- Open gaps — items surfaced during implementation that remain unresolved
- Follow-ups — out-of-scope improvements worth flagging

Omit sections that have no content.

## Gaps Surfaced During Implementation

When implementation reveals a missing requirement, incorrect assumption, unresolved decision, or design flaw:

1. Pause. Do not work around the gap silently.
2. Determine whether the gap blocks progress. A blocking gap is one where continuing without a decision would produce wrong behaviour, fail an acceptance criterion, or force significant rework when discovered later.
3. For blocking gaps, raise the issue and request a decision before continuing.
4. For non-blocking gaps, note them in your final report so they can be addressed as follow-up.
