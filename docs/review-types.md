# Review Types

A structured framework of analysis categories. Each type defines a specific scope used to evaluate the integrity, security, and quality of the codebase.

## Summary

| Type | Purpose |
| --- | --- |
| Holistic | Surveying the repository at a high level across all dimensions |
| Security | Identifying vulnerabilities and security concerns |
| Correctness | Verifying code logic matches intended behaviour |
| Architecture | Evaluating system structure and design decisions |
| Concurrency | Identifying threading and parallelism issues |
| Standards | Checking compliance with applicable standards |
| Privacy | Protecting personal data and meeting privacy obligations |
| Observability | Assessing logging, metrics, and debuggability |
| Performance | Analysing efficiency and resource usage |
| Error Handling | Reviewing failure handling and edge cases |
| Testing | Evaluating test quality and coverage |
| Readability | Assessing code clarity and understandability |
| Dependency | Reviewing third-party package usage |
| Infrastructure | Evaluating provisioning, IaC, and environment management |
| Duplication | Finding repeated code patterns |
| Documentation | Reviewing external documentation and API docs |

## Severity Rubric

Severity is a property of each finding, not of the review type. Score each finding against these impact dimensions:

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

## Review Types

### 1. Holistic Review

Purpose: Assess the overall structural health, consistency, and developer experience of the repository as a complete entity.

Scope:

- Conceptual Integrity: Verifying the codebase feels written by one mind with consistent patterns rather than a patchwork of conflicting styles.
- Repository Structure: Assessing if the file layout and directory organisation are intuitive and self-explanatory.
- Solution Fit: High-level verification that the implementation aligns with the repository's stated purpose and architectural manifest.
- Tech Stack Coherence: Identifying library sprawl or conflicting tool choices that complicate the strategic technical direction.
- Project Hygiene: Checking for the presence and consistency of top-level configuration, CI/CD health, and environment setup.
- Codebase Atrophy: Detecting signs of large-scale rot, such as abandoned modules, ghost directories, or obsolete features.
- Cognitive Profile: Assessing if the overall solution complexity is proportionate to the problem domain being solved.

### 2. Security Review

Purpose: Identify vulnerabilities, security weaknesses, and potential attack vectors.

Scope:

- Authentication and Authorisation: Verifying the integrity of identity verification and the strict enforcement of access boundaries across all layers.
- Input Validation and Sanitisation: Ensuring all untrusted data is validated and cleaned to prevent injection and manipulation attacks.
- Secrets Management: Confirming that sensitive credentials are stored, accessed, rotated, and audited safely through externalised mechanisms.
- Data Protection and Encryption: Assessing the safety of sensitive information at rest and in transit, including the prevention of data leakage in logs.
- Cryptography Usage: Evaluating the implementation of cryptographic primitives to ensure the use of proven, industry-standard protocols.
- Session Management: Reviewing the lifecycle and security properties of user sessions and tokens to prevent hijacking or unauthorised reuse.
- API Security: Identifying risks in endpoint design, including improper resource exposure or excessive data return.
- CORS and CSRF Protection: Verifying that cross-origin policies and request forgery protections are correctly configured.
- Rate Limiting: Assessing the system's resilience against automated abuse, brute-force attempts, and resource exhaustion.
- Secure Headers: Confirming the presence of security-related HTTP headers that harden the client-side execution environment.
- Path Traversal: Ensuring that file and resource pathing logic cannot be manipulated to access restricted areas.
- Server-Side Request Forgery: Ensuring server-side requests cannot be manipulated to access internal resources or unintended external targets.
- Insecure Direct Object References: Verifying that access to resources by identifier enforces authorisation checks rather than relying on obscurity.
- Mass Assignment: Verifying that object binding from external input does not allow modification of unintended fields or properties.
- File Upload Security: Ensuring uploaded files are validated for content type, scanned for malicious content, and stored in isolated locations.
- Deserialisation Safety: Verifying that the conversion of data formats into objects does not introduce execution risks.
- Privilege Escalation: Analysing logic for flaws that could allow a user to perform actions beyond their intended permission level.
- Audit Trail: Confirming that security-relevant events are captured completely and stored with tamper-resistance and retention sufficient for forensic analysis and compliance requirements.
- Dependency Vulnerabilities: Identifying third-party packages with known CVEs or unpatched security issues that the change introduces or relies on.

### 3. Correctness Review

Purpose: Verify that code logic correctly implements the intended behaviour and handles data with precision.

Scope:

