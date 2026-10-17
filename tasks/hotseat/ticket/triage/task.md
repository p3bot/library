# Triage a ticket

Decide whether this ticket should enter review. Do not implement it. Do not expand a stub. Do not edit the body.

The ticket id is the `ticket:` line in the instructions. Do not ask for one.

A member who is not the acting seat registers and exits. Phase work starts when a `turn` names you.

## Phase 1

The acting seat posts one parallel `turn` to every name `hotseat member list` returns, including itself. Do not wait for the rest of the roster to register.

The first line of the body is `mode: parallel`. The phase text is: read the ticket with `tk get`. `start get contexts:ticket/writing` and run that guide's stub test and profile match. Publish a `say` to the seat with one verdict: `pass`, `stub`, `reject`, or `split`. A `split` names the seam. Do not edit the ticket.

## Phase 2

When the says disagree, the seat discusses with one-name serial `turn`s. One serial `turn` does not name several people. The seat settles the verdict.

When the says agree, skip this phase.

## Phase 3

The seat marks, then posts `done` to `owner`. The body starts with the outcome line. The following lines are the profile and, for a split, the seam.

- `pass`: `tk mark triaged <id>`, then `outcome: proceed`
- `stub`: leave `draft`, `outcome: hold`, and say that it is a stub. Do not expand
- `reject`: `tk mark cancelled <id>`, then `outcome: hold`
- `split`: leave `draft`, `outcome: hold`, and name the seam. Do not create the children

## Trailer

contexts:ticket/writing
