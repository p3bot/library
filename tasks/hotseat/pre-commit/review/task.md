# Pre-commit review

Review the diff, fix what every member agrees, and mark the ticket `done` when the diff is clean. The diff is the guide. Do not review the rest of the repository.

The ticket id is the `ticket:` line in the instructions. Do not ask for one.

Every member reads the instructions and registers. A member who is not the acting seat then exits. Phase work starts when a `turn` names you.

Edit a file only in a fix launch. No member edits a file during the review set or the satisfaction set.

## Phase 1

The acting seat posts one parallel review `turn` to every name `hotseat member list` returns, including itself.

The first line is `mode: parallel`. The phase text is: `start get tasks:review/pre-commit`. Use its diff boundary, ten criteria, report format, and per-item template. Do not use its Commands, and do not apply its remediation or satisfaction phases. Those phases apply tests, comments, and documentation, and fix linter output, without a discussion. Do not edit the diff.

Publish each issue as its own `finding`, addressed to every roster name. Tests, comments, and documentation are findings too. The body is the full finding with one proposed solution. An issue written only in the `say` gets no discussion and is not fixed.

Then publish one `say` to the seat with the report. When you have no findings, the `say` also says `no findings`.

## Phase 2

`run` discusses each finding and launches the finder to apply an agreed fix. Members take their stances when `run` launches them. The finder applies the agreed proposal in its fix launch.

The seat does not apply fixes and does not schedule a discussion.

## Phase 3

The follow-up prompt for the review set carries `fixed: <n>`.

- `fixed: 0`: go to Phase 4
- Any other count: the seat posts one parallel satisfaction `turn` to every roster name, including itself

The first line is `mode: parallel`. Each member re-reads only the lines the fixes touched, and runs the project's formatters and linters on those files in check mode. This is not a second full review. Publish `clean` as a `say` to the seat, or one regression as a `finding` addressed to every roster name. A violation a formatter or linter reports is a regression `finding`, not a direct fix. A regression goes through the same discussion and fix.

On the follow-up after the satisfaction set, go to Phase 4. There is no second satisfaction pass.

## Phase 4

The seat posts `done` to `owner`. The body starts with the outcome line and then the remediation summary.

- The diff is clean: `tk mark done <id>`, then `outcome: proceed`
- A finding is still unresolved: leave `review`, post `outcome: hold`, and list those findings

## Trailer

tasks:review/pre-commit
