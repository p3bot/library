# Review Types

A structured framework of analysis categories. Each type defines a specific set of concerns used to evaluate the integrity, security, and quality of a subject under review.

## Review Subject

A review type defines what to look for. The subject defines what to look at. The two axes are independent: the invoking task binds a subject, and the type definitions below never assume one.

A subject may be:

- A diff or patch set
- A working tree with uncommitted changes
- A single directory
- A whole repository
- A package or module within a monorepo

Subject granularity affects which types yield signal, not which types apply. An Architecture review is richest over a repository or directory and degenerates over a single-line diff; a Correctness review is sharp at any granularity. Where a scope item must name the thing it examines, it refers to the reviewed subject, never to a fixed target.

## Review Depth

Subject binds what to look at. Types bind what to look for. Depth binds how far down each bound type's scope list to go.

- Survey: One or many types at low depth. Sample for material issues; do not treat every scope item as mandatory.
- Deep: Few types at full depth. Walk the full scope list for each bound type.

The invoking task sets depth. Binding a type is not an order to empty every item on every run. Breadth across types is a depth choice, not a separate review type.

## Review Families

Types are grouped into five families by the question they answer. The family is a navigation aid, not a scoping rule: a review binds types, never families.

| Family | Type | Purpose |
| --- | --- | --- |
| Does It Work | Correctness | Verifying logic matches intended behaviour, including under concurrency |
| | Testing | Evaluating test quality, coverage, and testability |
| Is It Safe | Security | Identifying vulnerabilities and attack vectors |
| | Compliance | Meeting legal, regulatory, and organisational obligations |
| Will It Hold Up | Performance | Analysing efficiency and resource usage |
| | Operability | Running, observing, surviving failure, recovering, and platform fit in production |
| Can We Live With It | Architecture | Evaluating system structure and design decisions |
| | Maintainability | Assessing clarity, consistency, and cost of future change |
| | Supply Chain | Reviewing what the subject consumes and what it publishes |
| Does It Serve The User | Experience | Reviewing interface fidelity, interaction, and reach |

## Severity Rubric

Every finding carries two independent properties: severity (how bad if true) and confidence (how sure it is true). Record both. Neither is a property of the review type.

### Severity

Score severity against these impact dimensions:

- Blast Radius: How many systems, users, or records are affected.
- Trigger Likelihood: How easily the issue can be triggered, intentionally or accidentally.
- Reversibility: How hard recovery is once the issue manifests.
- Data Sensitivity: What classification of data is involved (public, internal, confidential, regulated).
- User Impact: What the affected user experiences.

Severity levels:

- Critical: Broad blast radius, easy to trigger, hard to reverse, or affects regulated/sensitive data. Requires immediate attention.
- High: Material impact on a defined scope, occurs under realistic conditions, or notable user disruption.
- Medium: Limited blast radius or requires specific conditions to trigger. Should be addressed but not blocking.
- Low: Cosmetic, contained, or trivially reversible. Best-effort fix.

### Confidence

- Confirmed: Reproduced, demonstrated with evidence, or proven by inspection of the controlling code path.
- Probable: Strong indications from code or config; not fully reproduced.
- Speculative: Hypothesis or pattern match without direct evidence on this subject.

Do not raise severity to compensate for low confidence, or lower it to compensate for high confidence. A speculative Critical is still Critical in impact if true; it is not yet verified.

## Overlap and Ownership

A finding belongs to the type whose question it answers. When several types could claim it, pick the primary by remediation:

- Stop an attacker or close a weakness: Security
- Meet a legal or organisational obligation: Compliance
- Fix production runtime, observability, or recovery: Operability
- Fix efficiency of the implementation: Performance
- Fix structure or dependency shape: Architecture
- Fix clarity or cost of change: Maintainability
- Fix the test suite or testability: Testing
- Fix logic versus intended behaviour: Correctness
- Fix what is consumed or published: Supply Chain
- Fix the rendered user experience: Experience

Do not file the same issue under two types unless the remediation differs. A secondary type may cross-reference the primary finding instead of duplicating it.

## Does It Work

### Correctness Review

Purpose: Verify that code logic implements the intended behaviour precisely, including under concurrent and distributed execution.

Scope:

