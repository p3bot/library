# Pre-commit Code Review

Interactive review of code changes from git diff output. Finds issues, walks through each one, and fixes them before commit.

This is not a general-purpose repository review. The diff output is the guide — only review the changed code and its immediate context.

## Workflow

### Phase 1: Review

1. Run git status to confirm we are in a Git repository and determine the state of changes (staged, unstaged, or both)
2. Use the diff they named. If they did not name one, pick the command that matches the working tree:
   - `git diff` for unstaged only
   - `git diff --staged` for staged only
   - `git diff HEAD` for both
   - `git diff <default>..HEAD` for changes since a branch point
3. Run the diff command and read the output to understand the scope and intent of the changes
4. For each changed file, read the full file and related files to understand surrounding context
5. Review the changes against all criteria below
6. Produce a structured report using the Report Format (below) and present it inline. Do not write a report file unless Save applies
7. If there are no actionable findings, skip to Phase 4 and report no issues found. Otherwise display the Top-level Prompt (see Commands)

### Phase 2: Remediation

Apply safe items immediately, without prompting. Safe items are anything that does not touch application code:

- Tests — add, remove, or change
- Comments — add, remove, or change
- Documentation — add, remove, or change

State what was applied for each safe item. Safe items do not count toward `m`.

Let `m` be the count of remaining actionable findings — the critical, high, medium, and low items, excluding info items (recorded only) and the safe items applied above. The top-level choice from Phase 1 selects how they are handled: `C` walks them one at a time in severity order, `A` applies the recommended resolution to every finding automatically. Letters are case-insensitive.

Continue (`C`) walks the findings one at a time in severity order. For each finding:

1. Re-read the target code and related code carefully, then critically re-evaluate the recommendation. The original finding may have been wrong, or rendered obsolete by an earlier fix. If the recommendation no longer holds, say so and revise or withdraw it before presenting. Before locking it: is it the root fix in the code, or a local patch on a symptom? Name the cheapest alternative and reject it only if it is worse on maintenance or correctness, not effort (agent-time is cheap). If the finding still needs the code in the reader's head to make sense, rewrite the instance, Simple Explanation, and Details until it does not — or withdraw it.
2. Present the finding using the Per-item Template (below) with `n` as the position in the walk and `m` as the total. `m` excludes safe items and info items.
3. Display the Per-item Prompt (see Commands) and pause for an explicit decision. Never assume blanket approval from an earlier response. Accepting one finding does not authorise the next. If a response is ambiguous, ask which finding it applies to.

Per-item command semantics. Letters are case-insensitive. Outcomes are tracked in-session — they are not written to disk at the moment of decision. They surface in the Phase 4 summary table and in the Remediation Summary if the review is saved.

- An option letter (`A`, `B`, `C` …) — apply that specific option. Track as `Fixed`. Briefly confirm what was done.
- `R` — apply exactly what the Recommendation states, which may be a single option, a combination, or a blend. Otherwise identical to applying an option. Track as `Fixed`.
- `N` — acknowledge and move to the next finding. Track as `Skipped`.
- `T` — create a tk ticket for this finding (see Ticket (T) below). Track as `Ticket: <id>`. Move to the next finding without offering an inline resolution. Omit this command unless the Ticket (T) check succeeded
- `S` — see Save (below).

All (`A`) applies recommendations automatically. Work through the `m` findings in severity order without displaying the Per-item Prompt. For each finding:

1. Announce `(n of m) <ID> <short title>`.
2. Re-read the target code and related code and critically re-evaluate the recommendation, as in the walk. If it no longer holds, say so and skip it, tracking as `Skipped`. Before applying, run the same Recommendation lock as the walk.
3. Apply the recommended resolution — identical to `R` — and briefly confirm what was done. Track as `Fixed`.

The edit is the checkpoint. If you deny an edit, stop and discuss that finding; once it is resolved, resume the run for the remaining findings or switch to the one-at-a-time walk.

Remediation guidance:

- Bias recommendations toward the principled long-term solution that reduces maintenance and improves quality. Do not default to the smallest-diff resolution. Prefer the option you would pick if writing the fix were free
- Apply minimal, targeted edits to integrate the resolution. Refactor surrounding code only when required to make the resolution land cleanly
- If a resolution would be too large or risky to apply inline, recommend `T` when `tk` is available, otherwise leave it for Save or a later pass
- Keep each fix focused on the issue being addressed and related code

