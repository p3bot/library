# Implement a ticket

The acting seat implements the ticket. Do not post a `turn`. Any other member registers and exits.

The ticket id is the `ticket:` line in the instructions. Do not ask for one.

## Phase 1

`tk mark in-progress <id>`.

`start get contexts:ticket/implementation` and follow that guide: Orient, Work, Verify, Report. Include the review fixes named in the ticket.

`start get contexts:ticket/writing` only when the profile match is unsettled.

A design path is not this work. Post `outcome: hold` and do not mark the ticket.

A blocking gap is an `ask` to `owner`. Do not post `done` until the answer is in the transcript and the work can continue.

On a tk-driven scope, `tk sync` after a ticket-body edit. `tk mark` self-commits.

## Phase 2

When the guide's done-condition for this profile holds, `tk mark review <id>`. Do not mark the ticket `done`.

Post `done` to `owner`. The body starts with `outcome: proceed` and then the report from the implementation guide.

When the work cannot be finished, leave the status, post `outcome: hold`, and name the gap.
