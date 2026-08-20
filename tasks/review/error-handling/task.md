# Error Handling Review

Review how the codebase handles failures and whether edge cases are covered. This review focuses on error detection, propagation, and recovery strategies. It does not cover code correctness, testing coverage, or architectural design unless they directly relate to failure handling.

## Prerequisites

- A repository with source code to review
- Access to read all files in the repository

## Workflow

1. Read top-level documentation (README, AGENTS.md, configuration files) to understand the system's purpose and failure domains
2. Search for error handling patterns: try/catch blocks, error return values, error types, and custom error definitions
3. Trace error propagation paths: how errors flow from origin through layers to the final handler or user-facing response
4. Identify external boundaries: API calls, database operations, file I/O, and other points where failures originate
5. Review recovery mechanisms: retries, fallbacks, circuit breakers, and graceful shutdown paths
6. Evaluate the scope points below against what you have observed
7. Produce a structured report of findings and present it inline. Save only if the user asked, or if they instructed this run to proceed without intervention. Use the path they gave. If they asked to save but named no path, ask. If they instructed this run to proceed without intervention and named no path, write to `.start/reviews/YYYY-MM-DD-error-handling-NN.md` (`NN` starts at `01`, incrementing against existing files matching the date and type)

## Reviewer Guidance

- Most error handling findings are medium or low severity. Reserve high for patterns where unhandled failures could cause data loss, cascading failures, or silent corruption. Critical should be rare and reserved for issues like swallowed errors that hide data integrity problems or missing error handling on paths that could crash the system in production.
- Evaluate error handling relative to the system's context. A CLI tool with a single user can afford to crash on unexpected input. A long-running service must handle failures gracefully. Judge the strategy against what the system needs, not an idealised standard.
- Distinguish between missing error handling and intentionally minimal handling. Some code legitimately allows errors to propagate unhandled because the caller is expected to deal with them. Flag patterns where errors are lost or ignored, not where they are delegated.
- It is acceptable to find no issues. A codebase with sound error handling is a valid outcome. Do not manufacture findings or flag reasonable patterns as deficient to justify the review.
- Write "None" for any severity level where no findings exist. Every section must be present in the report.

## Scope

- Exception Strategy: Ensuring that errors are caught at the appropriate level and not swallowed without logging.
- Error Propagation: Verifying that error context is preserved as it moves through the system to aid root cause analysis.
- Graceful Degradation: Assessing how the system behaves when a dependency or non-critical component fails.
- Edge Case Coverage: Identifying unhappy paths and unexpected inputs that could cause the system to crash.
- Retry and Fallbacks: Evaluating the safety and back-off strategy of automatic retries to prevent worsening failures.
- Fail-Fast vs Fail-Safe: Verifying that the system chooses the appropriate failure mode for the specific context.

## Report Format

```
## Error Handling Review Summary

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

{overall assessment of the system's error handling maturity, noting both strengths and weaknesses}
```
