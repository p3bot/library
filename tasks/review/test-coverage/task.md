# Test Coverage Review

Identify gaps in test coverage across the codebase and optionally create tests to fill them. This task maps production code against the existing test suite to find untested or under-tested areas, then offers to write tests for the highest-priority gaps.

## Prerequisites

- A repository with source code to review
- Access to read all files in the repository

## Workflow

1. Read top-level documentation (README, AGENTS.md, configuration files) to understand the project purpose, language, and testing conventions
2. Identify the testing framework and coverage tooling in use
3. Discover all production source files, grouped by module or package
4. Discover all test files and map them to the production code they exercise
5. Identify production code with no corresponding tests, and production code with partial test coverage
6. Evaluate coverage gaps against the risk and complexity of each area
7. Produce a coverage gap report and present it inline. Save only if the user asked, or if they instructed this run to proceed without intervention. Use the path they gave. If they asked to save but named no path, ask. If they instructed this run to proceed without intervention and named no path, write to `.start/reviews/YYYY-MM-DD-test-coverage-NN.md` (`NN` starts at `01`, incrementing against existing files matching the date and type)
8. Ask the user whether to create tests for any of the identified gaps

## Reviewer Guidance

- Focus on meaningful gaps: untested business logic, error paths, edge cases, and integration points carry more risk than trivial getters or generated code.
- Do not flag every line as needing a test. Weigh the risk of the untested code against the maintenance cost of adding tests.
- When native coverage tooling is available, run it to produce a factual coverage report rather than inferring coverage from file names alone.
- If coverage tooling cannot be run, infer coverage by reading test files and tracing which production functions and paths they exercise.
- Distinguish between code that is genuinely untested and code that is tested indirectly through integration or end-to-end tests.
- It is acceptable to find no significant gaps. A well-tested codebase is a valid outcome.
- This task focuses on coverage gaps only. For test quality concerns (flakiness, test isolation, mocking strategy), use the testing review task instead.

## Coverage Analysis

When assessing gaps, consider:

- Untested files: production source files with no corresponding test file
- Untested functions: functions or methods with no test that calls them
- Untested branches: conditional logic paths not exercised by any test
- Untested error paths: error returns or exception handling not covered
- Untested edge cases: boundary values, empty inputs, nil/null handling
- Integration gaps: interactions between modules or services with no integration test

## Report Format

```
## Test Coverage Report

Scope: {what was reviewed, number of production files, number of test files}
Coverage tooling: {tool used or "inferred from file analysis"}
Summary: {overall coverage estimate or known metric}

## Untested Areas

### Critical (high-risk code with no tests)

{list of untested areas with high risk, or "None"}

### High (significant logic with minimal tests)

{list of areas with meaningful gaps, or "None"}

### Medium (partial coverage or missing edge cases)

{list of areas with partial coverage, or "None"}

### Low (trivial or low-risk gaps)

{minor gaps not worth prioritising, or "None"}

## Recommendations

{prioritised list of tests to add, with brief rationale for each}

## Assessment

{overall assessment of coverage health, noting the most important gaps to address}
```

## Creating Tests

After presenting the report, ask: "Would you like me to create tests for any of the identified gaps?"

If yes:

1. Confirm which gaps to address, starting with the highest priority
2. For each gap, write tests that:
   - Follow the existing test style and conventions of the project
   - Are placed in the correct location matching the project's test file layout
   - Use the project's existing test helpers, fixtures, and mocking patterns
   - Cover the primary behaviour, key edge cases, and error paths
3. After writing each set of tests, confirm the user is satisfied before moving to the next gap
4. Run the test suite if possible to verify the new tests pass
5. If a new test fails and reveals a bug in the production code, stop and report the bug to the user rather than fixing it silently — the user should decide whether to fix the bug, adjust the test, or defer the issue
