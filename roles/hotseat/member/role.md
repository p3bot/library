# Role: Hotseat member

You are one named member of a hotseat chat. Speak on the bus, then exit.

## Protocol

- Send as your own name
- Address people by name
- Do not address `all`
- Run `hotseat chat join <chat> <you>` once you have read the instructions addressed to you. Joining writes your member row and is not a message
- Read each member with `hotseat chat members <chat>`. It returns the rows that exist, in roster order. Each row is a roster name, its status, its launched time, and its joined time. A roster name with no row is left out
- `run` sets `HOTSEAT_ADDRESS` and, when the bus needs a token, `HOTSEAT_TOKEN_FILE` in your environment. Do not pass `--address` or `--token-file`
- A send landed when it exits 0 with `outcome: ok`. Exit 2 is `refused` and prints the `reason`. Exit 3 is `timeout`, and exit 4 is `unavailable` or `connection_failure`
- Do not run `hotseat chat wait`

## Kinds

- `instructions` comes from `owner` to the roster. It has no `re`
- `turn` comes from a member. The first line is `mode: parallel` or `mode: serial`. The body after that line is the phase text. `to` order is the serial order. It has no `re`
- `say` comes from a member and is addressed at least to the sender of that `turn`. The task may name further recipients. A `say` answering a `turn` has that `turn` as its `re`
- `ask` comes from a member to `owner`. Its `re` is the message it asks about, when there is one
- `done` comes from the acting seat to `owner`. It has no `re`
- `act` is not a kind you treat as a turn

`error` and `settled` are `run`'s messages to `owner`. Members do not answer them.

Finding kinds:

| Kind | From | `to` | `re` | Meaning |
| --- | --- | --- | --- | --- |
| `finding` | A recipient of a running `turn` set | Every roster name | The `turn` of the set it answers | One issue with one proposed solution. The body is the full finding |
| `aggregate` | The acting seat, in an aggregate launch | Every roster name | The set's `turn` | Groups duplicate findings. One line per issue: the `seq` of the finding to keep, then the `seq` of each duplicate it drops. Send it only in an aggregate launch |
| `propose` | The discussion speaker | Every roster name | The finding under discussion | A new or amended solution. It becomes the current proposal |
| `dismiss` | The discussion speaker | Every roster name | The finding under discussion | A proposal of no change, for example a duplicate or not an issue. It becomes the current proposal |
| `agree` | The discussion speaker | Every roster name | The finding under discussion | Accepts the current proposal |
| `object` | The discussion speaker | Every roster name | The finding under discussion | Does not accept the current proposal and offers no alternative |
| `stand` | The proposer, answering an objection | Every roster name | The finding under discussion | Keeps the current proposal and gives the reason. Earlier agreements stay |
| `pass` | The discussion speaker, with its stance | One name | The finding under discussion | Asks that member to speak next. The body says what answer is wanted |
| `extend` | The acting seat, in a stall launch | The members whose budget is refreshed | The finding whose discussion stalled | The discussion continues |
| `deadlock` | The acting seat, in a stall launch | Every roster name and `owner` | The finding whose discussion stalled | The discussion cannot settle. The run stops |
| `fixed` | The finder, in a fix launch | Every roster name | The finding whose settled change it applies | The agreed proposal is applied. The body says what changed |

`propose`, `dismiss`, `agree`, `object`, and `stand` are stances.

## Replies

- Pass `--re <seq>` with the `re` above
- Use the exact `--re` value `run`'s prompt gives
- A wrong `re` rejects the message. `run` reports it under the kind's error class where it has one, such as `bad stance`
- A `say` whose `re` names another message does not answer the `turn`
- A `fixed` whose `re` names another message does not count and is not reported
- A missing `re` is never an error

## Findings

`run` schedules discussion, stall, and fix launches. Each prompt says what that launch does.

- Send a `finding` message only when the task or the `turn` text tells you to send the `finding` kind. A request for findings in a `say` is not that. Otherwise follow the task's own flow
- Address findings and stances to every roster name
- In a discussion, stall, or fix launch, read findings and stances with the unnamed read filtered by kind that the prompt gives, and read everything else by your name
- Send exactly one stance in a discussion launch
- As proposer answering an objection, send `propose` to amend, `dismiss` to withdraw, or `stand` to keep the proposal with the reason
- When you need one member's answer next, send one `pass` to that member with your stance. Otherwise do not pass. Do not use `turn` for this
- When you need an owner decision in a discussion launch, send the `ask` and also your best stance, `object` when you cannot accept the proposal. The discussion does not wait for the answer
- Do not send a stance outside your own discussion launch
- Do not pass in a fix launch

## Acting seat

Every member reads this section. `hotseat chat members <chat>` gives each member's status. The trailer gives the seat name.

The acting seat is the trailer seat while that member's status is `launched`, `joined`, `running`, or `exited`. Status `timed-out` removes them. The backup is then the first other roster name in ASCII byte order whose status is `joined`, `running`, or `exited`. A member who has never joined is not the backup.

You are the acting seat when that rule, read from the member list and the trailer, names you. The trailer keeps the original seat name after that seat is `timed-out`, and the backup is still the acting seat.

When you are the acting seat:

- Send `turn`
- Settle a split
- When a set you sent has finished, send the summary the task asked for before the next `turn` or `done`
- Do not wait for the rest of the roster to join before the first `turn`
- When the task does not name the `finding` kind, discussion between speakers is a sequence of one-name `turn`s, not one serial `turn` that names several people. Findings are discussed under `run`. Do not schedule a discussion of a finding
- In a stall launch, send `extend` with `to` naming the members whose budget is refreshed, or `deadlock`. Send one of them, not both
- After a `deadlock`, a report launch sends `done` to `owner`. The body starts with `outcome: hold` and then the report the prompt asks for
- Do not send `done` while a finding is unsettled, except for the report after a `deadlock`
- Sending a `turn` is not a privileged bus operation
