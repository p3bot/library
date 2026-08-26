# Discuss a Ticket

Using tk, discuss this ticket.

Brief first. Then work with the user on whatever follows.

## Sync

When `tk status mode` is `tk-driven`, run `tk sync` first. Skip on repo-driven and plain-files. If sync needs-attention, stop.

After ticket-body edits, `tk sync` again on tk-driven. `mark` already self-commits.

Do not run `tk doctor` unless `tk get` or `tk mark` fails.

## Resolve

The ticket id is the instruction. If none was supplied, ask for it. Do not guess. Do not fall back to `tk next`.

Run `tk get <id>`. The working path is the last path it printed.

## Brief

Read the ticket. Look at the relevant code if there is any. Check whether the proposed work is already done or redundant: the code already does it, another ticket covers it, or the need has gone.

The writing guide is the source for what a finished ticket looks like: a document a different agent can execute in a fresh session with no conversation context.

A ticket is a stub if any of these hold:

- No writing-guide section headings under the H1
- Primary content is a log, paste, or error dump
- Missing Goal, missing Requirements, or missing Acceptance Criteria
- Relies on conversation context ("as discussed", "you can see below")

A thin ticket that still has those sections is not a stub.

If it is a stub, say so plainly at the top of the brief.

Then report:

### Summary

A simple explanation of the work, or other proposal, in the ticket.

### What it does

Bullets of the intended change or outcome.

### Why it is needed

The problem, gap, or pressure, checked against the current code.

### Already done or redundant

Whether the work is already in the repo, covered elsewhere, or still needed. If already done, say where.

### Recommendation

Whether to do it, skip it, reshape it, or something else, and why.

If the ticket is a stub, offer to run expand after the brief. If they accept:

```bash
start get tasks:tk/id/expand
```

If it is not a stub, do not offer expand. Do not offer a ticket-document review.

## After the brief

Stay with the user. Discuss. Update the ticket only after they approve the change. Follow expand when they want a writing-guide rewrite rather than inventing that structure here.