### Phase 3: Satisfaction Pass

After all findings have been processed, do a focused re-check on only the code that was modified by fixes during Phase 2.

- Only examine the lines and immediate context touched by fixes, not a full re-review
- Handle new findings using the mode chosen at the top level — walk them under `C`, auto-apply them under `A` (deny an edit to discuss)
- This pass is lightweight — catch regressions introduced by the fixes themselves
- After fixes are applied, run any formatters or linters the project has configured on the touched files and address any new violations they surface

### Phase 4: Wrap-up

1. Print a summary table of all findings and their outcomes. Do not prompt to save
2. Remind the user to review the changes before committing

## Reviewer Guidance

- The diff is your primary input — stay focused on what changed
- Read surrounding code in changed files to understand context
- Distinguish between new issues introduced by the diff and pre-existing issues
- Flag pre-existing issues if discovered
- Ask clarifying questions when the intent of a change is unclear
- Reference the specific file and change from the diff in each finding
- Recommendations target the principled long-term solution. Do not default to the minimal-diff resolution
- Classify findings by severity (critical, high, medium, low, info):
  - Not every review category will produce findings at every severity level
  - Use the levels that fit rather than forcing findings into categories that do not apply
- Give each finding an ID: its severity letter (`C`, `H`, `M`, `L`, `I`) plus a per-severity number — `C1`, `H1`, `H2`, `M1`, `L1`, `I1`. The ID carries the severity, so severity is not repeated as a separate column or field
- Findings about multiple unrelated changes within a single commit are classified as `info`
- The Findings table lists only severities that have findings; the count line summarises the totals across all severities
- It is acceptable to find no issues. If the changes are well-implemented, say so. Do not manufacture findings to justify the review

## 1. Correctness Review

Purpose: Verify that the subject implements the intended behaviour precisely, including under concurrent and distributed execution.

- Algorithm Correctness: Verifying that the logic produces the expected output for all valid inputs and maintains logical integrity.
- Business Logic Accuracy: Ensuring the implementation faithfully represents the specified domain rules and stakeholder intentions.
- State Transitions: Assessing how the system moves between states to ensure data remains consistent and the flow is logical.
- Cache and Replica Coherence: Verifying that caches and replicas do not serve a result that violates the operation's intended freshness or consistency.
- Data Transformations: Evaluating the precision of data mapping and conversion logic to prevent loss of fidelity or unintended mutations.
- Operator and Condition Correctness: Reviewing conditional branches, logical operators, and comparison logic for accuracy and exhaustive coverage.
- Boundary and Off-by-one Errors: Identifying logic flaws that occur at the extreme limits of data ranges, loops, and collection indices.
- Order of Operations: Verifying that the sequence of execution and precedence of operations yield the logically sound result.
- Numeric Precision and Overflow: Verifying that numeric types, rounding behaviour, and value ranges preserve accuracy and cannot silently overflow or lose precision.
- Time and Clock Handling: Assessing the handling of time zones, daylight saving transitions, clock skew, and the distinction between wall-clock and monotonic time.
- Absent Value Handling: Verifying that null, empty, zero, and undefined values are distinguished correctly and that absent data cannot cause unsafe dereferences or unchecked conversions.
- Error-path Outcomes: Verifying that failure and fallback paths produce the intended result rather than a silent wrong success (for example a swallowed error returning zero, empty, or last-good data).
- Race Conditions: Identifying logic where the outcome depends on the non-deterministic timing of concurrent execution (threads, async tasks, processes, or equivalent local actors).
- Deadlocks and Livelocks: Ensuring that synchronisation logic does not lead to states where the system is permanently stalled.
- Thread Safety and Shared State: Verifying that shared resources are accessed safely so concurrent use cannot produce torn reads, lost updates, or visibility of partial writes.
- Async Patterns: Evaluating asynchronous primitives so results are not lost, duplicated, or applied after cancellation, and so completion order cannot produce a wrong state.
- Context and Cancellation: Verifying that operations respect cancellation signals and propagate execution context correctly.
- Resource Pools: Verifying that concurrent use of thread and connection pools cannot deadlock, livelock, or corrupt in-flight work by exhausting the pool.
- Distributed Concurrency: Evaluating the correctness of distributed locks, leader election, and consensus mechanisms across networked nodes.
- Event Ordering and Eventual Consistency: Assessing whether the system correctly handles out-of-order events and maintains correctness under eventual consistency models.