- Algorithm Correctness: Verifying that the logic produces the expected output for all valid inputs and maintains logical integrity.
- Business Logic Accuracy: Ensuring the implementation faithfully represents the specified domain rules and stakeholder intentions.
- State Transitions: Assessing how the system moves between states to ensure data remains consistent and the flow is logical.
- Data Transformations: Evaluating the precision of data mapping and conversion logic to prevent loss of fidelity or unintended mutations.
- Operator and Condition Correctness: Reviewing conditional branches, logical operators, and comparison logic for accuracy and exhaustive coverage.
- Boundary and Off-by-one Errors: Identifying logic flaws that occur at the extreme limits of data ranges, loops, and collection indices.
- Order of Operations: Verifying that the sequence of execution and precedence of operations yield the logically sound result.
- Visual Fidelity (UI): Assessing whether the rendered output aligns with the design specifications across various viewports.
- Responsive Behaviour (UI): Verifying that the interface adapts correctly to different screen sizes and platform constraints.
- Interaction States (UI): Reviewing the behaviour and visual feedback of elements during user engagement.

### 4. Architecture Review

Purpose: Evaluate system structure, design decisions, and component organisation.

Scope:

- System Design and Layering: Ensuring clear separation of concerns where each layer has a distinct responsibility and avoids leaky abstractions.
- Component Boundaries: Verifying that interactions between modules are well-defined and do not violate the principle of least knowledge.
- Dependency Flow: Assessing the direction of dependencies to ensure high-level policy is protected from implementation details.
- Modularity and Reusability: Identifying opportunities for abstraction that reduce coupling while avoiding premature generalisation.
- API Design and Contracts: Evaluating the stability and clarity of interfaces to ensure they are difficult to misuse.
- Backwards Compatibility: Ensuring changes do not break existing integrations, data formats, or downstream expectations.
- Configuration Management: Verifying that non-secret runtime configuration (feature flags, tunables, environment-specific settings) can adjust system behaviour safely through structured mechanisms without code changes.
- Failure Isolation: Verifying structural fault tolerance mechanisms such as circuit breakers, bulkheads, and boundary placement to ensure components fail independently without cascading.
- Idempotency: Verifying that operations can be safely retried without producing unintended side effects or duplicate outcomes.
- Event-Driven Architecture: Assessing message ordering guarantees, schema evolution strategies, and dead letter handling in asynchronous systems.
- Data Partitioning: Reviewing sharding strategies and partition key selection to avoid hot spots and ensure balanced distribution.
- Deployment and Rollback Safety: Ensuring that deployment processes support safe rollback and that environment parity is maintained across stages.
- Scalability and Extensibility: Assessing if the design accommodates growth in data volume or future requirements without requiring a rewrite.
- Database Integrity: Verifying that schema changes maintain data consistency and handle migrations safely.

### 5. Concurrency Review

Purpose: Identify threading, parallelism, and asynchronous execution issues.

Scope:

- Race Conditions: Identifying logic where the outcome depends on the non-deterministic timing of execution across multiple threads.
- Deadlocks and Livelocks: Ensuring that synchronisation logic does not lead to states where the system is permanently stalled.
- Thread Safety: Verifying that shared resources are accessed through safe mechanisms that prevent data corruption.
- Shared State Management: Assessing the necessity of shared state and ensuring that mutable data is minimised.
- Async Patterns: Evaluating the use of asynchronous primitives to ensure they are handled without blocking or unhandled failures.
- Context and Cancellation: Verifying that operations respect cancellation signals and propagate execution context correctly.
- Resource Pools: Assessing the sizing and management of thread and connection pools to prevent exhaustion and support expected throughput.
- Distributed Concurrency: Evaluating the correctness of distributed locks, leader election, and consensus mechanisms across networked nodes.
- Event Ordering and Eventual Consistency: Assessing whether the system correctly handles out-of-order events and maintains correctness under eventual consistency models.

### 6. Standards Review

Purpose: Verify changes meet applicable domain-specific standards and requirements.

Scope:

- Accessibility (WCAG/ARIA): Ensuring the implementation is usable by individuals with diverse needs and complies with established standards.
- Internationalisation (i18n): Verifying that the code is prepared for localisation, handling diverse languages and cultural formats.
- Regulatory Compliance: Assessing adherence to legal and data privacy frameworks such as GDPR or HIPAA where applicable.
- Industry Standards: Verifying compliance with domain-specific protocols relevant to the project's industry.
- Organisational Standards: Ensuring the change aligns with internal engineering playbooks and agreed-upon conventions.

### 7. Privacy Review

Purpose: Verify that personal data is collected, processed, retained, shared, and erased in accordance with privacy principles and applicable regulations.

Scope:

