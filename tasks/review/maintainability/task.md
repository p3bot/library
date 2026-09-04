# Maintainability Review

Assess whether the subject can be read, navigated, documented, and changed safely by developers other than its author.

## Prerequisites

- A repository with source code to review
- Access to read all files in the repository

## Workflow

1. Read top-level documentation (README, AGENTS.md, configuration files) to understand the project's conventions, idioms, and structure
2. Identify the main packages and modules to understand the codebase organisation
3. Read source files, focusing on public interfaces, complex functions, and core logic paths
4. Compare documented build, test, and run instructions against the actual project setup
5. Evaluate the scope points below against what you have observed
6. Produce a structured report of findings and present it inline. Save only if the user asked, or if they instructed this run to proceed without intervention. Use the path they gave. If they asked to save but named no path, ask. If they instructed this run to proceed without intervention and named no path, write to `.start/reviews/YYYY-MM-DD-maintainability-NN.md` (`NN` starts at `01`, incrementing against existing files matching the date and type)

## Reviewer Guidance

- Read from the perspective of a developer encountering this codebase for the first time. What would confuse them, slow them down, or lead them to misunderstand the intent?
- Maintainability findings are rarely critical or high. Most findings will be medium or low. Reserve higher severities for code that is genuinely misleading or where poor naming creates a real risk of introducing bugs.
- Distinguish between personal style preference and genuine clarity problems. Consistent use of an unfamiliar convention is not a maintainability issue. Inconsistent use of conventions within the same codebase is.
- It is acceptable to find no issues. A codebase that can be read and changed safely is a valid outcome. Do not manufacture findings or flag stylistic choices that are internally consistent.
- Write "None" for any severity level where no findings exist. Every section must be present in the report.

## Scope

- Naming Intent: Verifying that names reveal their purpose and the reason for their existence.
- Cognitive Complexity: Identifying logic that is too dense or requires excessive mental effort to parse.
- Expressiveness: Assessing whether language features clearly communicate intent.
- Comment Utility: Ensuring comments explain non-obvious decisions rather than restating what is already apparent.
- Code Flow: Assessing the narrative of the subject so the most important logic is prominent.
- Consistency and Conceptual Integrity: Verifying the subject follows established local idioms and reads as one coherent design rather than a patchwork of conflicting styles.
- Cognitive Profile: Assessing whether the overall solution complexity is proportionate to the problem domain being solved.
- Duplication and Redundancy: Identifying repeated logic, structural patterns, and boilerplate that should be centralised or simplified — without forcing premature generalisation.
- Codebase Atrophy: Detecting signs of large-scale rot, such as abandoned modules, ghost directories, or obsolete features.
- Dead Code and Unused Surface: Identifying unreachable branches, unused exports, commented-out blocks, and stale feature flags that have outlived their purpose.
- External Accuracy: Ensuring that the README, public API docs, and contributor guides reflect the actual state of the subject.
- Developer Onboarding: Verifying that instructions for building, testing, and running the subject remain clear.
- Decision Records: Ensuring that significant design decisions and their rationale are captured in a durable form for future contributors.
- Change Transparency: Assessing whether the changelog accurately describes the impact of the changes for users.

## Report Format

```
## Maintainability Review Summary

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

{overall assessment of the subject's maintainability, noting both strengths and weaknesses}
```