## 2. Testing Review

Purpose: Evaluate test quality, coverage, and the testability of the subject.

- Coverage Depth: Assessing whether tests verify the logic under review across a representative range of scenarios.
- Suite Gating: Verifying that the suite runs on every proposed change and can block merge when it fails.
- Test Quality: Ensuring tests are readable, maintainable, and verify behaviour rather than implementation details.
- Testability: Verifying that the subject can be driven by automated tests through explicit seams and deterministic behaviour, rather than hidden state or live side effects.
- Test Isolation: Verifying that isolated tests do not share state or depend on ambient environment, and that tests which use real dependencies declare that choice rather than leaking it.
- Flakiness Prevention: Identifying tests that may fail intermittently due to timing or environmental factors.
- Mocking and Stubbing: Evaluating the use of doubles to ensure they are realistic and do not mask actual integration issues.
- Contract Testing: Verifying that service interfaces match consumer expectations and do not break downstream integrations.
- Performance and Load Test Coverage: Assessing whether critical paths have tests under realistic load.
- End-to-End Testing: Assessing whether critical user journeys across service boundaries are covered by end-to-end tests.
- Chaos Test Coverage: Assessing whether controlled failure injection covers resilience under adverse conditions.
- Security Test Coverage: Assessing whether tests cover authentication, authorisation, input validation boundaries, and known attack patterns relevant to the reviewed subject.
- Non-Deterministic and Eval Behaviour: Assessing how tests handle non-deterministic model or agent output, including seeds, fixtures, eval harnesses, and tolerance bands that keep signal without masking regressions.

## 3. Security Review

Purpose: Identify vulnerabilities, security weaknesses, and potential attack vectors.

- Authentication and Authorisation: Verifying the integrity of identity verification and the strict enforcement of access boundaries across all layers.
- Session Management: Reviewing the lifecycle and security properties of user sessions and tokens to prevent hijacking or unauthorised reuse.
- Privilege Escalation: Analysing logic for flaws that could allow a user to perform actions beyond their intended permission level.
- Insecure Direct Object References: Verifying that access to resources by identifier enforces authorisation checks rather than relying on obscurity.
- Tenant Isolation: Verifying that data stores, caches, queues, background jobs, and search indices enforce tenant boundaries so no request can reach another tenant's records.
- Network Policy and Segmentation: Reviewing network rules to ensure services are isolated appropriately and follow least-privilege access.
- Secrets Management: Confirming that sensitive credentials are stored, accessed, rotated, and audited safely through externalised mechanisms.
- Secrets in Version Control History: Verifying secrets are absent from the full revision history (not only the current tree), and that any past exposure has been rotated and purged or otherwise rendered unusable.
- Data Protection and Encryption: Assessing the safety of sensitive information at rest and in transit, including the prevention of data leakage in logs.
- Cryptography Usage: Evaluating the implementation of cryptographic primitives to ensure the use of proven, industry-standard protocols.
- Input Validation and Sanitisation: Ensuring all untrusted data is validated and cleaned to prevent injection and manipulation attacks.
- Excessive Data Exposure: Verifying that API and service responses return only fields the caller needs, and that debug, internal, or sensitive attributes are not leaked through over-fetch or verbose error payloads.
- CORS and CSRF Protection: Verifying that cross-origin policies and request forgery protections are correctly configured.
- Rate Limiting: Assessing the system's resilience against automated abuse, brute-force attempts, and resource exhaustion.
- Secure Headers: Confirming the presence of security-related HTTP headers that harden the client-side execution environment.
- Path Traversal: Ensuring that file and resource pathing logic cannot be manipulated to access restricted areas.
- Server-Side Request Forgery: Ensuring server-side requests cannot be manipulated to access internal resources or unintended external targets.
- Mass Assignment: Verifying that object binding from external input does not allow modification of unintended fields or properties.
- File Upload Security: Ensuring uploaded files are validated for content type, scanned for malicious content, and stored in isolated locations.
- Deserialisation Safety: Verifying that the conversion of data formats into objects does not introduce execution risks.
- Webhook and Callback Verification: Ensuring inbound callbacks from external systems are authenticated by signature and protected against replay.
- Prompt Injection and Untrusted Content: Verifying that untrusted content cannot override system instructions, exfiltrate secrets, or redirect tool use when incorporated into model prompts or agent context.
- Tool and Agent Permission Scope: Verifying that tools, functions, and side-effecting actions available to a model or agent are least-privilege, explicitly granted, and cannot be expanded by untrusted input.
- Model Output Validation: Ensuring model or agent output is validated, sandboxed, or human-gated before it drives side effects such as code execution, data mutation, or external requests.
- Time-of-Check to Time-of-Use: Identifying races where a permission, existence, or integrity check is separated from use so an attacker can change the resource in the gap.
- Audit Trail: Confirming that security-relevant events are captured completely and stored with tamper-resistance sufficient for forensic analysis.

