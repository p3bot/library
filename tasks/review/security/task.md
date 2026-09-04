# Security Review

Identify vulnerabilities, security weaknesses, and potential attack vectors.

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
