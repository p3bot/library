# Review a Ticket Document

Using tk, review this ticket document.

`tasks:tk/id/expand` is fetched in Step 2 for the match test and rewrite only. `tasks:ticket/review` is fetched later for methodology only: phases, templates, goal bar, report format, and Ticket (T). This envelope is the only binding source for path, edits, and status.

These sections of the fetched expand protocol do not apply:

- Resolve
- Sync
- Status

These sections of the fetched review protocol do not apply:

- Identification of the ticket document

## Sync

When `tk status mode` is `tk-driven`, run `tk sync` first. Skip on repo-driven and plain-files. If sync needs-attention, stop.

After ticket-body edits, `tk sync` again on tk-driven. `mark` already self-commits.

Do not run `tk doctor` unless `tk get` or `tk mark` fails.

## Process

### Step 1: Resolve

The ticket id is the instruction. If none was supplied, ask for it. Do not guess or claim the next ticket.

Run `tk get <id>`. Apply the terminal test to that path and status before any mark.

A ticket is terminal when the path is under `archive/`, or when its status is `done` or `cancelled`.

- Terminal: ask whether to continue the review and reopen as `draft`. Explicit no: stop, leave the ticket terminal. Explicit yes: `tk mark draft <id>` and proceed
- Status `review`: `tk mark draft <id>` first. Do not use the `review` status
- Leave `in-progress`, `blocked`, `todo`, `backlog`, and `draft` alone

The working path is the last path printed by `tk get` or `tk mark`. After a reopen-as-`draft` mark, that printed path replaces the earlier get path.

### Step 2: Expand

```bash
start get tasks:tk/id/expand
```

Run the fetched Match test against the working path. Write only on stub (Match failure). Do not Write on capture. Capture is not a Match failure; continue to review. Write includes investigate, a design session if owner decisions remain, and the rewrite.

If Write ran: stop. The ticket was a stub; it now matches the writing guide. Tell the user to run this task again for the review.

If the ticket already matched, including capture: continue.

### Step 3: Review

```bash
start get tasks:ticket/review
```

Run the fetched methodology against the working path. Edit only under the H1. The fetched Ticket (T) section applies. `tk` is available in this envelope, so offer it. If that methodology dispatches to `tasks:design/review`, that walk is this step; then go to Step 4.

### Step 4: Status

Never auto-promote to `todo`.

If the ticket is design: do not ask to mark `todo`. Sound means the owner accepts, then decompose. If they accept now:

```bash
start get tasks:ticket/decompose
```

That task marks the design done after it writes the follow-ups. If they stop after the proposal, leave in `draft`.

Revise or Split: leave in `draft`.

If the wrap-up is Ready to implement, Ready to diagnose, Ready to decide, or Ready to investigate: ask whether to mark `todo` only when the ticket is `draft` at the end, including a just-reopened terminal or a just-demoted `review`. Only an explicit yes does.

Otherwise do not ask `todo`. Capture, stub, issues remaining, and split stay where they are.