## 4. Compliance Review

Purpose: Verify that the subject meets its legal, regulatory, and organisational policy obligations, including the lawful handling of personal data.

- Regulatory Compliance: Assessing adherence to legal and data privacy frameworks such as GDPR or HIPAA where applicable.
- Industry Standards: Verifying compliance with sector and certification protocols that apply to the subject.
- Organisational Standards: Ensuring alignment with internal policy obligations such as mandated controls, approved processors, and company data-handling rules.
- Data Classification: Ensuring that data is categorised by sensitivity level, including explicit recognition of personal data, and that handling procedures match the classification.
- Lawful Basis and Consent: Confirming that personal data processing has a documented lawful basis and that consent, where required, is captured, scoped, and revocable.
- Data Minimisation and Purpose Limitation: Verifying that only data necessary for the stated purpose is collected and retained, and that data collected for one purpose is not silently reused for another without re-establishing lawful basis.
- Retention and Deletion: Verifying that personal data has defined retention periods and that deletion, including right-to-be-forgotten requests, is implemented end-to-end across stores and backups.
- Data Subject Rights: Verifying that mechanisms exist to satisfy access, rectification, portability, restriction, and objection requests across all stores holding personal data, with response paths that are testable, auditable, and complete.
- Anonymisation and Pseudonymisation: Assessing whether identity protection techniques applied to personal data match the asserted classification, distinguishing irreversible anonymisation from pseudonymisation that retains a re-identification path, and verifying that re-identification risk is bounded under realistic linkage.
- Automated Decision-Making and Profiling: Assessing whether profiling or automated decisions producing legal or significant effects on individuals are identified, documented, and accompanied by safeguards such as human review, contestability, and explanation paths.
- Third-Party Data Sharing: Reviewing what personal data is shared with external services and whether processor agreements and data flows are documented.
- Telemetry and Diagnostic Surfaces: Verifying that logs, metrics, traces, product analytics events, and error reports do not capture personal data without lawful basis, and that identifiers traversing those surfaces are redacted, hashed, or pseudonymised in line with the data classification.
- Cross-Border Data Transfer: Verifying compliance with jurisdictional requirements for data movement across geographic boundaries.

## 5. Performance Review

Purpose: Analyse the subject's efficiency and resource usage.

- Algorithmic Complexity: Identifying logic with sub-optimal complexity that could degrade as input size grows.
- Memory Management: Assessing allocation patterns to minimise unnecessary allocator, heap, or garbage-collector pressure and to stay within memory limits.
- I/O Efficiency: Evaluating the frequency and size of network and disk operations to minimise latency.
- Database Efficiency: Identifying N+1 query patterns or expensive join operations that impact system throughput.
- Contention and Lock Pressure: Identifying synchronisation points that limit throughput under concurrent load.
- Resource Lifecycles: Ensuring that connections, file handles, and other finite resources are closed promptly.
- Caching Strategy: Identifying opportunities to reuse expensive computations, and assessing hit rate, cache size, and eviction cost.
- Cold Start and Warm-up: Evaluating initialisation latency in serverless or JIT-compiled environments and strategies to mitigate it.
- Token and Context Budget: Assessing prompt size, context window use, retrieval volume, and model-call batching so cost and latency stay within budget as input and history grow.
- Infrastructure Impact: Assessing whether runtime behaviour drives excessive compute, network, or storage consumption relative to the value delivered.
- Performance Instrumentation: Ensuring critical paths emit latency, throughput, and saturation metrics that allow efficiency regressions to be detected in production.

## 6. Operability Review

Purpose: Assess whether the subject can be run in production, observed while running, kept serving through failure, recovered once state is lost, and operated correctly on its platform.

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

