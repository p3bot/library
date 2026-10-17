# Implement workflow

Run four hotseat conversations, in order, for one ticket. Start the next only after `hotseat attend` exits and the `done` body says `outcome: proceed`.

The ticket id is the instruction on this task. Do not guess one.

## Launch

Start the run in the background. Pass `--ticket` and the roster and seat from the chief role.

```bash
hotseat run <address> --ticket <id> --agents "<roster>" --seat <seat>
```

Read the `conversation` line from that run. Start attend beside it and let attend run until it exits.

```bash
hotseat attend --conversation <name>
```

An `ask` is answered by the chief role. It does not finish the stage. An `error` is repair. A `done` finishes the stage.

Read the `done` body.

- `outcome: proceed` starts the next address
- `outcome: hold`, a missing outcome line, or a non-zero attend stops the workflow

## Order

1. `tasks:hotseat/ticket/triage`
2. `tasks:hotseat/ticket/review`
3. `tasks:hotseat/ticket/implement`
4. `tasks:hotseat/pre-commit/review`

The step policy lives in those modules. This task does not restate it.
