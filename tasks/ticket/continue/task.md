# Continue a Ticket

Continue this ticket.

## Sync

Sync applies to a tk ticket or design. When `tk pulse mode` is `tk-driven`, run `tk sync` before `tk get` or `tk design get`. Skip on repo-driven and plain-files. If sync needs-attention, stop.

After ticket-body edits, `tk sync` again on tk-driven. `mark` already self-commits.

Do not run `tk doctor` unless `tk get` or `tk mark` fails.

## Process

### Step 1: Resolve

The ticket is the instruction: a tk id or a path. If they asked you to find it, look where they pointed. If none was supplied, ask for it. Do not guess or claim the next ticket.

When `command -v tk` fails, a path is an unmanaged ticket. Otherwise, a path under `design/`: run `tk design get` on the full id in its filename, the first two hyphen-separated tokens, and continue from that command below; an id tk does not know leaves it unmanaged. Another path is a tk ticket when its frontmatter has an `id` that `tk get` resolves. Otherwise it is an unmanaged ticket. Its path is the working path, and it has no status to mark.

For a tk id, run `tk get <id>`. Unknown ticket id: run `tk design get <id>`. `design_id:` and no path: stop. Do not `tk mark`. A path with `parse_error:` for that id: stop. The fence is quarantined. Do not mark, do not edit the fence, and do not run the design session or the review. `parse_error: N unparseable` does not quarantine the file just fetched. A path with no per-id `parse_error:` is a design document. Skip the later steps of this task. Do not `tk mark` it. The path `tk design get` printed is the file for this branch. Edit under its H1. When the shape is still open, run the design session against that path:

```bash
start get contexts:design/writing
```

On a tk ticket path, `tk mark in-progress <id>` whatever status it had. This unarchives `done` and `cancelled`. The last path `tk mark` printed is the working path; it replaces the earlier `tk get` path.

### Step 2: Work

```bash
start get contexts:ticket/implementation
```

Follow that guide against the working path. Orient, work the matched profile, verify, report. Same profile rules as `tasks:ticket/build`. Do not invent an Implementation Plan for a profile that has none.

### Step 3: Close

An unmanaged ticket has no status. Skip this step.

Same Close table as `tasks:ticket/build`. Mark from the outcome of this run. Do not leave a finished or stopped profile in `in-progress`.

- implement, decide, investigate, or a bug whose work was a fix — success: `tk mark done <id>`
- bug blocked outside this session: record Blocked on / Already done and `tk mark blocked <id>`
- capture stop or stub: `tk mark draft <id>`
- legacy design-profile ticket filled and waiting for accept: `tk mark draft <id>`. Do not mark `todo`. Owner accepts, then decompose. A design document does not reach this step
- still mid-work (Progress remains): leave `in-progress`

If capture rewrote in place to another profile, close as that profile.
