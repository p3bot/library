# Orchestrate Work Across Scopes

Using tk, orchestrate work across named scopes. Do not implement tickets.

CWD may not be a source. Do not infer scopes from the working directory. Do not read package graphs or code-roots.

The deliverable is a run: which tickets to execute, in what order, across the boards.

Assume the depends and related may be incorrect or it may have changed. Use depends and related as hints. Ticket content and target determines what it depends on.

A ticket is terminal when its status is `done` or `cancelled`.

## Resolve

The user provided instruction is a list of tk scope names. If none was supplied, ask. Do not guess.

Run `tk scope list`. Every named scope must appear there. Unknown name: stop and ask. Do not drop a name in silence.

Use `--scope` or full ids on every tk command. Do not rely on ambient scope.

## Research

For each named scope, in the order given:

- Sync: when `tk status mode --scope S` is `tk-driven`, run `tk sync --scope S` first. Skip on repo-driven and plain-files. If sync needs-attention, stop that scope and report it
- Board: `tk list --open --no-lens --scope S` to show all non-terminal tickets

Combined count 500 or fewer: for each ticket, `tk get <id>`, `tk deps <id>`, and the body from the path `tk get` printed. Over 500: titles, status, summary, and `tk deps` only. Say that bodies were skipped.

Infer coupling from tickets only: titles, bodies, `depends`, `related`. A prerequisite is when ticket A cannot be correct until ticket B is done. Do not serialise independent work.

## Brief

Report only what the run needs. Then stay.

### Run

The sequence. Number it. Tickets that can run at the same time sit in one band, not a fake chain.

Each line: full id, title, why this position (prerequisite id, or ready, or parallel with …).

### Waiting

Tickets that cannot run yet. Each line: id, what it is waiting on (open prerequisite, other-scope work not done, or assumed work with no ticket).

### Gaps

Work a ticket assumes that no non-terminal ticket in the named scopes covers. Each line: which ticket assumed it, what is missing, which named scope would own it.

Omit a section when it is empty.

Do not add, remove, or rewrite `depends` or `related` unless the user asks. Do not create tickets until they approve a gap fill.

## After the brief

Stay with the user. Walk the run. Apply writes only after they approve the specific command.

If new tickets need to be created:

```bash
start get contexts:ticket/writing
```

Then `tk create <title> --scope S` and fill from that guide. Edit the returned ticket document path.

