# Review a ticket

Review the ticket document, fix what the members agree, and mark `todo` only when a later session can implement it. Do not change the product.

The ticket id is the `ticket:` line in the instructions. Do not ask for one.

A member who is not the acting seat registers and exits. Phase work starts when a `turn` names you.

Edit only under the H1. The fence stays sealed. On a tk-driven scope, `tk sync` after a body edit. `tk mark` self-commits.

## Phase 1

The acting seat posts one parallel `turn` to every name `hotseat member list` returns, including itself.

The first line is `mode: parallel`. The phase text is: `start get tasks:ticket/review`. Use its reviewer guidance, issue categories, goal bar, per-item template, and report format. Do not use its Commands, and do not apply its remediation phase. Publish a `say` to the seat with the findings. Do not edit yet.

`start get contexts:ticket/writing` only when the profile match or the stub test is in question.

## Phase 2

The seat applies the agreed edits to the ticket body. Discussion is a sequence of one-name serial `turn`s. The seat posts the aggregate before the next `turn`.

## Phase 3

The seat posts one parallel `turn` to every roster name, including itself. Each member re-reads the document for inconsistencies the edits introduced and publishes a `say`: `clean`, or one regression with a proposed fix. This is not a second full review.

When every say is `clean`, go to Phase 4.

When any say is not `clean`, one serial round applies those findings. That round does not schedule another satisfaction pass. Anything still unresolved is reported in Phase 4.

## Phase 4

The seat posts `done` to `owner`. The body starts with the outcome line and then the report.

- No blocking issue remains, and the profile is implement, or a bug whose work is a fix: `tk mark todo <id>`, then `outcome: proceed`
- Anything else, including a split, a stub, a capture, a decide, an investigate, or a bug that is not yet a fix: leave `triaged` and post `outcome: hold`. Name the blocking findings or the seam

A split names the seam and does not create the children.

## Trailer

tasks:ticket/review
