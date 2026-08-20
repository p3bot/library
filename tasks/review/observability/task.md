# Observability Review

Assess whether the codebase provides sufficient instrumentation to understand and debug the system in production. This review covers logging, metrics, tracing, and health signals. It does not cover performance optimisation, error handling logic, or operational runbook completeness.

## Prerequisites

- A repository with source code to review
- Access to read all files in the repository
- A system that runs as a service or in a production-like environment

## Workflow

1. Read top-level documentation (README, AGENTS.md, configuration files) to understand the system's architecture, deployment model, and operational expectations
2. Search for logging frameworks, metrics libraries, and tracing integrations to understand the existing instrumentation approach
3. Identify health check endpoints, readiness probes, and liveness signals
4. Read source code focusing on request paths, error paths, and critical business operations to assess instrumentation coverage
5. Evaluate the scope points below against what you have observed
6. Produce a structured report of findings and present it inline. Save only if the user asked, or if they instructed this run to proceed without intervention. Use the path they gave. If they asked to save but named no path, ask. If they instructed this run to proceed without intervention and named no path, write to `.start/reviews/YYYY-MM-DD-observability-NN.md` (`NN` starts at `01`, incrementing against existing files matching the date and type)

## Reviewer Guidance

- Observability value is contextual. A CLI tool needs minimal instrumentation. A distributed microservice needs comprehensive logging, metrics, and tracing. Evaluate instrumentation depth against the system's operational context and deployment model.
- Severity should reflect the operational impact of gaps. Missing instrumentation on critical request paths or error conditions that would blind an operator during an incident is high. Inconsistent log levels or missing convenience metrics are medium or low.
- Focus on whether instrumentation exists where it matters, not whether every function is instrumented. The goal is operational visibility at key decision points, not exhaustive coverage.
- It is acceptable to find no issues. A well-instrumented codebase is a valid outcome. Do not manufacture findings or flag absent instrumentation where none is needed.
- Write "None" for any severity level where no findings exist. Every section must be present in the report.

## Scope

- Logging Quality: Ensuring logs provide sufficient context and appropriate severity levels to facilitate incident response.
- System Metrics: Verifying that critical performance and health indicators are instrumented for monitoring.
- Product Analytics: Confirming that user interaction events are captured accurately to inform business decisions.
- Distributed Tracing: Assessing the propagation of trace identifiers to allow for visualization of requests across services.
- Structured Output: Verifying that telemetry data is emitted in a format that is easily parsed by analysis tools.
- Health Checks: Ensuring the system exposes accurate readiness and liveness signals for orchestration.

## Report Format

```
## Observability Review Summary

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

{overall assessment of the system's observability posture, noting both strengths and weaknesses}
```
