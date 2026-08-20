# Expand a Ticket

Using tk, expand this ticket to the ticket writing guide.

`contexts:ticket/writing` is fetched later. This envelope is the only binding source for path, edits, and status.

## Sync

When `tk status mode` is `tk-driven`, run `tk sync` first. Skip on repo-driven and plain-files. If sync needs-attention, stop.

After ticket-body edits, `tk sync` again on tk-driven. `mark` already self-commits.

Do not run `tk doctor` unless `tk get` or `tk mark` fails.

## Process

### Step 1: Resolve

The ticket id is the instruction. If none was supplied, ask for it. Do not guess. Do not fall back to `tk next`.

Run `tk get <id>`. Apply the terminal test to that path and status before any mark.

A ticket is terminal when the path is under `archive/`, or when its status is `done` or `cancelled`.

- Terminal: ask whether to expand and reopen as `draft`. Explicit no: stop, leave the ticket terminal. Explicit yes: `tk mark <id> draft` and proceed
- Leave `in-progress`, `blocked`, `todo`, `backlog`, `review`, and `draft` alone

The working path is the last path printed by `tk get` or `tk mark`. After a reopen-as-`draft` mark, that printed path replaces the earlier get path.

### Step 2: Match

```bash
start get contexts:ticket/writing
```

The guide is the single source of truth for structure, sections, formatting, and principles.

A ticket matches when a fresh-session implementer could execute it from the document alone, and the body uses the guide's section headings for the sections it includes.

Treat it as a stub if any of these hold:

- No writing-guide section headings under the H1
- Primary content is a log, paste, or error dump
- Missing Goal, missing Requirements, or missing Acceptance Criteria
- Relies on conversation context ("as discussed", "you can see below")

A thin ticket that still has those sections matches. Quality of the plan is `tasks:tk/id/review`, not this task.

If it matches: say so and stop. Do not rewrite.

### Step 3: Write

Investigate first. Read the stub. Read the relevant files, configuration, and behaviour. Keep useful content from the stub; fold it into the right sections later. Do not re-ask facts the stub already states.

If the stub plus the codebase is enough to write Goal, Scope, Requirements, and Acceptance Criteria without inventing an owner decision, write. Do not interview. Do not hold a design session.

An owner decision is a choice a competent agent cannot settle from the repo: what the user meant, where the boundary is, which approach, what done looks like when several readings fit.

If owner decisions remain, hold a design session before writing:

- Say what you think the ticket is, and what you cannot settle
- For each unknown: the options, your recommendation, why
- Right-size the conversation. One unknown is one question. Several related unknowns are one short exchange
- Do not send a section questionnaire (Goal, Scope, Requirements, ...)
- Do not write a separate design document. Resolutions belong in the ticket
- Do not guess. Wait
- If the work is more than one implementation pass, say so before writing

Then rewrite under the H1 following the loaded guide. Right-size: omit any optional section that does not apply. Record References for sources consulted. Draft the Implementation Plan from the settled requirements and current state. Preserve the YAML frontmatter. Do not change status here.

### Step 4: Status

Never auto-promote to `todo`. Do not change status except the terminal reopen in Step 1.
