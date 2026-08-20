# Concurrency Review

Identify threading, parallelism, and asynchronous execution issues across the codebase. This review focuses on how the system manages concurrent access to shared resources and coordinates parallel operations. It does not cover general code correctness, performance optimisation, or architectural concerns unless they directly introduce concurrency defects.

## Prerequisites

- A repository with source code to review
- Access to read all files in the repository

## Workflow

1. Read top-level documentation (README, AGENTS.md, configuration files) to understand the system's concurrency model and runtime environment
2. Identify concurrency primitives used in the codebase: threads, tasks, coroutines, or equivalent constructs
3. Search for shared mutable state: global variables, package-level state, fields accessed across concurrent execution contexts
4. Read synchronisation logic: locks, channels, atomic operations, and concurrent data structures
5. Trace cancellation and context propagation through concurrent code paths
6. Review resource pool usage: connection pools, worker pools, and bounded concurrency patterns
7. Evaluate the scope points below against what you have observed
8. Produce a structured report of findings and present it inline. Save only if the user asked, or if they instructed this run to proceed without intervention. Use the path they gave. If they asked to save but named no path, ask. If they instructed this run to proceed without intervention and named no path, write to `.start/reviews/YYYY-MM-DD-concurrency-NN.md` (`NN` starts at `01`, incrementing against existing files matching the date and type)

## Reviewer Guidance

- Concurrency bugs are among the most severe because they are non-deterministic. A race condition that has never been observed in testing can still corrupt data in production. Weight findings by the consequence of the failure, not the likelihood of triggering it.
- Distinguish between unsafe sharing and intentional lock-free design. Not all shared state is a bug. Some patterns deliberately avoid synchronisation for performance. Evaluate whether the trade-off is documented and sound, not whether it matches a default expectation.
- Consider the runtime model. Different languages and runtimes provide different concurrency guarantees. Assess patterns against the actual runtime in use, not a generic model.
- It is acceptable to find no issues. A codebase that correctly manages concurrency is a valid outcome. Do not manufacture findings or flag safe patterns as suspicious to justify the review.
- Write "None" for any severity level where no findings exist. Every section must be present in the report.

## Scope

- Race Conditions: Identifying logic where the outcome depends on the non-deterministic timing of execution across multiple threads.
- Deadlocks and Livelocks: Ensuring that synchronization logic does not lead to states where the system is permanently stalled.
- Thread Safety: Verifying that shared resources are accessed through safe mechanisms that prevent data corruption.
- Shared State Management: Assessing the necessity of shared state and ensuring that mutable data is minimized.
- Async Patterns: Evaluating the use of asynchronous primitives to ensure they are handled without blocking or unhandled failures.
- Context and Cancellation: Verifying that operations respect cancellation signals and propagate execution context correctly.
- Resource Pools: Assessing the management of thread pools or connection pools to prevent exhaustion.

## Report Format

```
## Concurrency Review Summary

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

{overall assessment of the system's concurrency safety, noting both strengths and weaknesses}
```