- Algorithm Correctness: Verifying that the logic produces the expected output for all valid inputs and maintains logical integrity.
- Business Logic Accuracy: Ensuring the implementation faithfully represents the specified domain rules and stakeholder intentions.
- State Transitions: Assessing how the system moves between states to ensure data remains consistent and the flow is logical.
- Data Transformations: Evaluating the precision of data mapping and conversion logic to prevent loss of fidelity or unintended mutations.
- Operator and Condition Correctness: Reviewing conditional branches, logical operators, and comparison logic for accuracy and exhaustive coverage.
- Boundary and Off-by-one Errors: Identifying logic flaws that occur at the extreme limits of data ranges, loops, and collection indices.
- Order of Operations: Verifying that the sequence of execution and precedence of operations yield the logically sound result.
- Numeric Precision and Overflow: Verifying that numeric types, rounding behaviour, and value ranges preserve accuracy and cannot silently overflow or lose precision.
- Time and Clock Handling: Assessing the handling of time zones, daylight saving transitions, clock skew, and the distinction between wall-clock and monotonic time.
- Absent Value Handling: Verifying that null, empty, zero, and undefined values are distinguished correctly and that absent data cannot cause unsafe dereferences or unchecked conversions.
- Race Conditions: Identifying logic where the outcome depends on the non-deterministic timing of concurrent execution (threads, async tasks, processes, or equivalent local actors).
- Deadlocks and Livelocks: Ensuring that synchronisation logic does not lead to states where the system is permanently stalled.
- Thread Safety and Shared State: Verifying that shared resources are accessed safely, that mutable shared state is minimised, and that remaining shared state is necessary.
- Async Patterns: Evaluating the use of asynchronous primitives to ensure they are handled without blocking or unhandled failures.
- Context and Cancellation: Verifying that operations respect cancellation signals and propagate execution context correctly.
- Resource Pools: Assessing the sizing, lifecycle, and management of thread and connection pools so concurrent use cannot exhaust the pool or leave resources unreleased.
- Distributed Concurrency: Evaluating the correctness of distributed locks, leader election, and consensus mechanisms across networked nodes.
- Event Ordering and Eventual Consistency: Assessing whether the system correctly handles out-of-order events and maintains correctness under eventual consistency models.

### Testing Review

Purpose: Evaluate test quality, coverage, and the testability of production code.

Scope:

- Coverage Depth: Assessing whether tests verify the logic under review across a representative range of scenarios.
- Test Quality: Ensuring tests are readable, maintainable, and verify behaviour rather than implementation details.
- Production Testability: Identifying code structures that make automated testing difficult and suggesting refactors.
- Test Isolation: Verifying that tests do not share state or depend on external environments.
- Flakiness Prevention: Identifying tests that may fail intermittently due to timing or environmental factors.
- Mocking and Stubbing: Evaluating the use of doubles to ensure they are realistic and do not mask actual integration issues.
- Contract Testing: Verifying that service interfaces match consumer expectations and do not break downstream integrations.
- Performance and Load Testing: Assessing whether critical paths are tested under realistic load to identify bottlenecks before production.
- End-to-End Testing: Evaluating coverage of critical user journeys across service boundaries to ensure system-level correctness.
- Chaos Testing: Assessing the use of controlled failure injection to validate system resilience under adverse conditions.
- Security Testing: Assessing coverage of authentication, authorisation, input validation boundaries, and known attack patterns relevant to the reviewed subject.
- Non-Deterministic and Eval Behaviour: Assessing how tests handle non-deterministic model or agent output, including seeds, fixtures, eval harnesses, and tolerance bands that keep signal without masking regressions.

## Is It Safe

### Security Review

Purpose: Identify vulnerabilities, security weaknesses, and potential attack vectors.

Scope is grouped into five clusters. Identity and access covers who can act. Secrets and data covers credentials and protected information. Request and surface covers input and exposure paths. Agent and model covers LLM and tool-using systems. Integrity and audit covers check-then-act races and forensic record.

Identity and access:

- Authentication and Authorisation: Verifying the integrity of identity verification and the strict enforcement of access boundaries across all layers.
- Session Management: Reviewing the lifecycle and security properties of user sessions and tokens to prevent hijacking or unauthorised reuse.
- Privilege Escalation: Analysing logic for flaws that could allow a user to perform actions beyond their intended permission level.
- Insecure Direct Object References: Verifying that access to resources by identifier enforces authorisation checks rather than relying on obscurity.
- Tenant Isolation: Verifying that data stores, caches, queues, background jobs, and search indices enforce tenant boundaries so no request can reach another tenant's records.

