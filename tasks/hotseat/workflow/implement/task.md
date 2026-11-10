# Implement workflow

Run four hotseat conversations, in order, for one ticket. A stage finishes when its `hotseat run` has exited. Stage rule says when the next stage starts.

The ticket id is the instruction on this task. Do not guess one.

The roster needs at least two members. `tasks:hotseat/ticket/review` declares `min_members: 2`, and every stage gets the same roster, so a one-member roster is refused when the workflow reaches that stage.

## Launch

Start the run in the background. Pass `--ticket` and the roster and seat from the chief role.

```bash
hotseat run <address> --ticket <id> --agents "<roster>" --seat <seat>
```

Read the `conversation` line from that run. Start attend beside it and let attend run until it exits.

```bash
hotseat attend --conversation <name>
```

An `ask` is answered by the chief role. It does not finish the stage. An `error` is repair. A `done` ends attend. Read the `done` body.

## Stage rule

1. After attend exits, wait for that stage's `hotseat run` to exit. `run` can outlast attend by up to the 30-second grace period for the `done` sender
2. The next stage starts only when `run` exited zero and the `done` body says `outcome: proceed`
3. `outcome: hold`, a missing outcome line, or a non-zero attend stops the workflow
4. A `run` that exits non-zero never starts the next stage, even while attend is still waiting. A launch-cap or minimum-roster stop has no `done`, so attend does not exit on its own. Stop that attend
5. After a non-zero `run` with the conversation still open, you may repair the cause and continue with `hotseat run --conversation <name>`, the same roster and seat, and a new attend beside it. Without the roster, the continuation does not launch. The stage is then judged on that later `run`. A minimum-roster stop cannot be repaired this way, because a `timed-out` member does not come back
6. When the conversation is closed, or you cannot repair the cause, a non-zero `run` stops the workflow. A closed conversation only replays the same result

## Order

1. `tasks:hotseat/ticket/triage`
2. `tasks:hotseat/ticket/review`
3. `tasks:hotseat/ticket/implement`
4. `tasks:hotseat/pre-commit/review`

The step policy lives in those modules. This task does not restate it.
