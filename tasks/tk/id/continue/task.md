# Continue a Ticket

Using tk, continue this ticket.

## Sync

When `tk pulse mode` is `tk-driven`, run `tk sync` first. Skip on repo-driven and plain-files. If sync needs-attention, stop.

After ticket-body edits, `tk sync` again on tk-driven. `mark` already self-commits.

Do not run `tk doctor` unless `tk get` or `tk mark` fails.

## Process

### Step 1: Resolve

The ticket id is the instruction. If none was supplied, ask for it. Do not guess or claim the next ticket.

Run `tk get <id>`. Unknown ticket id: run `tk design get <id>`. A path means this id is a design document. Stop. Do not `tk mark` it. Edit under its H1. When the shape is still open, run the design session against that path:

```bash
start get contexts:design/writing
```

On a ticket path, `tk mark in-progress <id>` whatever status it had. This unarchives `done` and `cancelled`. The last path `tk mark` printed is the working path; it replaces the earlier `tk get` path.

### Step 2: Work

```bash
start get contexts:ticket/implementation
```

Follow that guide against the working path. Orient, work the matched profile, verify, report. Same profile rules as `tasks:tk/id/build`. Do not invent an Implementation Plan for a profile that has none.

### Step 3: Close

Same Close table as `tasks:tk/id/build`. Mark from the outcome of this run. Do not leave a finished or stopped profile in `in-progress`.

- implement, decide, investigate, or a bug whose work was a fix — success: `tk mark done <id>`
- bug blocked outside this session: record Blocked on / Already done and `tk mark blocked <id>`
- capture stop or stub: `tk mark draft <id>`
- legacy design-profile ticket filled and waiting for accept: `tk mark draft <id>`. Do not mark `todo`. Owner accepts, then decompose. A design document is not this task
- still mid-work (Progress remains): leave `in-progress`

If capture rewrote in place to another profile, close as that profile.
