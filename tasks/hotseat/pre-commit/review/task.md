# Pre-commit review

Review the diff, fix what the members agree, and mark the ticket `done` when the diff is clean. The diff is the guide. Do not review the rest of the repository.

The ticket id is the `ticket:` line in the instructions.

A member who is not the acting seat registers and exits. Phase work starts when a `turn` names you.

## Phase 1

The acting seat posts one parallel `turn` to every name `hotseat member list` returns, including itself.

The first line is `mode: parallel`. The phase text is: `start get tasks:review/pre-commit`. Use its diff boundary, ten criteria, report format, and per-item template. Do not use its Commands. Publish a `say` to the seat with the findings. Do not edit yet.

## Phase 2

The seat applies the fixes. Tests, comments, and documentation are safe: apply them without a discussion `turn`. Any other fix is a one-name serial `turn`. The seat posts the aggregate before the next `turn`.

## Phase 3

The seat posts one parallel `turn` to every roster name, including itself. Each member re-reads only the lines the fixes touched, runs the project's formatters and linters on those files, and publishes a `say`: `clean`, or one regression with a proposed fix. This is not a second full review.

When every say is `clean`, go to Phase 4.

When any say is not `clean`, one serial round applies those findings. That round does not schedule another satisfaction pass. Anything still unresolved is reported in Phase 4.

## Phase 4

The seat posts `done` to `owner`. The body starts with the outcome line and then the remediation summary.

- The diff is clean: `tk mark done <id>`, then `outcome: proceed`
- A finding is still unresolved: leave `review`, post `outcome: hold`, and list those findings

## Trailer

tasks:review/pre-commit
