# Discuss a Ticket

Brief first. Then work with the user on whatever follows.

## Sync

Sync applies to a tk ticket or design. When `tk pulse mode` is `tk-driven`, run `tk sync` before `tk get` or `tk design get`. Skip on repo-driven and plain-files. If sync needs-attention, stop.

After ticket-body edits, `tk sync` again on tk-driven. `mark` already self-commits.

Do not run `tk doctor` unless `tk get` or `tk mark` fails.

## Resolve

The ticket is the instruction: a tk id or a path. If they asked you to find it, look where they pointed. If none was supplied, ask for it. Do not guess or claim the next ticket.

When `command -v tk` fails, a path is an unmanaged ticket. Otherwise, a path under `design/`: run `tk design get` on the full id in its filename, the first two hyphen-separated tokens, and continue from that command below; an id tk does not know leaves it unmanaged. Another path is a tk ticket when its frontmatter has an `id` that `tk get` resolves. Otherwise it is an unmanaged ticket. Its path is the working path.

For a tk id, run `tk get <id>`. Unknown ticket id: run `tk design get <id>`. `design_id:` and no path: stop. Do not `tk mark`. A path with `parse_error:` for that id: stop. The fence is quarantined. Do not mark, do not edit the fence, and do not run the design session or the review. `parse_error: N unparseable` does not quarantine the file just fetched. A path with no per-id `parse_error:` is a design document. Skip the rest of this task. Discuss that design on that path:

```bash
start get tasks:design/discuss
```

A ticket path is the working path.

## Brief

Read the ticket. Look at the relevant code if there is any. Check whether the proposed work is already done or redundant: the code already does it, another ticket covers it, or the need has gone.

```bash
start get contexts:ticket/writing
```

Brief against the matched profile. The writing guide's stub test is the source for whether the body matches.

If the matched profile is design, this is a legacy design-profile ticket or an unmanaged design document. Skip the rest of this task and discuss it on the working path:

```bash
start get tasks:design/discuss
```

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

Offer expand after the brief only for a stub, or when the user wants a capture promoted. Do not offer expand merely because Requirements is absent. If they accept:

```bash
start get tasks:ticket/expand
```

If it is not a stub and they did not ask to promote a capture, do not offer expand. Do not offer a ticket-document review.

## After the brief

Stay with the user. Discuss. Update the file only after they approve the change. Follow expand when they want a writing-guide rewrite rather than inventing that structure here.
