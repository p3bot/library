# Git Diff Code Review

Comprehensive review of code changes from git diff output. Focuses on whether the changes are a solid improvement to the codebase without introducing regressions or bugs.

This is not a general-purpose repository review. The diff output is the guide -- only review the changed code and its immediate context.

## Prerequisites

- A Git repository with code changes

## Workflow

1. Run git status to confirm we are in a Git repository and determine the state of changes (staged, unstaged, or both)
2. Use the diff they named. If they did not name one, pick the command that matches the working tree:
   - `git diff` for unstaged only
   - `git diff --staged` for staged only
   - `git diff HEAD` for both
   - `git diff <default>..HEAD` for changes since a branch point
3. Run the diff command and read the output to understand the scope and intent of the changes
4. For each changed file, read the full file and related files to understand surrounding context
5. Review the changes against all criteria below
6. Produce a structured report of findings and present it inline. Save only if the user asked, or if they instructed this run to proceed without intervention. Use the path they gave. If they asked to save but named no path, ask. If they instructed this run to proceed without intervention and named no path, write to `.start/reviews/YYYY-MM-DD-git-diff-NN.md` (`NN` starts at `01`, incrementing against existing files matching the date and type)

## Reviewer Guidance

- The diff is your primary input -- stay focused on what changed
- Read surrounding code in changed files to understand context
- Distinguish between new issues introduced by the diff and pre-existing issues
- Flag pre-existing issues if discovered
- Ask clarifying questions when the intent of a change is unclear
- Reference the specific file and change from the diff in each finding
- Classify findings by severity (critical, high, medium, low, info):
  - Not every review category will produce findings at every severity level
  - Use the levels that fit rather than forcing findings into categories that do not apply
- Write "None" for any severity level where no findings exist. Every section must be present in the report
- It is acceptable to find no issues. If the changes are well-implemented, say so. Do not manufacture findings to justify the review

## 1. Holistic Review

- Conceptual Integrity: Verifying the codebase feels written by one mind with consistent patterns rather than a patchwork of conflicting styles
- Repository Structure: Assessing if the file layout and directory organization are intuitive and self-explanatory
- Solution Fit: High-level verification that the implementation aligns with the repository's stated purpose and architectural manifest
- Tech Stack Coherence: Identifying library sprawl or conflicting tool choices that complicate the strategic technical direction
- Project Hygiene: Checking for the presence and consistency of top-level configuration, CI/CD health, and environment setup
- Codebase Atrophy: Detecting signs of large-scale rot, such as abandoned modules, ghost directories, or obsolete features
- Cognitive Profile: Assessing if the overall solution complexity is proportionate to the problem domain being solved

## 2. Security Review

- Authentication and Authorisation: Verifying the integrity of identity verification and the strict enforcement of access boundaries across all layers
- Input Validation and Sanitisation: Ensuring all untrusted data is validated and cleaned to prevent injection and manipulation attacks
- Secrets Management: Confirming that sensitive credentials and configuration data are handled via secure, externalized mechanisms
- Data Protection and Encryption: Assessing the safety of sensitive information at rest and in transit, including the prevention of data leakage in logs
- Cryptography Usage: Evaluating the implementation of cryptographic primitives to ensure the use of proven, industry-standard protocols
- Session Management: Reviewing the lifecycle and security properties of user sessions and tokens to prevent hijacking or unauthorized reuse
- API Security: Identifying risks in endpoint design, including improper resource exposure or excessive data return
- CORS and CSRF Protection: Verifying that cross-origin policies and request forgery protections are correctly configured
- Rate Limiting: Assessing the system's resilience against automated abuse, brute-force attempts, and resource exhaustion
- Secure Headers: Confirming the presence of security-related HTTP headers that harden the client-side execution environment
- Path Traversal: Ensuring that file and resource pathing logic cannot be manipulated to access restricted areas
- Deserialization Safety: Verifying that the conversion of data formats into objects does not introduce execution risks
- Privilege Escalation: Analyzing logic for flaws that could allow a user to perform actions beyond their intended permission level

