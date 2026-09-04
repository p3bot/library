# Experience Review

Assess whether the interface the end user or end agent consumes matches its design intent and serves them correctly across channels, states, input methods, and abilities.

Experience covers graphical UI, CLI and TUI, and conversational or agent-facing surfaces. User-facing error copy is Experience (Form and Validation Feedback, Content and Microcopy). Operator-facing runtime errors and recovery paths remain Operability (Error Message Actionability). Durable contributor documentation (README, public API docs, contributor guides, and onboarding) remains Maintainability (External Accuracy, Developer Onboarding).

## Prerequisites

- A repository with source code to review
- Access to read all files in the repository

## Workflow

1. Read top-level documentation (README, AGENTS.md, design specs, configuration files) to understand the intended interface and its users
2. Identify the surfaces present: graphical UI, CLI or TUI, conversational or agent-facing documents
3. Walk primary user journeys including empty, loading, partial, and error states
4. Check reach: keyboard and focus, accessibility, theming, internationalisation, help and usage paths
5. Evaluate the scope points below against what you have observed
6. Produce a structured report of findings and present it inline. Save only if the user asked, or if they instructed this run to proceed without intervention. Use the path they gave. If they asked to save but named no path, ask. If they instructed this run to proceed without intervention and named no path, write to `.start/reviews/YYYY-MM-DD-experience-NN.md` (`NN` starts at `01`, incrementing against existing files matching the date and type)

## Reviewer Guidance

- Experience reviews are contextual. A library with no user surface has little to assess. A CLI, a web UI, and an agent skill each warrant different emphasis. Note scope points that do not apply.
- Most experience findings are medium or low severity. Reserve high for issues that block a task or exclude a class of users. Critical should be rare and reserved for failures that make the interface unusable or actively harmful.
- Distinguish between missing polish and a broken journey. Flag states and paths that leave the user stuck or misinformed, not every visual preference.
- It is acceptable to find no issues. An interface that matches its intent and serves its users is a valid outcome. Do not manufacture findings to justify the review.
- Write "None" for any severity level where no findings exist. Every section must be present in the report.

## Scope

- Visual Fidelity: Assessing whether the rendered output aligns with the design specifications across various viewports.
- Responsive Behaviour: Verifying that the interface adapts correctly to different screen sizes and platform constraints.
- Interaction States: Reviewing the behaviour and visual feedback of elements during user engagement.
- Keyboard and Focus Management: Ensuring the interface is fully operable without a pointer and that focus order and visibility follow the user's task.
- Form and Validation Feedback: Assessing whether input requirements, validation timing, and error recovery guide the user toward a successful outcome.
- Theming and Visual Preferences: Ensuring the interface honours user preferences such as colour scheme, contrast, and reduced motion.
- Perceived Performance: Assessing responsiveness as experienced by the user, including layout stability and feedback during long-running operations.
- Command and Flag Clarity: Verifying that command names, flags, subcommands, and positional arguments are discoverable, consistent, and hard to misuse.
- Help and Usage Paths: Assessing whether help text, usage examples, and progressive disclosure guide the user to a successful outcome without internal knowledge.
- Agent Document Fidelity: Assessing whether agent-facing prompts, role documents, and skills are clear per token, instruction-faithful, and free of conflicting or unreachable guidance.
- Conversational Turn Quality: Assessing whether multi-turn agent or chat interfaces preserve task context, surface uncertainty, and recover from misunderstanding without trapping the user.
- State Coverage: Verifying that loading, empty, partial, and error states are deliberately designed and reachable rather than left to default behaviour.
- Accessibility: Ensuring the implementation is usable by individuals with diverse needs, including WCAG/ARIA for graphical UI and equivalent reach for CLI and conversational channels where applicable.
- Content and Microcopy: Verifying that labels, messages, and instructions are accurate, consistent in voice, and comprehensible without internal knowledge.
- Internationalisation (i18n): Verifying that the interface is prepared for localisation, handling diverse languages and cultural formats.

## Report Format

```
## Experience Review Summary

Scope: {what was reviewed, number of files}
Findings: {count per severity, e.g. 2 critical, 1 high, 3 medium, 1 low}

## Critical Findings

{findings that represent serious risk or deficiency, or "None"}

## High Findings

{findings that should be addressed, or "None"}

## Medium Findings

{findings worth considering, or "None"}

## Low / Info

{minor observations and suggestions, or "None"}

## Assessment

{overall assessment of the interface the end user or end agent consumes, noting both strengths and weaknesses}
```
