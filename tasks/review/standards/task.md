# Standards Review

Verify that the codebase meets applicable domain-specific standards and requirements. This review focuses on compliance with accessibility, internationalisation, regulatory, industry, and organisational standards. It does not cover general code quality, performance, or architectural concerns unless they represent a standards violation.

## Prerequisites

- A repository with source code to review
- Access to read all files in the repository

## Workflow

1. Read top-level documentation (README, AGENTS.md, configuration files) to understand the system's domain, purpose, and target users
2. Identify which standards are applicable to the system: accessibility requirements, internationalisation needs, regulatory obligations, industry protocols, and organisational conventions
3. Search for standards-related configuration: linting rules, accessibility checks, locale files, compliance documentation, and engineering playbooks
4. Read source code with applicable standards in mind, focusing on areas where compliance is expected
5. Evaluate the scope points below against what you have observed
6. Produce a structured report of findings and present it inline. Save only if the user asked, or if they instructed this run to proceed without intervention. Use the path they gave. If they asked to save but named no path, ask. If they instructed this run to proceed without intervention and named no path, write to `.start/reviews/YYYY-MM-DD-standards-NN.md` (`NN` starts at `01`, incrementing against existing files matching the date and type)

## Reviewer Guidance

- Standards reviews are inherently contextual. Not all scope points apply to every codebase. A CLI tool has no WCAG obligations. A single-locale internal tool may have no i18n requirements. Identify which standards are applicable before evaluating compliance, and note scope points that do not apply to the system under review.
- Severity should reflect the consequence of non-compliance. Regulatory violations that expose the organisation to legal risk are high or critical. Deviations from organisational conventions are typically medium or low. Assess findings against the actual impact of non-compliance, not the abstract importance of the standard.
- Distinguish between absent standards and violated standards. A codebase with no accessibility support is not non-compliant if accessibility was never a stated requirement. Flag gaps where standards clearly apply and are not met, not where standards could theoretically apply.
- It is acceptable to find no issues. A codebase that meets its applicable standards is a valid outcome. Do not manufacture findings or flag irrelevant standards to justify the review.
- Write "None" for any severity level where no findings exist. Every section must be present in the report.

## Scope

- Accessibility (WCAG/ARIA): Ensuring the implementation is usable by individuals with diverse needs and complies with established standards.
- Internationalisation (i18n): Verifying that the code is prepared for localization, handling diverse languages and cultural formats.
- Regulatory Compliance: Assessing adherence to legal and data privacy frameworks such as GDPR or HIPAA where applicable.
- Industry Standards: Verifying compliance with domain-specific protocols relevant to the project's industry.
- Organisational Standards: Ensuring the change aligns with internal engineering playbooks and agreed-upon conventions.

## Report Format

```
## Standards Review Summary

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

{overall assessment of the system's standards compliance, noting both strengths and weaknesses}
```