## 3. Correctness Review

- Algorithm Correctness: Verifying that the logic produces the expected output for all valid inputs and maintains logical integrity
- Business Logic Accuracy: Ensuring the implementation faithfully represents the specified domain rules and stakeholder intentions
- State Transitions: Assessing how the system moves between states to ensure data remains consistent and the flow is logical
- Data Transformations: Evaluating the precision of data mapping and conversion logic to prevent loss of fidelity or unintended mutations
- Operator and Condition Correctness: Reviewing conditional branches, logical operators, and comparison logic for accuracy and exhaustive coverage
- Boundary and Off-by-one Errors: Identifying logic flaws that occur at the extreme limits of data ranges, loops, and collection indices
- Order of Operations: Verifying that the sequence of execution and precedence of operations yield the logically sound result
- Visual Fidelity (UI): Assessing whether the rendered output aligns with the design specifications across various viewports
- Responsive Behaviour (UI): Verifying that the interface adapts correctly to different screen sizes and platform constraints
- Interaction States: Reviewing the behavior and visual feedback of elements during user engagement

## 4. Architecture Review

- System Design and Layering: Ensuring clear separation of concerns where each layer has a distinct responsibility and avoids leaky abstractions
- Component Boundaries: Verifying that interactions between modules are well-defined and do not violate the principle of least knowledge
- Dependency Flow: Assessing the direction of dependencies to ensure high-level policy is protected from implementation details
- Modularity and Reusability: Identifying opportunities for abstraction that reduce coupling while avoiding premature generalization
- API Design and Contracts: Evaluating the stability and clarity of interfaces to ensure they are difficult to misuse
- Backwards Compatibility: Ensuring changes do not break existing integrations, data formats, or downstream expectations
- Configuration Management: Verifying that system behavior can be adjusted safely through structured configuration without code changes
- Rollout Strategy: Reviewing how features are exposed to allow for safe deployment and incremental validation
- Scalability and Extensibility: Assessing if the design accommodates growth in data volume or future requirements without requiring a rewrite
- Database Integrity: Verifying that schema changes maintain data consistency and handle migrations safely

## 5. Concurrency Review

- Race Conditions: Identifying logic where the outcome depends on the non-deterministic timing of execution across multiple threads
- Deadlocks and Livelocks: Ensuring that synchronization logic does not lead to states where the system is permanently stalled
- Thread Safety: Verifying that shared resources are accessed through safe mechanisms that prevent data corruption
- Shared State Management: Assessing the necessity of shared state and ensuring that mutable data is minimized
- Async Patterns: Evaluating the use of asynchronous primitives to ensure they are handled without blocking or unhandled failures
- Context and Cancellation: Verifying that operations respect cancellation signals and propagate execution context correctly
- Resource Pools: Assessing the management of thread pools or connection pools to prevent exhaustion

## 6. Standards Review

- Accessibility (WCAG/ARIA): Ensuring the implementation is usable by individuals with diverse needs and complies with established standards
- Internationalisation (i18n): Verifying that the code is prepared for localization, handling diverse languages and cultural formats
- Regulatory Compliance: Assessing adherence to legal and data privacy frameworks such as GDPR or HIPAA where applicable
- Industry Standards: Verifying compliance with domain-specific protocols relevant to the project's industry
- Organisational Standards: Ensuring the change aligns with internal engineering playbooks and agreed-upon conventions

## 7. Observability Review

- Logging Quality: Ensuring logs provide sufficient context and appropriate severity levels to facilitate incident response
- System Metrics: Verifying that critical performance and health indicators are instrumented for monitoring
- Product Analytics: Confirming that user interaction events are captured accurately to inform business decisions
- Distributed Tracing: Assessing the propagation of trace identifiers to allow for visualization of requests across services
- Structured Output: Verifying that telemetry data is emitted in a format that is easily parsed by analysis tools
- Health Checks: Ensuring the system exposes accurate readiness and liveness signals for orchestration

## 8. Performance Review