## 7. Architecture Review

Purpose: Evaluate system structure, design decisions, component organisation, and whether the shape of the subject fits its stated purpose.

- Solution Fit: Assessing whether the current solution is the right one for the subject's stated purpose, not only whether the implementation matches the stated architecture.
- System Design and Layering: Ensuring clear separation of concerns where each layer has a distinct responsibility and avoids leaky abstractions.
- Component Boundaries: Verifying that interactions between modules are well-defined and do not violate the principle of least knowledge.
- Repository Structure: Assessing whether the file layout and directory organisation are intuitive and self-explanatory.
- Dependency Flow: Assessing the direction of dependencies to ensure high-level policy is protected from implementation details.
- Modularity and Reusability: Identifying opportunities for abstraction that reduce coupling while avoiding premature generalisation.
- API Design and Contracts: Evaluating the stability and clarity of interfaces to ensure they are difficult to misuse.
- Backwards Compatibility: Ensuring integrations, data formats, and downstream expectations remain intact.
- Portability and Runtime Compatibility: Verifying that assumptions about platform, runtime version, filesystem paths, character encoding, and locale hold across every supported target.
- Configuration Management: Verifying that non-secret runtime configuration (feature flags, tunables, environment-specific settings) can adjust system behaviour safely through structured mechanisms without code changes.
- Event-Driven Architecture: Assessing message ordering guarantees, schema evolution strategies, and dead letter handling in asynchronous systems.
- Data Partitioning: Reviewing sharding strategies and partition key selection for balanced distribution and a stable growth path.
- Database Integrity: Verifying that schema changes maintain data consistency and handle migrations safely.
- Scalability and Extensibility: Assessing whether the design accommodates growth in data volume or future requirements without requiring a rewrite.
- Tech Stack Coherence: Identifying library sprawl or conflicting tool choices that complicate the strategic technical direction.

## 8. Maintainability Review

Purpose: Assess whether the subject can be read, navigated, documented, and changed safely by developers other than its author.

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

## 9. Supply Chain Review

Purpose: Review what the subject consumes and what it publishes, from third-party dependencies through build integrity to release.

- Justification: Evaluating whether a new dependency is necessary or if the problem could be solved with existing tools.
- Maintenance and Health: Assessing the activity level, security history, and community support of external libraries.
- Dependency Vulnerabilities: Identifying third-party packages with known CVEs or unpatched security issues present in the reviewed subject.
- Licence Compatibility: Verifying that each dependency's licence is compatible with the subject's own licence and distribution model.
- Supply Chain Risk: Assessing the trustworthiness of the dependency chain, including transitive dependencies, ownership changes, and typosquatting indicators.
- Asset Impact: Evaluating whether the dependency's cost in size, startup, and deploy complexity is justified by what it provides.
- First-Party Licensing and Attribution: Verifying that the subject declares its own licence correctly and that copied or vendored code carries the attribution its licence requires.
- Project Hygiene: Checking that build and release tooling needed to produce the artefact is declared and consistent.
- Build Reproducibility: Assessing whether builds produce consistent artefacts from the same source without depending on ambient machine state.
- Artefact Provenance: Verifying that published artefacts are signed, traceable to the source revision that produced them, and accompanied by an inventory of their materials.
- Pipeline Security: Identifying risks in the build pipeline itself, including untrusted trigger paths, secret exposure to forks, and over-privileged runner credentials.
- Release and Deprecation Policy: Assessing whether versioning, deprecation windows, and migration guidance allow consumers to upgrade predictably.

## 10. Experience Review

Purpose: Assess whether the interface the end user or end agent consumes matches its design intent and serves them correctly across channels, states, input methods, and abilities.

