# Review a ticket

Review the ticket document, fix what every member agrees, and mark `todo` only when a later session can implement it. Do not change the product.

The ticket id is the `ticket:` line in the instructions. Do not ask for one.

Every member reads the instructions and registers. A member who is not the acting seat then exits. Phase work starts when a `turn` names you.

Edit only under the H1. The fence stays sealed. On a tk-driven scope, `tk sync` after a body edit. `tk mark` self-commits.

## Phase 1

The acting seat posts one parallel review `turn` to every name `hotseat member list` returns, including itself.

The first line is `mode: parallel`. The phase text is: `start get tasks:ticket/review`. Use its reviewer guidance, issue categories, goal bar, per-item template, and report format. Do not use its Sync, Resolve, stub Write, Commands, or Status phase, and do not apply its remediation phase. Do not edit the ticket.

Publish each issue as its own `finding`, addressed to every roster name. The body is the full finding with one proposed solution. An issue written only in the `say` gets no discussion and is not fixed.

Then publish one `say` to the seat with the profile, stub, and split verdicts. When you have no findings, the `say` also says `no findings`.

`start get contexts:ticket/writing` only when the profile match or the stub test is in question.

## Phase 2

`run` discusses each finding and launches the finder to apply an agreed fix. Members take their stances when `run` launches them. The finder applies the agreed proposal in its fix launch.

The seat does not apply edits and does not schedule a discussion.

## Phase 3

The follow-up prompt for the review set carries `fixed: <n>`.

- `fixed: 0`: go to Phase 4
- Any other count: the seat posts one parallel satisfaction `turn` to every roster name, including itself

The first line is `mode: parallel`. Each member re-reads the document only for inconsistencies the fixes introduced. This is not a second full review. Publish `clean` as a `say` to the seat, or one regression as a `finding` addressed to every roster name. A regression goes through the same discussion and fix.

On the follow-up after the satisfaction set, go to Phase 4. There is no second satisfaction pass.

## Phase 4

The seat posts `done` to `owner`. The body starts with the outcome line and then the report.

- No blocking issue remains, and the profile is implement, or a bug whose work is a fix: `tk mark todo <id>`, then `outcome: proceed`
- Anything else, including a split, a stub, a capture, a decide, an investigate, or a bug that is not yet a fix: leave `triaged` and post `outcome: hold`. Name the blocking findings or the seam

A split names the seam and does not create the children.

## Trailer

tasks:ticket/review
