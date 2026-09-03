# Build the Next Ticket

Using tk, build the next available ticket.

## Process

### Step 1: Fetch

```bash
start get tasks:tk/id/build
```

### Step 2: Select

Run `tk next`. That command honours the lens and only sees `todo`. The last path it prints is the ticket. Empty queue: stop. Do not scan for standalone ticket files. Do not call `tasks:ticket/begin`.

The ticket id is the `id` field in that file.

Do not run `tk doctor` unless `tk next` fails.

### Step 3: Build

Follow the fetched task with that id. Do not ask for an id. Custom instructions still apply.