- Visual Fidelity: Assessing whether the rendered output aligns with the design specifications across various viewports.
- Responsive Behaviour: Verifying that the interface adapts correctly to different screen sizes and platform constraints.
- Interaction States: Reviewing the behaviour and visual feedback of elements during user engagement.
- Keyboard and Focus Management: Ensuring the interface is fully operable without a pointer and that focus order and visibility follow the user's task.
- Form and Validation Feedback: Assessing whether input requirements, validation timing, and error recovery guide the user toward a successful outcome.
- Theming and Visual Preferences: Ensuring the interface honours user preferences such as colour scheme, contrast, and reduced motion.
- Perceived Performance: Assessing responsiveness as experienced by the user, including layout stability and feedback during long-running operations.
- Command and Flag Clarity: Verifying that command names, flags, subcommands, and positional arguments are discoverable, consistent, and hard to misuse.
- Help and Usage Paths: Assessing whether help text, usage examples, and progressive disclosure guide the user to a successful outcome without internal knowledge.
- Agent Document Fidelity: Assessing whether agent-facing prompts, role documents, and skills are clear per token, instruction-faithful, and free of conflicting or unreachable guidance.
- Conversational Turn Quality: Assessing whether multi-turn agent or chat interfaces preserve task context, surface uncertainty, and recover from misunderstanding without trapping the user.
- State Coverage: Verifying that loading, empty, partial, and error states are deliberately designed and reachable rather than left to default behaviour.
- Accessibility: Ensuring the implementation is usable by individuals with diverse needs, including WCAG/ARIA for graphical UI and equivalent reach for CLI and conversational channels where applicable.
- Content and Microcopy: Verifying that labels, messages, and instructions are accurate, consistent in voice, and comprehensible without internal knowledge.
- Internationalisation (i18n): Verifying that the interface is prepared for localisation, handling diverse languages and cultural formats.

## Per-item Template

Findings are read by someone who has not opened the code, cannot look anything up, and has to decide something after one read.

The bar: that reader can restate the problem in their own words after reading it once. A finding that fails this has failed, however accurate it is.

Open with the smallest concrete instance that shows the problem, then explain it. Four moves, in order:

1. Establish what correct looks like and show the break against it. Where the code runs, that is a command and its output, a call and its return, or a request and its response, with the expected value alongside — `ParseDuration("500ms") → 0s (want 500ms)`. Where the change is structural and produces no output, it is the scenario it would break, in plain language. Contrast two cases when the behaviour is conditional; the contrast is usually what makes the break obvious
2. Give the Simple Explanation — one or two sentences in everyday language naming the problem, so the reader has the gist before any cause chain
3. Say what causes it, in the same terms
4. Say what it costs

Writing rules:

- Name things by what they are, not by what they are called in the code. "the retry counter", not `svc.rc`. Symbols and `file:line` follow the plain-language noun in parentheses as anchors; they never carry the explanation
- Spell out internal shorthand on first use. Requirement ids, ticket numbers, and project acronyms mean nothing to the reader
- Never fabricate an observable. If the code path cannot be run as written, do not dress a structure diff up as command output — show the scenario instead
- Length follows comprehension. Cut padding, never cut the setup that makes the rest land
- Do not argue the finding is real or recap intent. The instance and the explanation carry it
- Separate each option with a blank line. Never collapse options onto one line

```
### Issue n of m — <ID>: <short title>

Category: <e.g. Security, Correctness>
Location: <file:line>

<the smallest concrete instance: command → output, request → response, call →
return, with the expected value alongside — or the scenario the change breaks
where nothing runs. Show it; do not describe it.>

**Simple Explanation**

<one or two sentences naming the problem in everyday language — enough that the
reader can restate it without reading Details. No cause chain, no options.>

**Details**

<continuous prose: what causes it and what it costs, in the same plain terms as
the instance above. As long as it needs to be to land, and no longer.>

**Decision**

<the single question being put to the reader>

**Options**

A. <option — what it does, its tradeoff>

B. <option>

**Recommendation (B)**

<option letter, then one clause on why, focused on the principled long-term solution>
```

Worked example:

```
### Issue 1 of 1 — M1: ParseDuration truncates sub-second values to zero

Category: Correctness
Location: internal/timeutil/parse.go:42

  ParseDuration("500ms")  → 0s     (want 500ms)
  ParseDuration("1500ms") → 1s     (want 1.5s)

**Simple Explanation**

Sub-second durations are silently rounded down to whole seconds, so a 500ms
timeout becomes no timeout at all.

**Details**

The result is assembled in whole seconds, so the millisecond remainder is
dropped before the duration is built. Any caller passing a sub-second timeout
gets no timeout at all, and the failure is silent — the call returns a valid
duration, just the wrong one.

**Decision**

Rebuild from nanoseconds, or carry a float through?

**Options**

A. Build the duration from nanoseconds, then convert — exact, and mirrors how
   the standard library parses the same strings.

B. Keep seconds and add a separate milliseconds field — wider change, more
   surface for the same result.

**Recommendation (A)**

A nanosecond base matches `time.ParseDuration` and drops no precision.
```

