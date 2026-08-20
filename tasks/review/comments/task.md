# Comment Review

Review of code comments across the repository for accuracy, usefulness, and completeness. Covers inline comments, block comments, and structured documentation comments. This is not a code logic review or a readability review — focus on the commentary itself and whether it helps developers understand the codebase.

## Prerequisites

- A codebase containing source code with comments

## Workflow

1. Identify the languages and documentation conventions used in the repository (JSDoc, GoDoc, Javadoc, docstrings, etc.)
2. Read source files systematically, paying attention to both the comments and the code they describe
3. For each comment, assess whether it is accurate, useful, and well-placed in relation to the current code
4. Review against the scope points below and any other concerns relevant to the commentary layer
5. Produce a structured report of findings and present it inline. Save only if the user asked, or if they instructed this run to proceed without intervention. Use the path they gave. If they asked to save but named no path, ask. If they instructed this run to proceed without intervention and named no path, write to `.start/reviews/YYYY-MM-DD-comments-NN.md` (`NN` starts at `01`, incrementing against existing files matching the date and type)

## Reviewer Guidance

- Err on the side of keeping comments. Only recommend removal when a comment is genuinely noise — restating what the code already expresses with no added insight. A comment that seems obvious to you may not be obvious to a developer encountering the code for the first time.
- Distinguish between comments that explain "why" and comments that explain "what". Comments explaining why a decision was made are almost always valuable. Comments explaining what the code does are only valuable when the logic is non-obvious to a human reader.
- Misleading and stale comments are worse than no comments. A comment that describes different behaviour than the code actively harms understanding. Prioritise these as findings.
- Comment findings are typically medium or low severity. Reserve high for misleading comments that could cause a developer to make incorrect assumptions. Critical is unlikely but possible for misleading comments near security-sensitive or safety-critical code.
- Classify findings by severity (critical, high, medium, low, info). Write "None" for any severity level where no findings exist. Every section must be present in the report.
- It is acceptable to find no issues. If the comments are accurate and useful, say so. Do not manufacture findings to justify the review.

## Scope

The following scope points are the primary areas of concern. They orient the review but do not limit it. Report any findings relevant to the commentary layer, including those outside these areas.

- Comment Accuracy: Identifying comments that have drifted from the code they describe, including misleading explanations and references to renamed or removed elements.
- Comment Necessity: Assessing whether comments restate what the code already expresses clearly, adding noise without insight.
- Missing Commentary: Identifying non-obvious logic, workarounds, surprising behaviour, or important constraints that lack any explanation.
- Commented-Out Code: Detecting dead code preserved in comments rather than removed or tracked through version control.
- Annotation Debt: Reviewing accumulated TODO, FIXME, HACK, and similar markers for resolution status and whether they are tracked elsewhere.
- Documentation Comments: Evaluating structured documentation systems (JSDoc, GoDoc, Javadoc, docstrings) for completeness, accuracy, and adherence to their conventions.
- Rationale and Context: Assessing the presence of comments explaining why decisions were made, especially for non-obvious architectural choices or workarounds.
- Boundary Documentation: Reviewing file-level, package-level, and module-level comments that establish the purpose and scope of code units.
- Link Integrity: Checking URLs in comments pointing to external resources, issues, or specifications for continued accessibility.
- Comment Consistency: Evaluating the uniformity of comment style, formatting conventions, and documentation patterns across the codebase.

## Report Format

```
## Comment Review Summary

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

{overall assessment of this area, noting both strengths and weaknesses}
```
