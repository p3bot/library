# Build a Ticket

Using tk, build this ticket.

## Sync

When `tk status mode` is `tk-driven`, run `tk sync` first. Skip on repo-driven and plain-files. If sync needs-attention, stop.

After ticket-body edits, `tk sync` again on tk-driven. `mark` already self-commits.

Do not run `tk doctor` unless `tk get` or `tk mark` fails.

## Process

### Step 1: Resolve

The ticket id is the instruction. If none was supplied, ask for it. Do not guess. Do not fall back to `tk next`.

Run `tk get <id>`, then `tk meta get <id> status`.

A ticket is terminal when that status is `done` or `cancelled`.

- Terminal: stop. Use `tasks:tk/id/continue` to reopen
- Otherwise: `tk mark todo <id>`, then `tk mark in-progress <id>`

The working path is the last path `tk mark` printed.

### Step 2: Implement

```bash
start get contexts:ticket/implementation
```

Follow that guide against the working path. Orient, implement, verify, report.

### Step 3: Close

On success, `tk mark done <id>`.
