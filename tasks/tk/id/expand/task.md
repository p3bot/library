# Expand a Ticket

Using tk, expand this ticket to the ticket writing guide.

`contexts:ticket/writing` is fetched later. This envelope is the only binding source for path, edits, and status.

## Sync

When `tk status mode` is `tk-driven`, run `tk sync` first. Skip on repo-driven and plain-files. If sync needs-attention, stop.

After ticket-body edits, `tk sync` again on tk-driven. `mark` already self-commits.

Do not run `tk doctor` unless `tk get` or `tk mark` fails.

## Process

### Step 1: Resolve

The ticket id is the instruction. If none was supplied, ask for it. Do not guess or claim the next ticket.

Run `tk get <id>`. Apply the terminal test to that path and status before any mark.

A ticket is terminal when the path is under `archive/`, or when its status is `done` or `cancelled`.

- Terminal: ask whether to expand and reopen as `draft`. Explicit no: stop, leave the ticket terminal. Explicit yes: `tk mark draft <id>` and proceed
- Leave `in-progress`, `blocked`, `todo`, `backlog`, `review`, and `draft` alone

The working path is the last path printed by `tk get` or `tk mark`. After a reopen-as-`draft` mark, that printed path replaces the earlier get path.

### Step 2: Match

```bash
start get contexts:ticket/writing
```

The guide is the single source of truth for structure, sections, formatting, principles, profiles, and the stub test.

Run that guide's stub test against the working path. Classify:

- stub — the stub test fails. This is a Match failure
- capture — the match is capture. Not a stub. Not a Match failure
- other — any other matching profile. Say so and stop. Do not rewrite. Quality of the plan is `tasks:tk/id/review`, not this task

This task: on stub or capture, go to Write. Callers that Write only on Match failure write stubs only.

Missing Requirements is not a stub when the headings match capture, bug, investigate, decide, or design.

### Step 3: Write

Investigate first. Read the ticket. Read the relevant files, configuration, and behaviour. Keep useful content from the body; fold it into the right sections later. Do not re-ask facts the ticket already states.

If the match is capture, promote to implement (or design, decide, or investigate when that is the work). Do not leave it as capture.

If the match is stub, rewrite into the profile the work actually is (often capture or implement), not always implement.

If the ticket plus the codebase is enough to fill that profile's required identifying headings without inventing an owner decision, write. Do not interview. Do not hold a design session.

An owner decision is a choice a competent agent cannot settle from the repo: what the user meant, where the boundary is, which approach, what done looks like when several readings fit.

If owner decisions remain, hold a design session before writing:

- Say what you think the ticket is, and what you cannot settle
- For each unknown: the options, your recommendation, why
- Right-size the conversation. One unknown is one question. Several related unknowns are one short exchange
- Do not send a section questionnaire
- Do not write a separate design document. Resolutions belong in the ticket
- Do not guess. Wait
- If the work is more than one implementation pass, say so before writing

Then rewrite under the H1 following the loaded guide. Right-size: omit any optional section that does not apply. Keep identifying headings even when empty. Record References for sources consulted. Preserve the YAML frontmatter. Do not change status here.

### Step 4: Status

Never auto-promote to `todo`. Do not change status except the terminal reopen in Step 1.
