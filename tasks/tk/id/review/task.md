# Review a Ticket Document

Using tk, review this ticket document.

`tasks:ticket/review` is fetched later for methodology only: phases, templates, goal bar, report format, and T. This envelope is the only binding source for path, edits, and status.

These sections of the fetched protocol do not apply:

- Identification of the ticket document

## Sync

When `tk status mode` is `tk-driven`, run `tk sync` first. Skip on repo-driven and plain-files. If sync needs-attention, stop.

After ticket-body edits, `tk sync` again on tk-driven. `mark` already self-commits.

Do not run `tk doctor` unless `tk get` or `tk mark` fails.

## Process

### Step 1: Resolve

The ticket id is the instruction. If none was supplied, ask for it. Do not guess. Do not fall back to `tk next`.

Run `tk get <id>`. Apply the terminal test to that path and status before any mark.

A ticket is terminal when the path is under `archive/`, or when its status is `done` or `cancelled`.

- Terminal: ask whether to continue the review and reopen as `draft`. Explicit no: stop, leave the ticket terminal. Explicit yes: `tk mark <id> draft` and proceed
- Status `review`: `tk mark <id> draft` first. Do not use the `review` status
- Leave `in-progress`, `blocked`, `todo`, `backlog`, and `draft` alone

The working path is the last path printed by `tk get` or `tk mark`. After a reopen-as-`draft` mark, that printed path replaces the earlier get path.

### Step 2: Review

```bash
start get tasks:ticket/review
```

Run the fetched methodology against the working path. Edit only under the H1. `T` follows the fetched Ticket (T) section. `tk` is available in this envelope, so offer it.

### Step 3: Status

Never auto-promote to `todo`. Ask whether to mark `todo` only when the ticket is `draft` at the end, including a just-reopened terminal or a just-demoted `review`. Only an explicit yes does.
