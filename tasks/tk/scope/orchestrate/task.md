# Orchestrate Work Across Scopes

Using tk, orchestrate work across named scopes.

CWD is not a source. Do not infer scopes from the working directory. Do not read package graphs or code-roots.

The deliverable is a run: which tickets to execute, in what order, across the boards. Linking tickets is not the goal. Do not `tk order`. Leave board sequence to `tasks:tk/board/reorder`. Leave status hygiene to `tasks:tk/board/groom`.

Do not implement tickets during research.

A ticket is terminal when its status is `done` or `cancelled`.

## Load

If the tk skill is not already in context, run `tk skill` and follow it.

## Resolve

The instruction is tk scope names, separated by whitespace. If none was supplied, ask. Do not guess.

Run `tk scope list`. Every named scope must appear there. Unknown name: stop and ask. Do not drop a name in silence.

Use `--scope` or full ids on every tk command. Do not rely on ambient scope.

## Research

For each named scope, in the order given:

- Sync: when `tk status mode --scope S` is `tk-driven`, run `tk sync --scope S` first. Skip on repo-driven and plain-files. If sync needs-attention, stop that scope and report it
- Board: `tk list --all --no-lens --scope S`
- Ignore every terminal row
- Do not use `tk status` counts as the board. They are lens-filtered

Combined non-terminal count 500 or fewer: for each ticket, `tk get <id>`, `tk deps <id>`, and the body from the path `tk get` printed. Over 500: titles, status, summary, and `tk deps` only. Say that bodies were skipped.

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

When they approve a gap ticket:

```bash
start get contexts:ticket/writing
```

Then `tk create --scope S` and fill from that guide. Do not write ticket files yourself.

When they want to run a ticket now:

```bash
start get tasks:tk/id/continue
```

Use that ticket's full id as the instruction. After it, return to this run if work remains.

On tk-driven, `tk sync --scope S` after ticket-body edits. `mark` already self-commits.
