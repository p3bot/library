# Duplication Review

Identify repeated code patterns that may benefit from consolidation. This review covers functional duplication, structural pattern redundancy, and boilerplate. It does not cover code style consistency, naming conventions, or architectural decomposition decisions.

## Prerequisites

- A repository with source code to review
- Access to read all files in the repository

## Workflow

1. Read top-level documentation (README, AGENTS.md, configuration files) to understand the project's structure and conventions
2. Identify the main packages and modules to understand the codebase organisation
3. Read source files, looking for repeated logic, similar function signatures, and structural patterns that appear across multiple locations
4. Compare related modules and packages for overlapping functionality
5. Evaluate the scope points below against what you have observed
6. Produce a structured report of findings and present it inline. Save only if the user asked, or if they instructed this run to proceed without intervention. Use the path they gave. If they asked to save but named no path, ask. If they instructed this run to proceed without intervention and named no path, write to `.start/reviews/YYYY-MM-DD-duplication-NN.md` (`NN` starts at `01`, incrementing against existing files matching the date and type)

## Reviewer Guidance

- Assess duplication in context. Three similar lines of code used in two places is not the same problem as a 20-line block copied across five files. Focus on duplication that creates a real maintenance burden, not on superficial similarity.
- Duplication findings are almost always low or medium severity. Reserve medium for cases where duplicated logic has already diverged (one copy was updated, another was not), creating inconsistency. Critical and high are not expected for this review type; write "None" for those sections.
- Distinguish between duplication that should be consolidated and duplication that exists for good reason. Sometimes two similar-looking blocks serve different concerns and coupling them would be worse than the repetition. Flag only duplication where consolidation would genuinely improve maintainability.
- It is acceptable to find no issues. A codebase with minimal duplication is a valid outcome. Do not manufacture findings or suggest abstractions that would add complexity without clear benefit.
- Write "None" for any severity level where no findings exist. Every section must be present in the report.

## Scope

- Functional Duplication: Identifying similar logic performed in multiple places that should be centralized.
- Pattern Redundancy: Recognizing repeated structural patterns that suggest a missing abstraction.
- Boilerplate Reduction: Assessing if the change introduces repetitive code that could be simplified through better design.

## Report Format

```
## Duplication Review Summary

Scope: {what was reviewed, number of files}
Findings: {count per severity, e.g. 0 critical, 0 high, 1 medium, 3 low}

## Critical Findings

{or "None"}

## High Findings

{or "None"}

## Medium Findings

{findings where duplicated logic has diverged or creates maintenance risk, or "None"}

## Low / Info

{minor observations and suggestions, or "None"}

## Assessment

{overall assessment of duplication in the codebase, noting both strengths and weaknesses}
```
