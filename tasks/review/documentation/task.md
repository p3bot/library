# Documentation Review

Review external documentation, API documentation, and developer guides for accuracy and completeness. This review covers whether documentation reflects the current state of the code. It does not cover inline code comments, code readability, or naming conventions.

## Prerequisites

- A repository with external documentation to review (README, API docs, guides, changelogs, or decision records)
- Access to read all files in the repository

## Workflow

1. Read all external documentation (README, CONTRIBUTING, API docs, developer guides, changelogs, decision records) to understand what the project claims about itself
2. Read top-level configuration files and project structure to understand the actual state of the project
3. Compare documented build, test, and run instructions against the actual project setup to verify accuracy
4. Read source files to verify that public API documentation matches the current implementation
5. Evaluate the scope points below against what you have observed
6. Produce a structured report of findings and present it inline. Save only if the user asked, or if they instructed this run to proceed without intervention. Use the path they gave. If they asked to save but named no path, ask. If they instructed this run to proceed without intervention and named no path, write to `.start/reviews/YYYY-MM-DD-documentation-NN.md` (`NN` starts at `01`, incrementing against existing files matching the date and type)

## Reviewer Guidance

- Read from the perspective of a developer relying on the documentation to understand, build, or use the project. A command that has changed, a feature that no longer exists, or a setup step that was never updated creates real friction.
- Documentation findings are almost always low severity. Reserve medium for documentation that is actively misleading, such as instructions that would cause a developer to fail, API docs that describe a different interface than what exists, or missing setup steps that block onboarding. Critical and high are not expected for this review type; write "None" for those sections.
- Distinguish between documentation that is missing and documentation that is wrong. Wrong documentation is worse than no documentation because it wastes time and erodes trust. Missing documentation is worth noting but is a lower concern unless it covers a critical workflow.
- It is acceptable to find no issues. A project with accurate, up-to-date documentation is a valid outcome. Do not manufacture findings or request documentation for things that are self-evident from the code.
- Write "None" for any severity level where no findings exist. Every section must be present in the report.

## Scope

- External Accuracy: Ensuring that the README, public API docs, and help guides reflect the actual state of the code.
- Developer Onboarding: Verifying that instructions for building, testing, and running the code remain clear.
- Decision Records: Ensuring that significant architectural shifts are documented for future context.
- Change Transparency: Assessing if the changelog accurately describes the impact of the changes for users.

## Report Format

```
## Documentation Review Summary

Scope: {what was reviewed, number of documentation files}
Findings: {count per severity, e.g. 0 critical, 0 high, 1 medium, 2 low}

## Critical Findings

{or "None"}

## High Findings

{or "None"}

## Medium Findings

{findings where documentation is actively misleading or blocks developer workflows, or "None"}

## Low / Info

{minor observations and suggestions, or "None"}

## Assessment

{overall assessment of the project's documentation, noting both strengths and weaknesses}
```
