# Readability Review

Assess whether the code is clear and understandable to other developers. This review covers naming, cognitive complexity, expressiveness, and structural flow. It does not cover correctness of logic, architectural decisions, or code style formatting rules.

## Prerequisites

- A repository with source code to review
- Access to read all files in the repository

## Workflow

1. Read top-level documentation (README, AGENTS.md, configuration files) to understand the project's conventions, idioms, and structure
2. Identify the main packages and modules to understand the codebase organisation
3. Read source files, focusing on public interfaces, complex functions, and core logic paths
4. Evaluate the scope points below against what you have observed
5. Produce a structured report of findings and present it inline. Save only if the user asked, or if they instructed this run to proceed without intervention. Use the path they gave. If they asked to save but named no path, ask. If they instructed this run to proceed without intervention and named no path, write to `.start/reviews/YYYY-MM-DD-readability-NN.md` (`NN` starts at `01`, incrementing against existing files matching the date and type)

## Reviewer Guidance

- Read from the perspective of a developer encountering this codebase for the first time. What would confuse them, slow them down, or lead them to misunderstand the intent?
- Readability findings are rarely critical or high. Most findings will be medium or low. Reserve higher severities for code that is genuinely misleading or where poor naming creates a real risk of introducing bugs.
- Distinguish between personal style preference and genuine clarity problems. Consistent use of an unfamiliar convention is not a readability issue. Inconsistent use of conventions within the same codebase is.
- It is acceptable to find no issues. A codebase that reads clearly is a valid outcome. Do not manufacture findings or flag stylistic choices that are internally consistent.
- Write "None" for any severity level where no findings exist. Every section must be present in the report.

## Scope

- Naming Intent: Verifying that names for variables, functions, and classes reveal their purpose and the reason for their existence.
- Cognitive Complexity: Identifying logic that is too dense or requires excessive mental effort to parse.
- Expressiveness: Assessing whether the code uses language features that clearly communicate the developer's intent.
- Comment Utility: Ensuring comments are used to explain non-obvious decisions rather than restating the code.
- Pattern Consistency: Verifying that the change follows established idioms within the codebase to reduce the learning curve.
- Code Flow: Assessing the narrative of the code to ensure the most important logic is prominent.

## Report Format

```
## Readability Review Summary

Scope: {what was reviewed, number of files}
Findings: {count per severity, e.g. 0 critical, 0 high, 3 medium, 2 low}

## Critical Findings

{findings that represent seriously misleading code, or "None"}

## High Findings

{findings that should be addressed, or "None"}

## Medium Findings

{findings worth considering, or "None"}

## Low / Info

{minor observations and suggestions, or "None"}

## Assessment

{overall assessment of the codebase's readability, noting both strengths and weaknesses}
```
