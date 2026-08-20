# Random File Review

Select a random file from the repository and perform a thorough review of its quality, correctness, and role within the codebase. This is a spot check — the file selection is random and the review covers all aspects of the chosen file.

## Prerequisites

- A repository with source files

## File Selection

1. List all files in the repository tracked by git: `git ls-files`
2. Exclude files that are not meaningful review targets:
   - Binary files (images, compiled output, fonts, archives)
   - Generated files (lock files, build output, minified bundles, code generation output)
   - Vendored or third-party code (vendor/, node_modules/, third_party/)
   - Git and IDE configuration (.git/, .idea/, .vscode/ settings)
3. From the remaining files, select one at random using: `shuf -n 1`
4. Report which file was selected and proceed with the review

## Workflow

1. Perform file selection as described above
2. Read the selected file thoroughly
3. Read immediate imports and dependencies to understand the file's context
4. Find callers and usages to understand the file's role in the codebase
5. Check if a corresponding test file exists and assess its coverage of the selected file
6. Review the file against all scope points below and any other concerns relevant to the file
7. Produce a structured report of findings and present it inline. Save only if the user asked, or if they instructed this run to proceed without intervention. Use the path they gave. If they asked to save but named no path, ask. If they instructed this run to proceed without intervention and named no path, write to `.start/reviews/YYYY-MM-DD-random-file-<file-name>-NN.md` (`NN` starts at `01`, incrementing against existing files matching the date and type)

## Reviewer Guidance

- The file is the subject. Surrounding code is context for understanding, not a target for review.
- Adapt to whatever file you land on. A utility function, a configuration file, a test, and an API handler each warrant different emphasis.
- Judge the file on its own terms. A simple helper does not need the same scrutiny as a security-critical handler.
- Classify findings by severity (critical, high, medium, low, info). Write "None" for any severity level where no findings exist. Every section must be present in the report.
- It is acceptable to find no issues. If the file is well-implemented, say so. Do not manufacture findings to justify the review.

## Scope

The following scope points cover the range of concerns that may apply to any file. Not all points will be relevant to every file — assess what applies and skip what does not.

- Purpose Clarity: Assessing whether the file's purpose is immediately understandable from its name, location, and opening content.
- Correctness: Verifying that the logic does what it appears to intend, with no subtle bugs or incorrect assumptions.
- Error Handling: Evaluating how the file handles failures, unexpected input, and edge cases.
- Naming: Reviewing the clarity and consistency of variable, function, type, and constant names within the file.
- Complexity: Assessing whether the file is appropriately sized and focused, or whether it tries to do too much.
- Dependencies: Reviewing what the file imports, whether those imports are all used, and whether the dependency choices are appropriate.
- Integration: Evaluating how the file fits within the broader codebase — its role, its interfaces, and whether it follows established patterns.
- Test Coverage: Checking whether a corresponding test exists and whether it exercises the file's significant behaviour.
- Comments: Assessing whether comments are accurate, useful, and present where the logic is non-obvious.
- Security: Identifying any security concerns specific to what this file does (input handling, data access, credential usage).

## Report Format

```
## Random File Review Summary

File: {path to the selected file}
Purpose: {brief description of what the file does}
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

{overall assessment of this file, noting both strengths and weaknesses}
```
