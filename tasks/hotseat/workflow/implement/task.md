# Implement workflow

Run four hotseat chats, in order, for one ticket. A stage finishes when its `run` has exited. Stage rule says when the next stage starts.

The ticket id is the instruction on this task. Do not guess one.

The roster needs at least two members. `tasks:hotseat/ticket/review` declares `min_members: 2`, and every stage gets the same roster, so a one-member roster is refused when the workflow reaches that stage.

## Launch

Start the run in the background. `<task>` is the stage's address from Order. Pass `--ticket` and the roster and seat from the chief role.

```bash
hotseat run new <task> --ticket <id> --agents "<roster>" --seat <seat>
```

Read the `chat` line from that run's header. Start attend beside it and let attend run until it exits. A first run's attend keeps the default cursor.

```bash
hotseat chat attend <name>
```

An `ask` is answered by the chief role. It does not finish the stage. An `error` is repair. A `done` ends attend. Read the `done` body.

## Stage rule

1. After attend exits, wait for that stage's `run` to exit. `run` can outlast attend by up to the 30-second grace period for the `done` sender
2. The next stage starts only when `run` exited zero and the `done` body says `outcome: proceed`
3. `outcome: hold`, or no `outcome` line in the `done` body, stops the workflow. An attend that exits non-zero on its own is a lost view, not a stage result. Start a new attend with `--cursor` set to the last seq it printed, or the cursor it started with when it printed none. An attend you stop under rule 4 stays stopped
4. A `run` that exits non-zero never starts the next stage. Stop that stage's attend whenever its `run` exits non-zero, even while attend is still waiting, because a stop with no `done` leaves attend waiting. Name the stop reason from that run's stdout: the `stop` line when present; else no stdout as a run that stopped before its chat existed, with the reason on stderr, such as a roster below the task's minimum; else `outcome: error` after a `chat` line as a continuation whose stored roster is below the task's minimum; else `outcome: error` alone as a run that exited before it held the lease; else the `outcome` value itself; and a `chat` line with no `outcome` line as a crash
5. After a non-zero `run` with the chat still open, you may repair the cause and continue. First read `newest` from `hotseat chat status <name>`. Then start `hotseat run continue <name>` with no setup flag, and a new `hotseat chat attend <name> --cursor <newest>` beside it, so attend does not replay the earlier run's `ask`, `error`, and `done`. The continuation launches from the roster, seat, and permission `run new` stored with the chat. The stage is then judged on that later `run`. A minimum-roster stop cannot be repaired this way, because a `timed-out` member does not come back
6. When the chat is closed, or you cannot repair the cause, a non-zero `run` stops the workflow. A closed chat only replays the same result

## Order

1. `tasks:hotseat/ticket/triage`
2. `tasks:hotseat/ticket/review`
3. `tasks:hotseat/ticket/implement`
4. `tasks:hotseat/pre-commit/review`

The step policy lives in those modules. This task does not restate it.
