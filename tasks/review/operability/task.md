# Operability Review

Assess whether the subject can be run in production, observed while running, kept serving through failure, recovered once state is lost, and operated correctly on its platform.

## Prerequisites

- A repository with source code to review
- Access to read all files in the repository

## Workflow

1. Read top-level documentation (README, AGENTS.md, configuration files) to understand the system's purpose, deployment model, and operational expectations
2. Search for error handling patterns and trace how failures propagate to the final handler or user-facing response
3. Search for logging, metrics, tracing, health checks, and alerting
4. Review recovery mechanisms: retries, timeouts, backups, rollback, and graceful shutdown
5. Review infrastructure and environment definitions: provisioning, drift, deployment, secrets injection, and capacity
6. Evaluate the scope points below against what you have observed
7. Produce a structured report of findings and present it inline. Save only if the user asked, or if they instructed this run to proceed without intervention. Use the path they gave. If they asked to save but named no path, ask. If they instructed this run to proceed without intervention and named no path, write to `.start/reviews/YYYY-MM-DD-operability-NN.md` (`NN` starts at `01`, incrementing against existing files matching the date and type)

## Reviewer Guidance

- Operability value is contextual. A CLI tool needs little production instrumentation. A long-running service must handle failure, be observable, and recover. Judge the strategy against what the system needs.
- Most operability findings are medium or low severity. Reserve high for patterns where unhandled failures could cause data loss, cascading outages, or an operator blinded during an incident. Critical should be rare and reserved for issues like swallowed errors that hide data integrity problems or missing backups on durable stores.
- Focus on whether the subject can be run, observed, and recovered where it matters, not whether every function is instrumented.
- It is acceptable to find no issues. A codebase that can be operated safely is a valid outcome. Do not manufacture findings or flag absent instrumentation where none is needed.
- Write "None" for any severity level where no findings exist. Every section must be present in the report.

## Scope

- Error Handling and Propagation: Ensuring errors are caught at the appropriate level and not swallowed without logging; that context is preserved as errors move through the system; and that unexpected inputs and unhandled failures cannot crash the process without a controlled path.
- Sensitive Data in Errors: Ensuring error messages, stack traces, and failure responses do not expose secrets, internal structure, or PII to clients.
- Error Message Actionability: Verifying that operator-facing error messages state what failed and what to do next, without relying on internal knowledge.
- Graceful Degradation: Assessing how the system behaves when a dependency or non-critical component fails.
- Retry and Fallbacks: Evaluating call-site retry behaviour, including backoff strategy, jitter, and retry budgets.
- Timeout Strategy: Verifying that call sites define appropriate timeout values and that those values are propagated correctly across service boundaries.
- Backpressure Handling: Assessing how call sites signal upstream producers to slow down when downstream capacity is exceeded.
- Fail-Fast vs Fail-Safe: Verifying that the system chooses the appropriate failure mode for the specific context.
- Failure Isolation and Containment: Verifying that fault tolerance mechanisms such as circuit breakers, bulkheads, and infrastructure partitioning keep a fault, misconfiguration, or failed deployment contained rather than cascading.
- Idempotency: Verifying that operations can be safely retried without producing unintended side effects or duplicate outcomes.
- Logging Quality: Ensuring logs provide rich context, correct severity levels, structured machine-parseable format, and a strong signal-to-noise ratio for incident response.
- System Metrics: Verifying that critical performance and health indicators are instrumented in a structured, machine-parseable form for monitoring.
- Distributed Tracing: Assessing the propagation of trace identifiers to allow for visualisation of requests across services.
- Telemetry Cardinality, Volume, and Cost: Assessing metric cardinality, log and trace volume, and retention windows so observability cost and backend load stay controlled without discarding data needed for incident response.
- Health Checks: Ensuring the system exposes accurate readiness and liveness signals for orchestration.
- Graceful Shutdown and Drain: Verifying that the process stops accepting work, finishes or safely aborts in-flight operations, and releases resources when asked to exit.
- Alerting Strategy: Evaluating alert threshold configuration, signal-to-noise ratio, and escalation paths to ensure actionable notifications.
- SLO and SLI Tracking: Verifying that reliability targets are defined, measured, and surfaced to support error budget decisions.
- Backup Coverage and Restore Verification: Confirming that every durable data store is backed up and that restores are exercised rather than assumed to work.
- Recovery Objectives: Verifying that tolerated data loss and time to restore service are defined, measurable, and matched by the mechanisms actually in place.
- Point-in-Time and Data Rollback: Assessing the ability to return data to a known-good state, including recovery from a destructive migration or a bad write.
- Backup Isolation and Immutability: Ensuring backups survive the failure that destroys the primary by residing outside its blast radius and resisting deletion or encryption.
- Corruption Detection and Reconciliation: Verifying that silent data corruption and divergence between stores are detected and reconciled rather than discovered by users.
- Operational Runbooks: Ensuring that failure scenarios have documented response procedures for operational teams.
- Resource Provisioning: Verifying that infrastructure resources are defined declaratively and that provisioning logic is idempotent.
- Infrastructure State Management: Assessing how infrastructure state is stored, shared, and protected from corruption or conflicts.
- Drift Detection: Ensuring mechanisms exist to identify and reconcile differences between declared and actual infrastructure state.
- Cost Attribution and Right-Sizing: Assessing whether provisioned resources are appropriately sized for their workload and tagged for cost tracking.
- Capacity, Quotas, and Limits: Verifying that throughput, storage, concurrency, and tenant quotas are defined and enforced, and that capacity is planned with measurable headroom rather than discovered at the failure point.
- Environment Reproducibility: Verifying that environments can be reliably recreated from their definitions without manual intervention.
- Deployment and Rollback Safety: Ensuring that deployment processes support safe rollback and that environment parity is maintained across stages.
- Secret and Configuration Injection: Ensuring that runtime secrets and configuration are delivered through secure, auditable channels rather than embedded in IaC definitions, baked into images, or stored in plaintext environment files.

## Report Format

```
## Operability Review Summary

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

{overall assessment of the subject's operability, noting both strengths and weaknesses}
```