- Data Classification: Ensuring that data is categorised by sensitivity level, including explicit recognition of personal data, and that handling procedures match the classification.
- Lawful Basis and Consent: Confirming that personal data processing has a documented lawful basis and that consent, where required, is captured, scoped, and revocable.
- Data Minimisation: Verifying that only the data necessary for the stated purpose is collected and retained.
- Purpose Limitation: Ensuring data collected for one purpose is not silently reused for another without re-establishing lawful basis.
- Retention and Deletion: Verifying that personal data has defined retention periods and that deletion, including right-to-be-forgotten requests, is implemented end-to-end across stores and backups.
- Data Subject Rights: Verifying that mechanisms exist to satisfy access, rectification, portability, restriction, and objection requests across all stores holding personal data, with response paths that are testable, auditable, and complete.
- Anonymisation and Pseudonymisation: Assessing whether identity protection techniques applied to personal data match the asserted classification, distinguishing irreversible anonymisation from pseudonymisation that retains a re-identification path, and verifying that re-identification risk is bounded under realistic linkage.
- Automated Decision-Making and Profiling: Assessing whether profiling or automated decisions producing legal or significant effects on individuals are identified, documented, and accompanied by safeguards such as human review, contestability, and explanation paths.
- Third-Party Data Sharing: Reviewing what personal data is shared with external services and whether processor agreements and data flows are documented.
- Telemetry and Diagnostic Surfaces: Verifying that logs, metrics, traces, product analytics events, and error reports do not capture personal data without lawful basis, and that identifiers traversing those surfaces are redacted, hashed, or pseudonymised in line with the data classification.
- Cross-Border Data Transfer: Verifying compliance with jurisdictional requirements for data movement across geographic boundaries.

### 8. Observability Review

Purpose: Assess whether the code can be understood, debugged, and measured in production, covering both operational telemetry and business telemetry.

Scope:

- Logging Quality: Ensuring logs provide rich context, correct severity levels, structured format for parsing, and a strong signal-to-noise ratio to facilitate incident response.
- System Metrics: Verifying that critical performance and health indicators are instrumented for monitoring.
- Product Analytics: Confirming that user interaction events are captured accurately to inform business decisions.
- Distributed Tracing: Assessing the propagation of trace identifiers to allow for visualisation of requests across services.
- Structured Output: Verifying that telemetry data is emitted in a format that is easily parsed by analysis tools.
- Health Checks: Ensuring the system exposes accurate readiness and liveness signals for orchestration.
- Alerting Strategy: Evaluating alert threshold configuration, noise-to-signal ratio, and escalation paths to ensure actionable notifications.
- SLO and SLI Tracking: Verifying that reliability targets are defined, measured, and surfaced to support error budget decisions.

### 9. Performance Review

Purpose: Analyse code efficiency and resource usage.

Scope:

- Algorithmic Complexity: Identifying logic with sub-optimal complexity that could degrade as input size grows.
- Memory Management: Assessing allocation patterns to minimise unnecessary pressure on the garbage collector or memory limits.
- I/O Efficiency: Evaluating the frequency and size of network and disk operations to minimise latency.
- Database Efficiency: Identifying N+1 query patterns or expensive join operations that impact system throughput.
- Contention and Lock Pressure: Identifying synchronisation points that limit throughput under concurrent load.
- Resource Lifecycles: Ensuring that connections, file handles, and other finite resources are closed promptly.
- Caching Strategy: Identifying opportunities to reuse expensive computations while ensuring invalidation is sound.
- Cold Start and Warm-up: Evaluating initialisation latency in serverless or JIT-compiled environments and strategies to mitigate it.
- Infrastructure Impact: Assessing whether the code's runtime behaviour drives excessive compute, network, or storage consumption relative to the value delivered.
- Performance Instrumentation: Ensuring critical paths emit metrics that allow performance regressions to be detected in production.

### 10. Error Handling Review

Purpose: Review how failures are handled and whether edge cases are covered.

Scope:

- Exception Strategy: Ensuring that errors are caught at the appropriate level and not swallowed without logging.
- Error Propagation: Verifying that error context is preserved as it moves through the system to aid root cause analysis.
- Sensitive Data in Errors: Ensuring error messages, stack traces, and failure responses do not expose secrets, internal structure, or PII to clients.
- Graceful Degradation: Assessing how the system behaves when a dependency or non-critical component fails.
- Edge Case Coverage: Identifying unhappy paths and unexpected inputs that could cause the system to crash.
- Retry and Fallbacks: Evaluating call-site retry behaviour, including backoff strategy, jitter, retry budgets, and the safety of repeated invocation.
- Timeout Strategy: Verifying that call sites define appropriate timeout values and that those values are propagated correctly across service boundaries.
- Backpressure Handling: Assessing how call sites signal upstream producers to slow down when downstream capacity is exceeded.
- Fail-Fast vs Fail-Safe: Verifying that the system chooses the appropriate failure mode for the specific context.

