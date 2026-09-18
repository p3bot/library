# Discuss a Ticket

Using tk, discuss this ticket.

Brief first. Then work with the user on whatever follows.

## Sync

When `tk status mode` is `tk-driven`, run `tk sync` first. Skip on repo-driven and plain-files. If sync needs-attention, stop.

After ticket-body edits, `tk sync` again on tk-driven. `mark` already self-commits.

Do not run `tk doctor` unless `tk get` or `tk mark` fails.

## Resolve

The ticket id is the instruction. If none was supplied, ask for it. Do not guess or claim the next ticket.

Run `tk get <id>`. The working path is the last path it printed.

## Brief

Read the ticket. Look at the relevant code if there is any. Check whether the proposed work is already done or redundant: the code already does it, another ticket covers it, or the need has gone.

```bash
start get contexts:ticket/writing
```

Brief against the matched profile. The writing guide's stub test is the source for whether the body matches.

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

Offer expand after the brief only for stubs, or when the user wants a capture promoted. Do not offer expand merely because Requirements is absent. If they accept:

```bash
start get tasks:tk/id/expand
```

If it is not a stub and they did not ask to promote a capture, do not offer expand. Do not offer a ticket-document review.

## After the brief

Stay with the user. Discuss. Update the ticket only after they approve the change. Follow expand when they want a writing-guide rewrite rather than inventing that structure here.
