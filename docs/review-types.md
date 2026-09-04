# Review Types

A structured framework of analysis categories. Each type defines a specific set of concerns used to evaluate the integrity, security, and quality of a subject under review.

This document defines three axes only: subject (what to look at), type (what to look for), and depth (how far down each bound type's scope list to go). It does not prescribe which types or depth a review must use. Invoking tasks bind subject, types, and depth; they use this document as the vocabulary and scope catalogue when authoring those instructions.

## Review Subject

A review type defines what to look for. The subject defines what to look at. The two axes are independent: the invoking task binds a subject, and the type definitions below never assume one.

A subject may be:

- A diff or patch set
- A working tree with uncommitted changes
- A single directory
- A whole repository
- A package or module within a monorepo
- A prompt, role, or skill document
- A design doc or spec
- A build pipeline or published artefact

Subject granularity affects which types yield signal, not which types apply. An Architecture review is richest over a repository or directory and degenerates over a single-line diff; a Correctness review is sharp at any granularity. Where a scope item must name the thing it examines, it refers to the reviewed subject, never to a fixed target.

## Review Depth

Subject binds what to look at. Types bind what to look for. Depth binds how far down each bound type's scope list to go.

- Survey: One or many types at low depth. Sample for material issues; do not treat every scope item as mandatory.
- Deep: Few types at full depth. Walk the full scope list for each bound type.

The invoking task sets depth. Binding a type is not an order to empty every item on every run. Breadth across types is a depth choice, not a separate review type.

Depth is both an instruction to the reviewer and a claim the review artefact must not contradict: a Survey must not present itself as having walked every scope item; a Deep review must not skip bound scope items without stating why they do not apply.

## Review Families

Types are grouped into five families by the question they answer. The family is a navigation aid, not a scoping rule: a review binds types, never families. Families are not bindable units, not depth settings, and not a substitute for listing types. When an orchestrator fans out one agent per family, each agent's bind still names its types explicitly.

| Family | Type | Purpose |
| --- | --- | --- |
| Does It Work | Correctness | Verifying the subject matches intended behaviour, including under concurrency |
| | Testing | Evaluating test quality, coverage, and testability |
| Is It Safe | Security | Identifying vulnerabilities and attack vectors |
| | Compliance | Meeting legal, regulatory, and organisational policy obligations |
| Will It Hold Up | Performance | Analysing efficiency and resource usage |
| | Operability | Running, observing, surviving failure, recovering, and platform fit in production |
| Can We Live With It | Architecture | Evaluating structure, design decisions, and whether the shape fits the stated purpose |
| | Maintainability | Assessing clarity, consistency, and cost of future change |
| | Supply Chain | Reviewing what the subject consumes and what it publishes |
| Does It Serve The User | Experience | Reviewing interface fidelity, interaction, and reach |

## Severity Rubric

Every finding carries two independent properties: severity (how bad if true) and confidence (how sure it is true). Record both on every finding in the review artefact. Neither is a property of the review type. A finding without both is incomplete regardless of how severe or how certain the prose implies it is.

### Severity

Score severity against these impact dimensions. Rate only dimensions that apply; omit the rest. Omitted dimensions do not pull the finding down.

- Blast Radius: How many systems, users, or records are affected.
- Trigger Likelihood: How easily the issue can be triggered, intentionally or accidentally.
- Reversibility: How hard recovery is once the issue manifests.
- Data Sensitivity: What classification of data is involved (public, internal, confidential, regulated).
- User Impact: What the affected user experiences.

Rate each applicable dimension at one of four levels:

- Critical: Extreme on that dimension — for example very broad blast radius, trivial to trigger, effectively irreversible, regulated or highly sensitive data, or severe user harm. Requires immediate attention if this is the finding level.
- High: Material on that dimension — defined scope meaningfully affected, realistic trigger conditions, costly recovery, confidential data, or notable user disruption.
- Medium: Limited on that dimension — narrow blast radius, specific conditions to trigger, recoverable with effort, internal data, or moderate user friction. Should be addressed but not blocking if this is the finding level.
- Low: Minor on that dimension — cosmetic or contained impact, unlikely trigger, trivially reversible, public or non-sensitive data, or negligible user effect. Best-effort fix if this is the finding level.

Finding severity is the worst level among the dimensions rated. One Critical-grade dimension makes the finding Critical; weaker dimensions are not averaged in.

### Confidence

- Confirmed: Reproduced, demonstrated with evidence, or proven by inspection of the controlling code path.
- Probable: Strong indications from code or config; not fully reproduced.
- Speculative: Hypothesis or pattern match without direct evidence on this subject.

Do not raise severity to compensate for low confidence, or lower it to compensate for high confidence. A speculative Critical is still Critical in impact if true; it is not yet verified.

## Overlap and Ownership

A finding belongs to the type whose question it answers. When several types could claim it, pick the primary by remediation:

- Stop an attacker or close a weakness: Security
- Meet a legal, regulatory, or organisational policy obligation: Compliance
- Fix production runtime, observability, or recovery: Operability
- Fix efficiency of the subject: Performance
- Fix structure or dependency shape: Architecture
- Fix clarity or cost of change: Maintainability
- Fix the test suite or testability: Testing
- Fix logic versus intended behaviour: Correctness
- Fix what is consumed or published: Supply Chain
- Fix the interface the end user or end agent consumes: Experience

Do not file the same issue under two types unless the remediation differs. A secondary type may cross-reference the primary finding instead of duplicating it.

Secrets and sensitive data often touch several types. Primary by remediation:

- Store, access, rotate, or audit credentials; purge secrets from revision history: Security
- Change how secrets or configuration are delivered into the running process: Operability
- Lawful basis, retention, or personal data in logs, metrics, traces, or analytics: Compliance
- Credentials or secrets appearing in telemetry or error surfaces without a personal-data question: Security (Data Protection and Encryption, or Sensitive Data in Errors under Operability when the fix is error-path redaction only)

When both rotate-and-purge and fix-delivery are required, file two findings with distinct remediations rather than one dual-owned item.

Known vulnerable dependencies are Supply Chain. A reachable exploit path, missing access boundary, or first-party weakness that uses that dependency is Security, and may cross-reference the Supply Chain finding. File both only when remediations differ (for example upgrade the package versus close the exposure).

## Type Shape

Every type uses the same shape. Purpose is one sentence. A type may add one boundary paragraph that states what is in versus out; omit it when Overlap and Ownership already settles the line. Scope is a flat list of items, each a name and one sentence. Do not group scope into labelled clusters, and do not place a paragraph inside the list.

## Does It Work

### Correctness Review

Purpose: Verify that the subject implements the intended behaviour precisely, including under concurrent and distributed execution.

Concurrent logic that yields a wrong or permanently stuck outcome is Correctness. Correct synchronisation that only limits throughput under load is Performance (Contention and Lock Pressure).

Scope:

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

### Testing Review

Purpose: Evaluate test quality, coverage, and the testability of the subject.

Findings about missing or weak tests, fixtures, isolation, eval harnesses, or testability are Testing. Findings about production behaviour that are not a testability fix belong to the product type (Correctness, Security, Performance, Operability, and so on) even when a test would have caught them.

Scope:

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

## Is It Safe

### Security Review

Purpose: Identify vulnerabilities, security weaknesses, and potential attack vectors.

Scope:

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

### Compliance Review

Purpose: Verify that the subject meets its legal, regulatory, and organisational policy obligations, including the lawful handling of personal data.

Legal, regulatory, industry, and organisational policy obligations are Compliance. Engineering playbooks, idioms, and conventions are Maintainability (Consistency and Conceptual Integrity).

Scope:

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

## Will It Hold Up

### Performance Review

Purpose: Analyse the subject's efficiency and resource usage.

Scope:

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

### Operability Review

Purpose: Assess whether the subject can be run in production, observed while running, kept serving through failure, recovered once state is lost, and operated correctly on its platform.

Scope:

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

## Can We Live With It

### Architecture Review

Purpose: Evaluate system structure, design decisions, component organisation, and whether the shape of the subject fits its stated purpose.

Scope:

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

### Maintainability Review

Purpose: Assess whether the subject can be read, navigated, documented, and changed safely by developers other than its author.

Scope:

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

### Supply Chain Review

Purpose: Review what the subject consumes and what it publishes, from third-party dependencies through build integrity to release.

Scope:

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

## Does It Serve The User

### Experience Review

Purpose: Assess whether the interface the end user or end agent consumes matches its design intent and serves them correctly across channels, states, input methods, and abilities.

Experience covers graphical UI, CLI and TUI, and conversational or agent-facing surfaces. User-facing error copy is Experience (Form and Validation Feedback, Content and Microcopy). Operator-facing runtime errors and recovery paths remain Operability (Error Message Actionability). Durable contributor documentation (README, public API docs, contributor guides, and onboarding) remains Maintainability (External Accuracy, Developer Onboarding).

Scope:

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
