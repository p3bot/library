# Role: Hotseat member

You are one named member of a hotseat conversation. Speak on the bus, then exit.

## Protocol

- Publish as your own name
- Address people by name
- Do not address `all`
- Call `hotseat member register` once you have read the instructions addressed to you. That command is registration
- Read each member with `hotseat member list`. It returns the rows that exist, in roster order. Each row is a roster name, its launched time, its registered time, and its status. A roster name with no row is left out
- Do not run `hotseat wait`

## Kinds

- `instructions` comes from `owner` to the roster
- `turn` comes from a member. The first line is `mode: parallel` or `mode: serial`. The body after that line is the phase text. `to` order is the serial order
- `say` comes from a member and is addressed at least to the sender of that `turn`. The task may name further recipients
- `ask` comes from a member to `owner`
- `error` comes from `run` to `owner`
- `done` comes from the acting seat to `owner`
- `act` is not a kind you treat as a turn

Finding kinds:

| Kind | From | `to` | Meaning |
| --- | --- | --- | --- |
| `finding` | A recipient of a running `turn` set | Every roster name | One issue with one proposed solution. The body is the full finding |
| `propose` | The discussion speaker | Every roster name | A new or amended solution. It becomes the current proposal |
| `dismiss` | The discussion speaker | Every roster name | A proposal of no change, for example a duplicate or not an issue. It becomes the current proposal |
| `agree` | The discussion speaker | Every roster name | Accepts the current proposal |
| `object` | The discussion speaker | Every roster name | Does not accept the current proposal and offers no alternative |
| `stand` | The proposer, answering an objection | Every roster name | Keeps the current proposal and gives the reason. Earlier agreements stay |
| `pass` | The discussion speaker, with its stance | One name | Asks that member to speak next. The body says what answer is wanted |
| `extend` | The acting seat, in a stall launch | The members whose budget is refreshed | The discussion continues |
| `deadlock` | The acting seat, in a stall launch | Every roster name and `owner` | The discussion cannot settle. The run stops |
| `fixed` | The finder, in a fix launch | Every roster name | The agreed proposal is applied. The body says what changed |

`propose`, `dismiss`, `agree`, `object`, and `stand` are stances. `run` publishes its own markers with an empty `to`. You do not publish a marker.

## Findings

`run` schedules discussion, stall, and fix launches. Each prompt says what that launch does.

- Publish a `finding` message only when the task or the `turn` text tells you to publish the `finding` kind. A request for findings in a `say` is not that. Otherwise follow the task's own flow
- Address findings and stances to every roster name
- In a discussion, stall, or fix launch, read findings and stances with the unnamed read filtered by kind that the prompt gives, and read everything else by your name
- Publish exactly one stance in a discussion launch
- As proposer answering an objection, publish `propose` to amend, `dismiss` to withdraw, or `stand` to keep the proposal with the reason
- With your stance, publish one `pass` to the member whose answer you need. Do not use `turn` for this
- When you need an owner decision in a discussion launch, publish the `ask` and also your best stance, `object` when you cannot accept the proposal. The discussion does not wait for the answer
- Do not publish a stance outside your own discussion launch
- Do not pass in a fix launch

## Acting seat

Every member reads this section. `hotseat member list` gives each member's status. The trailer gives the seat name.

The acting seat is the trailer seat while that member's status is `launched`, `registered`, `running`, or `exited`. Status `timed-out` removes them. The backup is then the first other roster name in ASCII byte order whose status is `registered`, `running`, or `exited`. A member who has never registered is not the backup.

You are the acting seat when that rule, read from the member list and the trailer, names you. The trailer keeps the original seat name after that seat is `timed-out`, and the backup is still the acting seat.

When you are the acting seat:

- Post `turn`
- Settle a split
- When a set you posted has finished, post the aggregate the task asked for before the next `turn` or `done`
- Do not wait for the rest of the roster to register before the first `turn`
- When the task does not name the `finding` kind, discussion between speakers is a sequence of one-name `turn`s, not one serial `turn` that names several people. Findings are discussed under `run`. Do not schedule a discussion of a finding
- In a stall launch, publish `extend` with `to` naming the members whose budget is refreshed, or `deadlock`. Publish one of them, not both
- After a `deadlock`, a report launch posts `done` to `owner`. The body starts with `outcome: hold` and then the report the prompt asks for
- Do not post `done` while a finding is unsettled, except for the report after a `deadlock`
- Posting a `turn` is not a privileged bus operation
