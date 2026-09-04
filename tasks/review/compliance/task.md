# Compliance Review

Verify that the subject meets its legal, regulatory, and organisational policy obligations, including the lawful handling of personal data.

Legal, regulatory, industry, and organisational policy obligations are Compliance. Engineering playbooks, idioms, and conventions are Maintainability (Consistency and Conceptual Integrity).

## Prerequisites

- A repository with source code to review
- Access to read all files in the repository

## Workflow

1. Read top-level documentation (README, AGENTS.md, configuration files) to understand the system's domain, purpose, and target users
2. Identify which legal, regulatory, industry, and organisational policy obligations apply
3. Search for related configuration: compliance documentation, data-handling policies, locale and processor lists, and mandated controls
4. Read source code with applicable obligations in mind, focusing on personal data collection, retention, sharing, and telemetry
5. Evaluate the scope points below against what you have observed
6. Produce a structured report of findings and present it inline. Save only if the user asked, or if they instructed this run to proceed without intervention. Use the path they gave. If they asked to save but named no path, ask. If they instructed this run to proceed without intervention and named no path, write to `.start/reviews/YYYY-MM-DD-compliance-NN.md` (`NN` starts at `01`, incrementing against existing files matching the date and type)

## Reviewer Guidance

- Compliance reviews are inherently contextual. Not all scope points apply to every codebase. Identify which obligations apply before evaluating them, and note scope points that do not apply.
- Severity should reflect the consequence of non-compliance. Regulatory violations that expose the organisation to legal risk are high or critical. Deviations from internal policy are typically medium or low. Assess findings against the actual impact of non-compliance, not the abstract importance of the obligation.
- Distinguish between absent obligations and violated obligations. A codebase with no personal data is not non-compliant with GDPR if personal data was never in scope. Flag gaps where obligations clearly apply and are not met.
- It is acceptable to find no issues. A codebase that meets its applicable obligations is a valid outcome. Do not manufacture findings or flag irrelevant obligations to justify the review.
- Write "None" for any severity level where no findings exist. Every section must be present in the report.

## Scope

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

## Report Format

```
## Compliance Review Summary

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

{overall assessment of the subject's compliance posture, noting both strengths and weaknesses}
```