Secrets and data:

- Secrets Management: Confirming that sensitive credentials are stored, accessed, rotated, and audited safely through externalised mechanisms. Runtime handling lives here; full revision history is Secrets in Version Control History; delivery into the running process is Operability Secret and Configuration Injection.
- Secrets in Version Control History: Verifying secrets are absent from the full revision history (not only the current tree), and that any past exposure has been rotated and purged or otherwise rendered unusable.
- Data Protection and Encryption: Assessing the safety of sensitive information at rest and in transit, including the prevention of data leakage in logs.
- Cryptography Usage: Evaluating the implementation of cryptographic primitives to ensure the use of proven, industry-standard protocols.

Request and surface:

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

Agent and model:

- Prompt Injection and Untrusted Content: Verifying that untrusted content cannot override system instructions, exfiltrate secrets, or redirect tool use when incorporated into model prompts or agent context.
- Tool and Agent Permission Scope: Verifying that tools, functions, and side-effecting actions available to a model or agent are least-privilege, explicitly granted, and cannot be expanded by untrusted input.
- Model Output Validation: Ensuring model or agent output is validated, sandboxed, or human-gated before it drives side effects such as code execution, data mutation, or external requests.

Integrity and audit:

- Time-of-Check to Time-of-Use: Identifying races where a permission, existence, or integrity check is separated from use so an attacker can change the resource in the gap.
- Audit Trail: Confirming that security-relevant events are captured completely and stored with tamper-resistance and retention sufficient for forensic analysis and compliance requirements.

### Compliance Review

Purpose: Verify that the subject meets its legal, regulatory, and organisational obligations, including the lawful handling of personal data.

Scope:

- Regulatory Compliance: Assessing adherence to legal and data privacy frameworks such as GDPR or HIPAA where applicable.
- Industry Standards: Verifying compliance with domain-specific protocols relevant to the project's industry.
- Organisational Standards: Ensuring alignment with internal engineering playbooks and agreed-upon conventions.
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

Purpose: Analyse code efficiency and resource usage.

Scope:

- Algorithmic Complexity: Identifying logic with sub-optimal complexity that could degrade as input size grows.
- Memory Management: Assessing allocation patterns to minimise unnecessary allocator, heap, or garbage-collector pressure and to stay within memory limits.
- I/O Efficiency: Evaluating the frequency and size of network and disk operations to minimise latency.
- Database Efficiency: Identifying N+1 query patterns or expensive join operations that impact system throughput.
- Contention and Lock Pressure: Identifying synchronisation points that limit throughput under concurrent load.
- Resource Lifecycles: Ensuring that connections, file handles, and other finite resources are closed promptly.
- Caching Strategy: Identifying opportunities to reuse expensive computations while ensuring invalidation is sound.
- Cold Start and Warm-up: Evaluating initialisation latency in serverless or JIT-compiled environments and strategies to mitigate it.
- Token and Context Budget: Assessing prompt size, context window use, retrieval volume, and model-call batching so cost and latency stay within budget as input and history grow.
- Infrastructure Impact: Assessing whether the code's runtime behaviour drives excessive compute, network, or storage consumption relative to the value delivered.
- Performance Instrumentation: Ensuring critical paths emit metrics that allow performance regressions to be detected in production.

### Operability Review

Purpose: Assess whether the subject can be run in production, observed while running, kept serving through failure, recovered once state is lost, and operated correctly on its platform.

Scope is grouped into four clusters. Failure handling covers the code path, telemetry covers visibility, recovery covers durability of state, and environment covers the platform the subject runs on.

Failure handling:

- Error Handling and Propagation: Ensuring errors are caught at the appropriate level and not swallowed without logging; that context is preserved as errors move through the system; and that unexpected inputs and unhandled failures cannot crash the process without a controlled path.
- Sensitive Data in Errors: Ensuring error messages, stack traces, and failure responses do not expose secrets, internal structure, or PII to clients.
- Error Message Actionability: Verifying that user-facing and operator-facing error messages state what failed and what to do next, without relying on internal knowledge and without exposing secrets, internal structure, or PII.
- Graceful Degradation: Assessing how the system behaves when a dependency or non-critical component fails.
- Retry and Fallbacks: Evaluating call-site retry behaviour, including backoff strategy, jitter, retry budgets, and the safety of repeated invocation.
- Timeout Strategy: Verifying that call sites define appropriate timeout values and that those values are propagated correctly across service boundaries.
- Backpressure Handling: Assessing how call sites signal upstream producers to slow down when downstream capacity is exceeded.
- Fail-Fast vs Fail-Safe: Verifying that the system chooses the appropriate failure mode for the specific context.
- Failure Isolation and Containment: Verifying that fault tolerance mechanisms such as circuit breakers, bulkheads, and infrastructure partitioning keep a fault, misconfiguration, or failed deployment contained rather than cascading.
- Idempotency: Verifying that operations can be safely retried without producing unintended side effects or duplicate outcomes.

