# Security Review

Identify vulnerabilities, security weaknesses, and potential attack vectors across the codebase. This review focuses on how the system protects itself and its users from malicious or unintended access. It does not cover general code correctness, performance, or architectural concerns unless they have direct security implications.

## Prerequisites

- A repository with source code to review
- Access to read all files in the repository

## Workflow

1. Read top-level documentation (README, AGENTS.md, configuration files) to understand the system's purpose and deployment context
2. Identify the system's trust boundaries: where user input enters, where data leaves, where privilege changes occur
3. Read authentication and authorisation logic, session management, and access control code
4. Search for patterns involving secrets, credentials, tokens, and cryptographic operations
5. Read input handling, API endpoints, and data validation logic
6. Read remaining source files with security concerns in mind
7. Evaluate the scope points below against what you have observed
8. Produce a structured report of findings and present it inline. Save only if the user asked, or if they instructed this run to proceed without intervention. Use the path they gave. If they asked to save but named no path, ask. If they instructed this run to proceed without intervention and named no path, write to `.start/reviews/YYYY-MM-DD-security-NN.md` (`NN` starts at `01`, incrementing against existing files matching the date and type)

## Reviewer Guidance

- Assume a hostile environment. Evaluate each surface from the perspective of an attacker seeking to exploit the system.
- Severity should reflect exploitability and impact. A theoretical vulnerability in unreachable code is less severe than a simple injection in a public endpoint. Reserve critical for findings that could lead to data breach, privilege escalation, or system compromise.
- Context matters. A missing CSRF token in a read-only public API is different from one in a state-changing authenticated endpoint. Assess findings against the system's actual threat model, not a generic checklist.
- It is acceptable to find no issues. A well-secured codebase is a valid outcome. Do not manufacture findings or inflate severity to justify the review.
- When a concern falls outside security (poor naming, slow queries, missing tests), note it only if it has a direct security consequence. Otherwise, leave it for the appropriate specialised review.
- Write "None" for any severity level where no findings exist. Every section must be present in the report.

## Scope

- Authentication and Authorisation: Verifying the integrity of identity verification and the strict enforcement of access boundaries across all layers.
- Input Validation and Sanitisation: Ensuring all untrusted data is validated and cleaned to prevent injection and manipulation attacks.
- Secrets Management: Confirming that sensitive credentials and configuration data are handled via secure, externalized mechanisms.
- Data Protection and Encryption: Assessing the safety of sensitive information at rest and in transit, including the prevention of data leakage in logs.
- Cryptography Usage: Evaluating the implementation of cryptographic primitives to ensure the use of proven, industry-standard protocols.
- Session Management: Reviewing the lifecycle and security properties of user sessions and tokens to prevent hijacking or unauthorized reuse.
- API Security: Identifying risks in endpoint design, including improper resource exposure or excessive data return.
- CORS and CSRF Protection: Verifying that cross-origin policies and request forgery protections are correctly configured.
- Rate Limiting: Assessing the system's resilience against automated abuse, brute-force attempts, and resource exhaustion.
- Secure Headers: Confirming the presence of security-related HTTP headers that harden the client-side execution environment.
- Path Traversal: Ensuring that file and resource pathing logic cannot be manipulated to access restricted areas.
- Deserialization Safety: Verifying that the conversion of data formats into objects does not introduce execution risks.
- Privilege Escalation: Analyzing logic for flaws that could allow a user to perform actions beyond their intended permission level.

## Report Format

```
## Security Review Summary

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

{overall assessment of the system's security posture, noting both strengths and weaknesses}
```
