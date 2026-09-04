# Testing Review

Evaluate test quality, coverage, and the testability of the subject.

Findings about missing or weak tests, fixtures, isolation, eval harnesses, or testability are Testing. Findings about production behaviour that are not a testability fix belong to the product type (Correctness, Security, Performance, Operability, and so on) even when a test would have caught them.

## Prerequisites

- A repository with source code and tests to review
- Access to read all files in the repository

## Workflow

1. Read top-level documentation (README, AGENTS.md, configuration files) to understand the system's purpose and testing conventions
2. Identify the test suite structure: test directories, naming conventions, test runner configuration, and test helpers
3. Read test files alongside the production code they exercise, evaluating coverage of important logic paths
4. Search for test setup patterns: fixtures, factories, mocks, stubs, and shared state between tests
5. Review production code for testability barriers: hard-coded dependencies, global state, or tightly coupled components
6. Evaluate the scope points below against what you have observed
7. Produce a structured report of findings and present it inline. Save only if the user asked, or if they instructed this run to proceed without intervention. Use the path they gave. If they asked to save but named no path, ask. If they instructed this run to proceed without intervention and named no path, write to `.start/reviews/YYYY-MM-DD-testing-NN.md` (`NN` starts at `01`, incrementing against existing files matching the date and type)

## Reviewer Guidance

- Most testing findings are medium or low severity. Reserve high for patterns where missing coverage hides likely bugs or where test design creates false confidence in broken code. Critical should be rare and reserved for issues like a test suite that passes despite production defects or tests that modify shared state causing cascading false results.
- Evaluate testing against the system's risk profile. A utility library may need thorough unit tests. A CLI tool may rely more on integration tests. Judge the testing strategy against what the system needs, not an abstract ideal of coverage.
- Distinguish between low coverage and intentionally untested code. Some code is trivial or generated and does not benefit from tests. Flag gaps where missing tests conceal meaningful risk, not where tests would add maintenance burden without value.
- It is acceptable to find no issues. A codebase with a well-structured, effective test suite is a valid outcome. Do not manufacture findings or flag reasonable testing decisions as deficient to justify the review.
- Write "None" for any severity level where no findings exist. Every section must be present in the report.

## Scope

- Coverage Depth: Assessing whether tests verify the logic under review across a representative range of scenarios.
- Suite Gating: Verifying that the suite runs on every proposed change and can block merge when it fails.
- Test Quality: Ensuring tests are readable, maintainable, and verify behaviour rather than implementation details.
- Testability: Verifying that the subject can be driven by automated tests through explicit seams and deterministic behaviour, rather than hidden state or live side effects.
- Test Isolation: Verifying that isolated tests do not share state or depend on ambient environment, and that tests which use real dependencies declare that choice rather than leaking it.
- Flakiness Prevention: Identifying tests that may fail intermittently due to timing or environmental factors.
- Mocking and Stubbing: Evaluating the use of doubles to ensure they are realistic and do not mask actual integration issues.
- Contract Testing: Verifying that service interfaces match consumer expectations and do not break downstream integrations.
- Performance and Load Test Coverage: Assessing whether critical paths have tests under realistic load.
- End-to-End Testing: Assessing whether critical user journeys across service boundaries are covered by end-to-end tests.
- Chaos Test Coverage: Assessing whether controlled failure injection covers resilience under adverse conditions.
- Security Test Coverage: Assessing whether tests cover authentication, authorisation, input validation boundaries, and known attack patterns relevant to the reviewed subject.
- Non-Deterministic and Eval Behaviour: Assessing how tests handle non-deterministic model or agent output, including seeds, fixtures, eval harnesses, and tolerance bands that keep signal without masking regressions.

## Report Format

```
## Testing Review Summary

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

{overall assessment of the test suite's effectiveness and the codebase's testability, noting both strengths and weaknesses}
```