Telemetry:

- Logging Quality: Ensuring logs provide rich context, correct severity levels, structured machine-parseable format, and a strong signal-to-noise ratio for incident response.
- System Metrics: Verifying that critical performance and health indicators are instrumented in a structured, machine-parseable form for monitoring.
- Distributed Tracing: Assessing the propagation of trace identifiers to allow for visualisation of requests across services.
- Telemetry Cardinality, Volume, and Cost: Assessing metric cardinality, log and trace volume, and retention windows so observability cost and backend load stay controlled without discarding data needed for incident response and compliance.
- Health Checks: Ensuring the system exposes accurate readiness and liveness signals for orchestration.
- Alerting Strategy: Evaluating alert threshold configuration, signal-to-noise ratio, and escalation paths to ensure actionable notifications.
- SLO and SLI Tracking: Verifying that reliability targets are defined, measured, and surfaced to support error budget decisions.

Recovery:

- Backup Coverage and Restore Verification: Confirming that every durable data store is backed up and that restores are exercised rather than assumed to work.
- Recovery Objectives: Verifying that tolerated data loss and time to restore service are defined, measurable, and matched by the mechanisms actually in place.
- Point-in-Time and Data Rollback: Assessing the ability to return data to a known-good state, including recovery from a destructive migration or a bad write.
- Backup Isolation and Immutability: Ensuring backups survive the failure that destroys the primary by residing outside its blast radius and resisting deletion or encryption.
- Corruption Detection and Reconciliation: Verifying that silent data corruption and divergence between stores are detected and reconciled rather than discovered by users.
- Operational Runbooks: Ensuring that failure scenarios have documented response procedures for operational teams.

Environment:

- Resource Provisioning: Verifying that infrastructure resources are defined declaratively and that provisioning logic is idempotent.
- Infrastructure State Management: Assessing how infrastructure state is stored, shared, and protected from corruption or conflicts.
- Drift Detection: Ensuring mechanisms exist to identify and reconcile differences between declared and actual infrastructure state.
- Network Policy and Segmentation: Reviewing network rules to ensure services are isolated appropriately and follow least-privilege access.
- Cost Attribution and Right-Sizing: Assessing whether provisioned resources are appropriately sized for their workload and tagged for cost tracking.
- Capacity, Quotas, and Limits: Verifying that throughput, storage, concurrency, and tenant quotas are defined and enforced, and that capacity is planned with measurable headroom rather than discovered at the failure point.
- Environment Reproducibility: Verifying that environments can be reliably recreated from their definitions without manual intervention.
- Deployment and Rollback Safety: Ensuring that deployment processes support safe rollback and that environment parity is maintained across stages.
- Secret and Configuration Injection: Ensuring that runtime secrets and configuration are delivered through secure, auditable channels rather than embedded in IaC definitions, baked into images, or stored in plaintext environment files.

## Can We Live With It

### Architecture Review

Purpose: Evaluate system structure, design decisions, component organisation, and whether the shape of the subject fits its stated purpose.

Scope:

- Solution Fit: High-level verification that the implementation aligns with the subject's stated purpose and architectural manifest.
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
- Data Partitioning: Reviewing sharding strategies and partition key selection to avoid hot spots and ensure balanced distribution.
- Database Integrity: Verifying that schema changes maintain data consistency and handle migrations safely.
- Scalability and Extensibility: Assessing whether the design accommodates growth in data volume or future requirements without requiring a rewrite.
- Tech Stack Coherence: Identifying library sprawl or conflicting tool choices that complicate the strategic technical direction.

### Maintainability Review

Purpose: Assess whether the subject can be read, navigated, documented, and changed safely by developers other than its author.

Scope:

