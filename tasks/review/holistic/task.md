# Holistic Review

Assess the overall structural health, consistency, and developer experience of the repository as a complete entity. Read the entire codebase to form a thorough understanding, then evaluate it through a holistic lens. This review focuses on repository-wide concerns such as structure, consistency, and coherence. It does not replace specialised reviews for security, performance, or correctness.

## Prerequisites

- A repository with source code to review
- Access to read all files in the repository

## Workflow

1. Read top-level documentation (README, AGENTS.md, design docs, configuration files)
2. Read the directory structure and file organisation
3. Read source files across the codebase to assess consistency and patterns
4. Evaluate the scope points below against what you have observed
5. Note areas that warrant deeper specialised review
6. Produce a structured report of findings and present it inline. Save only if the user asked, or if they instructed this run to proceed without intervention. Use the path they gave. If they asked to save but named no path, ask. If they instructed this run to proceed without intervention and named no path, write to `.start/reviews/YYYY-MM-DD-holistic-NN.md` (`NN` starts at `01`, incrementing against existing files matching the date and type)

## Reviewer Guidance

- Read the source files. A thorough understanding of the code is needed to assess holistic concerns like consistency and conceptual integrity.
- Judge findings relative to the repository's scale and stated purpose. A small utility does not need the same structure as a large application.
- Holistic findings rarely reach critical severity. Reserve critical for cases where the repository's fundamental organisation prevents it from achieving its purpose. Most findings will be medium or low.
- It is acceptable to find no issues. A well-organised repository with consistent patterns is a valid outcome. Do not manufacture findings.
- When a concern falls clearly within a specialised review type (security vulnerability, race condition, test gap), note it briefly and recommend the appropriate specialised review rather than investigating in depth.
- Write "None" for any severity level where no findings exist. Every section must be present in the report.

## Scope

- Conceptual Integrity: Verifying the codebase feels written by one mind with consistent patterns rather than a patchwork of conflicting styles.
- Repository Structure: Assessing if the file layout and directory organization are intuitive and self-explanatory.
- Solution Fit: High-level verification that the implementation aligns with the repository's stated purpose and architectural manifest.
- Tech Stack Coherence: Identifying library sprawl or conflicting tool choices that complicate the strategic technical direction.
- Project Hygiene: Checking for the presence and consistency of top-level configuration, CI/CD health, and environment setup.
- Codebase Atrophy: Detecting signs of large-scale rot, such as abandoned modules, ghost directories, or obsolete features.
- Cognitive Profile: Assessing if the overall solution complexity is proportionate to the problem domain being solved.

## Report Format

```
## Holistic Review Summary

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

## Specialised Review Recommendations

{which focused reviews to run based on concerns found}

## Assessment

{overall assessment of the repository's structural health, noting both strengths and weaknesses}
```