### 11. Testing Review

Purpose: Evaluate test quality, coverage, and the testability of production code.

Scope:

- Coverage Depth: Assessing whether tests verify the logic of the change across a representative range of scenarios.
- Test Quality: Ensuring tests are readable, maintainable, and verify behaviour rather than implementation details.
- Production Testability: Identifying code structures that make automated testing difficult and suggesting refactors.
- Test Isolation: Verifying that tests do not share state or depend on external environments.
- Flakiness Prevention: Identifying tests that may fail intermittently due to timing or environmental factors.
- Mocking and Stubbing: Evaluating the use of doubles to ensure they are realistic and do not mask actual integration issues.
- Contract Testing: Verifying that service interfaces match consumer expectations and that changes do not break downstream integrations.
- Performance and Load Testing: Assessing whether critical paths are tested under realistic load to identify bottlenecks before production.
- End-to-End Testing: Evaluating coverage of critical user journeys across service boundaries to ensure system-level correctness.
- Chaos Testing: Assessing the use of controlled failure injection to validate system resilience under adverse conditions.
- Security Testing: Coverage of authentication, authorisation, input validation boundaries, and known attack patterns relevant to the change.

### 12. Readability Review

Purpose: Assess whether the code is clear and understandable to other developers.

Scope:

- Naming Intent: Verifying that names for variables, functions, and classes reveal their purpose and the reason for their existence.
- Cognitive Complexity: Identifying logic that is too dense or requires excessive mental effort to parse.
- Expressiveness: Assessing whether the code uses language features that clearly communicate the developer's intent.
- Comment Utility: Ensuring comments are used to explain non-obvious decisions rather than restating the code.
- Pattern Consistency: Verifying that the change follows established idioms within the codebase to reduce the learning curve.
- Code Flow: Assessing the narrative of the code to ensure the most important logic is prominent.

### 13. Dependency Review

Purpose: Review the use of third-party packages and libraries.

Scope:

- Justification: Evaluating whether a new dependency is necessary or if the problem could be solved with existing tools.
- Maintenance and Health: Assessing the activity level, security history, and community support of external libraries.
- License and Security: Verifying that the dependency's license is compatible and checking for known vulnerabilities.
- Supply Chain Risk: Assessing the trustworthiness of the dependency chain, including transitive dependencies, ownership changes, typosquatting indicators, and the integrity of the publishing pipeline.
- Asset Impact: Evaluating the effect of the dependency on bundle sizes, startup times, or deployment complexity.

### 14. Infrastructure Review

Purpose: Evaluate the quality and safety of infrastructure definitions, provisioning logic, and environment management.

Scope:

- Resource Provisioning: Verifying that infrastructure resources are defined declaratively and that provisioning logic is idempotent.
- State Management: Assessing how infrastructure state is stored, shared, and protected from corruption or conflicts.
- Drift Detection: Ensuring mechanisms exist to identify and reconcile differences between declared and actual infrastructure state.
- Blast Radius: Evaluating whether changes are scoped to minimise the impact of a misconfiguration or failed deployment.
- Network Policy and Segmentation: Reviewing network rules to ensure services are isolated appropriately and follow least-privilege access.
- Cost Attribution and Right-Sizing: Assessing whether provisioned resources are appropriately sized for their workload and tagged for cost tracking.
- Environment Reproducibility: Verifying that environments can be reliably recreated from their definitions without manual intervention.
- Secret and Configuration Injection: Ensuring that runtime secrets and configuration are delivered through secure, auditable channels rather than embedded in IaC definitions, baked into images, or stored in plaintext environment files.

### 15. Duplication Review

Purpose: Identify repeated code patterns that may benefit from consolidation.

Scope:

- Functional Duplication: Identifying similar logic performed in multiple places that should be centralised.
- Pattern Redundancy: Recognising repeated structural patterns that suggest a missing abstraction.
- Boilerplate Reduction: Assessing if the change introduces repetitive code that could be simplified through better design.

### 16. Documentation Review

Purpose: Review external documentation, API documentation, and developer guides.

Scope:

- External Accuracy: Ensuring that the README, public API docs, and help guides reflect the actual state of the code.
- Developer Onboarding: Verifying that instructions for building, testing, and running the code remain clear.
- Decision Records: Ensuring that significant design decisions and their rationale are captured in a durable form for future contributors.
- Change Transparency: Assessing if the changelog accurately describes the impact of the changes for users.
- Operational Runbooks: Ensuring that failure scenarios have documented response procedures for operational teams.
