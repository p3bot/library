# Performance Review

Analyse code efficiency and resource usage across the codebase. This review focuses on how the system uses computational resources, manages memory, and handles I/O. It does not cover code correctness, architectural design, or concurrency safety unless they directly cause performance degradation.

## Prerequisites

- A repository with source code to review
- Access to read all files in the repository

## Workflow

1. Read top-level documentation (README, AGENTS.md, configuration files) to understand the system's purpose, expected scale, and performance-sensitive paths
2. Identify hot paths: request handlers, data processing pipelines, loops over large collections, and frequently called functions
3. Search for database access patterns: queries, ORM usage, batch operations, and connection management
4. Read I/O operations: file access, network calls, serialisation, and streaming patterns
5. Review resource lifecycle management: connections, file handles, buffers, and temporary allocations
6. Evaluate the scope points below against what you have observed
7. Produce a structured report of findings and present it inline. Save only if the user asked, or if they instructed this run to proceed without intervention. Use the path they gave. If they asked to save but named no path, ask. If they instructed this run to proceed without intervention and named no path, write to `.start/reviews/YYYY-MM-DD-performance-NN.md` (`NN` starts at `01`, incrementing against existing files matching the date and type)

## Reviewer Guidance

- Evaluate efficiency relative to the system's actual scale and usage. A CLI tool processing a handful of files does not need the same optimisation as a high-throughput service. Judge performance against realistic workloads, not theoretical worst cases.
- Most performance findings are medium or low severity. Reserve high for patterns that will cause measurable degradation under normal usage. Critical should be rare and reserved for issues like unbounded growth, resource leaks that will crash the system, or quadratic behaviour on large production datasets.
- Distinguish between genuine inefficiency and acceptable trade-offs. Readability and simplicity often justify a less optimal approach. Flag patterns that are meaningfully wasteful, not ones that are merely less than theoretically optimal.
- It is acceptable to find no issues. A codebase that uses resources efficiently for its scale is a valid outcome. Do not manufacture findings or flag reasonable implementations as inefficient to justify the review.
- Write "None" for any severity level where no findings exist. Every section must be present in the report.

## Scope

- Algorithmic Complexity: Identifying logic with sub-optimal complexity that could degrade as input size grows.
- Memory Management: Assessing allocation patterns to minimize unnecessary pressure on the garbage collector or memory limits.
- I/O Efficiency: Evaluating the frequency and size of network and disk operations to minimize latency.
- Database Efficiency: Identifying N+1 query patterns or expensive join operations that impact system throughput.
- Resource Lifecycles: Ensuring that connections, file handles, and other finite resources are closed promptly.
- Caching Strategy: Identifying opportunities to reuse expensive computations while ensuring invalidation is sound.
- Infrastructure Impact: Assessing whether the code introduces excessive compute or storage costs relative to its value.

## Report Format

```
## Performance Review Summary

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

{overall assessment of the system's performance characteristics, noting both strengths and weaknesses}
```
