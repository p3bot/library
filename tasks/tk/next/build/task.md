# Build the Next Ticket

Using tk, build the next available ticket.

The tk skill is assumed installed. Do not re-teach the CLI.

## Sync

When `tk status mode` is `tk-driven`, run `tk sync` first. Skip on repo-driven and plain-files. If sync needs-attention, stop.

After ticket-body edits, `tk sync` again on tk-driven. `next --claim` and `mark` already self-commit.

Do not run `tk doctor` unless `tk next --claim` fails.

## Process

### Step 1: Claim

Run `tk next --claim`. That command honours the lens and only sees `todo`. The last path it prints is the working path. Empty queue: stop. Do not scan for standalone ticket files. Do not call `tasks:ticket/begin`.

### Step 2: Implement

```bash
start get contexts:ticket/implementation
```

Follow that guide against the working path. Orient, implement, verify, report.

### Step 3: Close

On success, `tk mark <id> done`.
