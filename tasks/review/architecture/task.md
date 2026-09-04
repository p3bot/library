# Architecture Review

Evaluate system structure, design decisions, component organisation, and whether the shape of the subject fits its stated purpose.

## Prerequisites

- A repository with source code to review
- Access to read all files in the repository

## Workflow

1. Read top-level documentation (README, AGENTS.md, design docs, configuration files) to understand the system's purpose and intended architecture
2. Map the high-level structure: packages, modules, layers, and their relationships
3. Trace dependency flow between components to identify coupling and boundary violations
4. Read API surfaces, interfaces, and contracts between modules
5. Review configuration management, database schemas, and migration patterns
6. Evaluate the scope points below against what you have observed
7. Produce a structured report of findings and present it inline. Save only if the user asked, or if they instructed this run to proceed without intervention. Use the path they gave. If they asked to save but named no path, ask. If they instructed this run to proceed without intervention and named no path, write to `.start/reviews/YYYY-MM-DD-architecture-NN.md` (`NN` starts at `01`, incrementing against existing files matching the date and type)

## Reviewer Guidance

- Evaluate architecture relative to the system's scale and purpose. A small CLI tool does not need the same layering as a distributed service. Judge the design against what it needs to be, not an idealised reference architecture.
- Severity should reflect structural risk. A circular dependency between core modules that prevents independent change is critical. A slightly unclear boundary in a stable, rarely modified area is low. Consider how much the flaw constrains future development or introduces fragility.
- Distinguish between intentional trade-offs and accidental complexity. Not every shortcut is a defect. If the design deviates from a textbook pattern but the trade-off is reasonable for the context, note it as an observation rather than a finding.
- It is acceptable to find no issues. A well-structured system with clear boundaries is a valid outcome. Do not manufacture findings or flag pragmatic design choices as architectural defects to justify the review.
- Write "None" for any severity level where no findings exist. Every section must be present in the report.

## Scope

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

## Report Format

```
## Architecture Review Summary

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

{overall assessment of the system's architecture, noting both strengths and weaknesses}
```
