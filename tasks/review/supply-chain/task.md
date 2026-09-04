# Supply Chain Review

Review what the subject consumes and what it publishes, from third-party dependencies through build integrity to release.

## Prerequisites

- A repository with source code to review
- Access to read all files in the repository including dependency manifests, lock files, and build and release configuration

## Workflow

1. Read top-level documentation (README, AGENTS.md, configuration files) to understand the project's purpose and technology choices
2. Read dependency manifests and lock files to inventory all direct and transitive dependencies
3. Determine the latest available version of each direct dependency and note how far behind the project's pinned versions are
4. For each direct dependency, assess justification, maintenance status, licence compatibility, and known vulnerabilities
5. Review build and release configuration: reproducibility, artefact signing, pipeline triggers, and deprecation policy
6. Evaluate the scope points below against what you have observed
7. Produce a structured report of findings and present it inline. Save only if the user asked, or if they instructed this run to proceed without intervention. Use the path they gave. If they asked to save but named no path, ask. If they instructed this run to proceed without intervention and named no path, write to `.start/reviews/YYYY-MM-DD-supply-chain-NN.md` (`NN` starts at `01`, incrementing against existing files matching the date and type)

## Reviewer Guidance

- Evaluate dependencies in proportion to the project's needs. A small utility library in a large project is a different risk profile than a foundational framework. Judge each dependency against the complexity it replaces, not against an ideal of zero dependencies.
- Most supply chain findings are medium or low severity. Reserve high for dependencies with known vulnerabilities, abandoned maintenance, or incompatible licences, and for pipeline flaws that expose secrets or let untrusted code run. Critical should be rare and reserved for actively exploited vulnerabilities or an immediate supply chain risk.
- Distinguish between a dependency that could theoretically be replaced and one that should be. The cost of maintaining a vendored alternative often exceeds the risk of a well-maintained library. Flag dependencies that are genuinely problematic, not ones that are merely replaceable.
- It is acceptable to find no issues. A project with well-chosen dependencies and a sound build and release path is a valid outcome. Do not manufacture findings or question reasonable choices to justify the review.
- Write "None" for any severity level where no findings exist. Every section must be present in the report.

## Scope

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

## Report Format

```
## Supply Chain Review Summary

Scope: {what was reviewed, number of direct and transitive dependencies}
Findings: {count per severity, e.g. 0 critical, 1 high, 2 medium, 1 low}

## Critical Findings

{findings that represent serious risk or deficiency, or "None"}

## High Findings

{findings that should be addressed, or "None"}

## Medium Findings

{findings worth considering, or "None"}

## Low / Info

{minor observations and suggestions, or "None"}

## Assessment

{overall assessment of the subject's supply chain, noting both strengths and weaknesses}
```
