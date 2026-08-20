# Dependency Review

Review the use of third-party packages and libraries across the codebase. This review focuses on whether external dependencies are justified, well-maintained, and safe to rely on. It does not cover how dependencies are used in application logic, their performance characteristics, or internal code quality.

## Prerequisites

- A repository with source code to review
- Access to read all files in the repository including dependency manifests and lock files

## Workflow

1. Read top-level documentation (README, AGENTS.md, configuration files) to understand the project's purpose and technology choices
2. Read dependency manifests and lock files to inventory all direct and transitive dependencies
3. Determine the latest available version of each direct dependency and note how far behind the project's pinned versions are
4. For each direct dependency, assess justification, maintenance status, and license compatibility
5. Search for patterns where standard library alternatives could replace third-party packages
6. Evaluate the scope points below against what you have observed
7. Produce a structured report of findings and present it inline. Save only if the user asked, or if they instructed this run to proceed without intervention. Use the path they gave. If they asked to save but named no path, ask. If they instructed this run to proceed without intervention and named no path, write to `.start/reviews/YYYY-MM-DD-dependency-NN.md` (`NN` starts at `01`, incrementing against existing files matching the date and type)

## Reviewer Guidance

- Evaluate dependencies in proportion to the project's needs. A small utility library in a large project is a different risk profile than a foundational framework. Judge each dependency against the complexity it replaces, not against an ideal of zero dependencies.
- Most dependency findings are medium or low severity. Reserve high for dependencies with known vulnerabilities, abandoned maintenance, or incompatible licenses. Critical should be rare and reserved for actively exploited vulnerabilities or dependencies that pose an immediate supply chain risk.
- Distinguish between a dependency that could theoretically be replaced and one that should be. The cost of maintaining a vendored alternative often exceeds the risk of a well-maintained library. Flag dependencies that are genuinely problematic, not ones that are merely replaceable.
- It is acceptable to find no issues. A project with well-chosen, well-maintained dependencies is a valid outcome. Do not manufacture findings or question reasonable choices to justify the review.
- Write "None" for any severity level where no findings exist. Every section must be present in the report.

## Scope

- Justification: Evaluating whether a new dependency is necessary or if the problem could be solved with existing tools.
- Maintenance and Health: Assessing the activity level, security history, and community support of external libraries.
- License and Security: Verifying that the dependency's license is compatible and checking for known vulnerabilities.
- Supply Chain Risk: Reviewing the impact of transitive dependencies and the stability of the package history.
- Asset Impact: Evaluating the effect of the dependency on bundle sizes, startup times, or deployment complexity.

## Report Format

```
## Dependency Review Summary

Scope: {what was reviewed, number of direct and transitive dependencies}
Findings: {count per severity, e.g. 0 critical, 1 high, 2 medium, 1 low}

## Critical Findings

{findings that represent serious risk or deficiency, or "None"}

## High Findings

{findings that should be addressed, or "None"}

## Medium Findings

{findings worth considering, or "None"}

## Low / Info

{minor observations and suggestions, or "None"}

## Assessment

{overall assessment of the project's dependency health, noting both strengths and weaknesses}
```