Display the Per-item Prompt (see Commands) immediately after presenting the finding.

Include an Options block only when alternatives clarify the choice — otherwise omit it and lead with a single Recommendation that `R` accepts. When present, label options from `A` and separate each with a blank line. The Recommendation names the option letter or letters it favours, and may combine options (for example `Recommendation (B + C)`).

## Report Format

Structure the review report as follows. After the header, bullet what the changes do before listing findings. Each bullet is one outcome or change the diff delivers — not a file-by-file changelog.

```
## Diff Review Summary

Scope: <number of files changed, insertions, deletions>
Intent: <brief description of what the changes accomplish>
Findings: <count per severity, e.g. 2 critical, 1 high, 3 medium, 1 low, 4 info>

## What these changes do

- <outcome or change>
- <outcome or change>

## Findings

A complete list of every finding in severity order — list all of them, do not truncate. Info items are recorded for awareness only and are not walked. The detail for each actionable finding (Simple Explanation, Details, Options, Recommendation) is presented one at a time during the Phase 2 walk, not here.

| ID | Category | Location | Finding |
|----|----------|----------|---------|
| C1 | Security | src/auth.go:88 | <one-line summary> |
| M1 | Maintainability | src/foo.go:42 | <one-line summary> |
| I1 | Experience | src/bar.go:10 | <one-line summary> |

## Assessment

<overall assessment of the changes, noting both strengths and weaknesses>
```

When the report is saved after remediation begins, append the following section. Outcome values are:

- `Fixed` — the change was applied
- `Skipped` — the finding was acknowledged with `N` and left unresolved
- `Ticket: <id>` — spun out as a tk ticket
- `Pending` — `S` was invoked before the finding had been processed

```
## Remediation Summary

| ID | Finding | Outcome |
|----|---------|---------|
| C1 | Brief description | Fixed |
| H1 | Brief description | Skipped |
| M1 | Brief description | Ticket: lib-a3 |
| L1 | Brief description | Pending |
```

## Ticket (T)

Before showing either prompt, run `command -v tk`. Offer `T` only if it succeeds. Omit it from both prompts otherwise. Do not mention tk when it is absent.

Per-item `T` creates one tk ticket for that finding and continues the walk. Top-level `T` creates one tk ticket covering the remaining findings and stops.

When `T` is selected:

1. Run `tk create` with a title from the finding's short title (per-item) or a title covering the remaining set (top-level)
2. Then `start get contexts:ticket/writing`. Never fetch the writing guide at review start
3. The writing guide's File Placement section does not apply. The path is the one `tk create` printed
4. Fill under that H1. Do not paste a second heading
5. The writing guide supplies principles, section purpose, and formatting only
6. Track as `Ticket: <id>`
7. If `tk status mode` is `tk-driven`, `tk sync` after the body fill

Per-item fill: the ticket is that finding. Carry the instance, Simple Explanation, Details, Options, and Recommendation already presented.

Top-level fill: re-check each remaining finding with the same Recommendation lock as the walk. Skip any that no longer hold. Write each that still holds with its instance, Simple Explanation, Details, Options, and Recommendation so a fresh session can walk the set. Then stop.

## Save

Write the report only when the user asked to save it — including by invoking `S` — or when they instructed this run to proceed without intervention.

Use the path they gave. If they asked to save but named no path, ask. If they instructed this run to proceed without intervention and named no path, write to `.start/reviews/YYYY-MM-DD-pre-commit-NN.md` (`NN` starts at `01`, incrementing against existing files matching the date and slug).

When writing after remediation has started, include the Remediation Summary with current outcomes. Findings not yet processed are recorded as `Pending`. Confirm the filename written.

## Commands

### Top-level Prompt

Display at the end of Phase 1. Include the Ticket line only if the Ticket (T) check succeeded.

```
- (C)ontinue — walk through the findings one at a time
- (A)ll — apply the recommended resolution to every finding automatically
- (S)ave — write the report and stop
- (T)icket — create a tk ticket for the remaining findings and stop
```

### Per-item Prompt

Display after presenting each finding. Include Ticket only if the Ticket (T) check succeeded.

```
(R)ecommended  (N)ext  (T)icket  (S)ave
```
