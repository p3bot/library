# Correctness Review

Verify that code logic correctly implements the intended behaviour and handles data with precision. This review focuses on whether the code does what it is supposed to do: correct algorithms, accurate business logic, sound state transitions, and faithful data transformations. It does not cover security vulnerabilities, performance characteristics, or architectural concerns unless they directly cause incorrect behaviour.

## Prerequisites

- A repository with source code to review
- Access to read all files in the repository

## Workflow

1. Read top-level documentation (README, AGENTS.md, configuration files) to understand the system's intended behaviour and domain
2. Read source files, focusing on core logic, data transformations, and control flow
3. Trace key code paths to verify they produce correct results for expected inputs
4. Examine boundary conditions, edge cases, and conditional branches for off-by-one errors and logic flaws
5. Review state management to verify transitions are consistent and data integrity is maintained
6. Evaluate the scope points below against what you have observed
7. Produce a structured report of findings and present it inline. Save only if the user asked, or if they instructed this run to proceed without intervention. Use the path they gave. If they asked to save but named no path, ask. If they instructed this run to proceed without intervention and named no path, write to `.start/reviews/YYYY-MM-DD-correctness-NN.md` (`NN` starts at `01`, incrementing against existing files matching the date and type)

## Reviewer Guidance

- Focus on what the code does, not how it looks. A function with poor naming that produces correct results is not a correctness finding. A well-named function that silently drops data is.
- Severity should reflect the impact of incorrect behaviour. A logic error in a critical data path that corrupts output is critical. An off-by-one error in a cosmetic display element is low. Consider how likely the incorrect path is to be reached and what happens when it is.
- Reason about code paths, not just code lines. Correctness issues often emerge from the interaction between components, not from individual statements in isolation. Trace data through the system.
- It is acceptable to find no issues. Code that correctly implements its intended behaviour is a valid outcome. Do not manufacture findings or flag correct code as suspicious to justify the review.
- Write "None" for any severity level where no findings exist. Every section must be present in the report.

## Scope

- Algorithm Correctness: Verifying that the logic produces the expected output for all valid inputs and maintains logical integrity.
- Business Logic Accuracy: Ensuring the implementation faithfully represents the specified domain rules and stakeholder intentions.
- State Transitions: Assessing how the system moves between states to ensure data remains consistent and the flow is logical.
- Data Transformations: Evaluating the precision of data mapping and conversion logic to prevent loss of fidelity or unintended mutations.
- Operator and Condition Correctness: Reviewing conditional branches, logical operators, and comparison logic for accuracy and exhaustive coverage.
- Boundary and Off-by-one Errors: Identifying logic flaws that occur at the extreme limits of data ranges, loops, and collection indices.
- Order of Operations: Verifying that the sequence of execution and precedence of operations yield the logically sound result.
- Visual Fidelity (UI): Assessing whether the rendered output aligns with the design specifications across various viewports.
- Responsive Behaviour (UI): Verifying that the interface adapts correctly to different screen sizes and platform constraints.
- Interaction States: Reviewing the behavior and visual feedback of elements during user engagement.

## Report Format

```
## Correctness Review Summary

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

{overall assessment of the codebase's correctness, noting both strengths and weaknesses}
```