- Naming Intent: Verifying that names for variables, functions, and classes reveal their purpose and the reason for their existence.
- Cognitive Complexity: Identifying logic that is too dense or requires excessive mental effort to parse.
- Expressiveness: Assessing whether the code uses language features that clearly communicate the developer's intent.
- Comment Utility: Ensuring comments are used to explain non-obvious decisions rather than restating the code.
- Code Flow: Assessing the narrative of the code to ensure the most important logic is prominent.
- Consistency and Conceptual Integrity: Verifying the subject follows established local idioms and reads as one coherent design rather than a patchwork of conflicting styles.
- Cognitive Profile: Assessing whether the overall solution complexity is proportionate to the problem domain being solved.
- Duplication and Redundancy: Identifying repeated logic, structural patterns, and boilerplate that should be centralised or simplified — without forcing premature generalisation.
- Codebase Atrophy: Detecting signs of large-scale rot, such as abandoned modules, ghost directories, or obsolete features.
- Dead Code and Unused Surface: Identifying unreachable branches, unused exports, commented-out blocks, and stale feature flags that have outlived their purpose.
- External Accuracy: Ensuring that the README, public API docs, and help guides reflect the actual state of the code.
- Developer Onboarding: Verifying that instructions for building, testing, and running the code remain clear.
- Decision Records: Ensuring that significant design decisions and their rationale are captured in a durable form for future contributors.
- Change Transparency: Assessing whether the changelog accurately describes the impact of the changes for users.

### Supply Chain Review

Purpose: Review what the subject consumes and what it publishes, from third-party dependencies through build integrity to release.

Scope is grouped into two clusters. Dependencies covers what the subject consumes. Build and release covers how it is built, attested, and published.

Dependencies:

- Justification: Evaluating whether a new dependency is necessary or if the problem could be solved with existing tools.
- Maintenance and Health: Assessing the activity level, security history, and community support of external libraries.
- Dependency Vulnerabilities: Identifying third-party packages with known CVEs or unpatched security issues present in the reviewed subject.
- Licence Compatibility: Verifying that each dependency's licence is compatible with the subject's own licence and distribution model.
- Supply Chain Risk: Assessing the trustworthiness of the dependency chain, including transitive dependencies, ownership changes, and typosquatting indicators.
- Asset Impact: Evaluating the effect of the dependency on bundle sizes, startup times, or deployment complexity.

Build and release:

- First-Party Licensing and Attribution: Verifying that the subject declares its own licence correctly and that copied or vendored code carries the attribution its licence requires.
- Project Hygiene: Checking for the presence and consistency of top-level configuration, build tooling, and environment setup.
- Build Reproducibility: Assessing whether builds produce consistent artefacts from the same source without depending on ambient machine state.
- Artefact Provenance: Verifying that published artefacts are signed, traceable to the source revision that produced them, and accompanied by an inventory of their materials.
- Pipeline Security: Identifying risks in the build pipeline itself, including untrusted trigger paths, secret exposure to forks, and over-privileged runner credentials.
- Release and Deprecation Policy: Assessing whether versioning, deprecation windows, and migration guidance allow consumers to upgrade predictably.

## Does It Serve The User

### Experience Review

Purpose: Assess whether a rendered user interface matches its design intent and serves users correctly across viewports, input methods, states, and abilities.

Scope:

- Visual Fidelity: Assessing whether the rendered output aligns with the design specifications across various viewports.
- Responsive Behaviour: Verifying that the interface adapts correctly to different screen sizes and platform constraints.
- Interaction States: Reviewing the behaviour and visual feedback of elements during user engagement.
- State Coverage: Verifying that loading, empty, partial, and error states are deliberately designed and reachable rather than left to default behaviour.
- Accessibility (WCAG/ARIA): Ensuring the implementation is usable by individuals with diverse needs and complies with established standards.
- Keyboard and Focus Management: Ensuring the interface is fully operable without a pointer and that focus order and visibility follow the user's task.
- Form and Validation Feedback: Assessing whether input requirements, validation timing, and error recovery guide the user toward a successful outcome.
- Content and Microcopy: Verifying that labels, messages, and instructions are accurate, consistent in voice, and comprehensible without internal knowledge.
- Internationalisation (i18n): Verifying that the code is prepared for localisation, handling diverse languages and cultural formats.
- Theming and Visual Preferences: Ensuring the interface honours user preferences such as colour scheme, contrast, and reduced motion.
- Perceived Performance: Assessing responsiveness as experienced by the user, including layout stability and feedback during long-running operations.
