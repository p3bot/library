# Continue a Ticket

Using tk, continue this ticket.

## Sync

When `tk status mode` is `tk-driven`, run `tk sync` first. Skip on repo-driven and plain-files. If sync needs-attention, stop.

After ticket-body edits, `tk sync` again on tk-driven. `mark` already self-commits.

Do not run `tk doctor` unless `tk get` or `tk mark` fails.

## Process

### Step 1: Resolve

The ticket id is the instruction. If none was supplied, ask for it. Do not guess. Do not fall back to `tk next`.

Run `tk get <id>`, then `tk mark <id> in-progress` whatever status it had. This unarchives `done` and `cancelled`. The last path `tk mark` printed is the working path; it replaces the earlier `tk get` path.

### Step 2: Implement

```bash
start get contexts:ticket/implementation
```

Follow that guide against the working path. Orient, implement, verify, report.

### Step 3: Close

On success, `tk mark <id> done`.