- Algorithmic Complexity: Identifying logic with sub-optimal complexity that could degrade as input size grows
- Memory Management: Assessing allocation patterns to minimize unnecessary pressure on the garbage collector or memory limits
- I/O Efficiency: Evaluating the frequency and size of network and disk operations to minimize latency
- Database Efficiency: Identifying N+1 query patterns or expensive join operations that impact system throughput
- Resource Lifecycles: Ensuring that connections, file handles, and other finite resources are closed promptly
- Caching Strategy: Identifying opportunities to reuse expensive computations while ensuring invalidation is sound
- Infrastructure Impact: Assessing whether the code introduces excessive compute or storage costs relative to its value

## 9. Error Handling Review

- Exception Strategy: Ensuring that errors are caught at the appropriate level and not swallowed without logging
- Error Propagation: Verifying that error context is preserved as it moves through the system to aid root cause analysis
- Graceful Degradation: Assessing how the system behaves when a dependency or non-critical component fails
- Edge Case Coverage: Identifying unhappy paths and unexpected inputs that could cause the system to crash
- Retry and Fallbacks: Evaluating the safety and back-off strategy of automatic retries to prevent worsening failures
- Fail-Fast vs Fail-Safe: Verifying that the system chooses the appropriate failure mode for the specific context

## 10. Testing Review

- Coverage Depth: Assessing whether tests verify the logic of the change across a representative range of scenarios
- Test Quality: Ensuring tests are readable, maintainable, and verify behavior rather than implementation details
- Production Testability: Identifying code structures that make automated testing difficult and suggesting refactors
- Test Isolation: Verifying that tests do not share state or depend on external environments
- Flakiness Prevention: Identifying tests that may fail intermittently due to timing or environmental factors
- Mocking and Stubbing: Evaluating the use of doubles to ensure they are realistic and do not mask actual integration issues

## 11. Readability Review

- Naming Intent: Verifying that names for variables, functions, and classes reveal their purpose and the reason for their existence
- Cognitive Complexity: Identifying logic that is too dense or requires excessive mental effort to parse
- Expressiveness: Assessing whether the code uses language features that clearly communicate the developer's intent
- Comment Utility: Ensuring comments are used to explain non-obvious decisions rather than restating the code
- Pattern Consistency: Verifying that the change follows established idioms within the codebase to reduce the learning curve
- Code Flow: Assessing the narrative of the code to ensure the most important logic is prominent

## 12. Dependency Review

- Justification: Evaluating whether a new dependency is necessary or if the problem could be solved with existing tools
- Maintenance and Health: Assessing the activity level, security history, and community support of external libraries
- License and Security: Verifying that the dependency's license is compatible and checking for known vulnerabilities
- Supply Chain Risk: Reviewing the impact of transitive dependencies and the stability of the package history
- Bundle Impact: Evaluating the effect of the dependency on bundle sizes, startup times, or deployment complexity

## 13. Duplication Review

- Functional Duplication: Identifying similar logic performed in multiple places that should be centralized
- Pattern Redundancy: Recognizing repeated structural patterns that suggest a missing abstraction
- Boilerplate Reduction: Assessing if the change introduces repetitive code that could be simplified through better design

## 14. Documentation Review

- External Accuracy: Ensuring that the README, public API docs, and help guides reflect the actual state of the code
- Developer Onboarding: Verifying that instructions for building, testing, and running the code remain clear
- Decision Records: Ensuring that significant architectural shifts are documented for future context
- Change Transparency: Assessing if the changelog accurately describes the impact of the changes for users

## Report Format

Structure the review report as follows:

```
## Diff Review Summary

Scope: <number of files changed, insertions, deletions>
Intent: <brief description of what the changes accomplish>
Findings: {count per severity, e.g. 2 critical, 1 high, 3 medium, 1 low}

## Critical Findings

<issues that must be fixed before merging, or "None">

## High Findings

<issues that should be fixed before merging, or "None">

## Medium Findings

<issues worth addressing but not blocking, or "None">

## Low / Info

<minor suggestions and observations, or "None">

## Assessment

<overall assessment of the changes, noting both strengths and weaknesses>
```
