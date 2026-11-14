# Build a Ticket

Build this ticket: work its matched profile.

A ticket document is a standalone markdown document a fresh-session agent can act on. Match its profile from headings.

## Sync

Sync applies to a tk ticket or design. When `tk pulse mode` is `tk-driven`, run `tk sync` before `tk get` or `tk design get`. Skip on repo-driven and plain-files. If sync needs-attention, stop.

After ticket-body edits, `tk sync` again on tk-driven. `mark` already self-commits.

Do not run `tk doctor` unless `tk get` or `tk mark` fails.

## Process

### Step 1: Resolve

The ticket is the instruction: a tk id or a path. If they asked you to find it, look where they pointed. If none was supplied, ask for it. Do not guess or claim the next ticket.

When `command -v tk` fails, a path is an unmanaged ticket. Otherwise, a path under `design/`: run `tk design get` on the full id in its filename, the first two hyphen-separated tokens, and continue from that command below; an id tk does not know leaves it unmanaged. Another path is a tk ticket when its frontmatter has an `id` that `tk get` resolves. Otherwise it is an unmanaged ticket. Its path is the working path, and it has no status to mark.

For a tk id, run `tk get <id>`. Unknown ticket id: run `tk design get <id>`. `design_id:` and no path: stop. Do not `tk mark`. A path with `parse_error:` for that id: stop. The fence is quarantined. Do not mark, do not edit the fence, and do not run the design session or the review. `parse_error: N unparseable` does not quarantine the file just fetched. A path with no per-id `parse_error:` is a design document. Skip the later steps of this task. Do not `tk mark` it. The path `tk design get` printed is the file for this branch. Run the design session against that path:

```bash
start get contexts:design/writing
```

Do not treat the design document as complete. Leave it `draft`. Do not run `tk design mark accepted` in this session. The owner accepts with that command, and decompose runs it when the owner accepts there.

On a tk ticket path, run `tk meta get <id> status`.

A ticket is terminal when that status is `done` or `cancelled`.

- Terminal: stop. Use `tasks:ticket/continue` to reopen
- Otherwise: `tk mark todo <id>`, then `tk mark in-progress <id>`

The working path is the last path `tk mark` printed.

### Step 2: Work

```bash
start get contexts:ticket/implementation
```

Follow that guide against the working path. Orient, work the matched profile, verify, report. Do not invent an Implementation Plan for a profile that has none. Ask the user for input only when genuinely blocked.

- implement: work the plan, update Progress
- design: the implementation guide loads the design session. Fill this legacy design-profile ticket. After the session, the owner accepts, then decompose. Do not `tk mark done`
- decide, investigate: do that profile's work, write it into the body. Create follow-up tickets only after the owner approves
- capture: expand-in-place when possible; otherwise stop
- bug: diagnose and fix, or record Blocked on / Already done when the next step is outside this session

Close owns every `tk mark` after work.

### Step 3: Close

An unmanaged ticket has no status. Skip this step.

Mark from the outcome of this run. Do not leave a finished or stopped profile in `in-progress`.

- implement, decide, investigate, or a bug whose work was a fix — success: `tk mark done <id>`
- bug blocked outside this session: `tk mark blocked <id>`
- capture stop or stub: `tk mark draft <id>`
- legacy design-profile ticket filled and waiting for accept: `tk mark draft <id>`. Do not mark `todo`. Owner accepts, then decompose. A design document does not reach this step
- still mid-work (Progress remains): leave `in-progress`

If capture rewrote in place to another profile, close as that profile.
