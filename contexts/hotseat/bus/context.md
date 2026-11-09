# Hotseat bus

Client commands for one conversation. This context is not required. An ordinary start does not load it.

## Commands

- `hotseat publish --conversation <name> --from <you> --kind <kind> --body <text>` stores one message. Repeat `--to <addressee>` once for each addressee, in that order. Omit `--to` to store an empty addressee list. A read with `--name` does not return that message
- `hotseat read --conversation <name> --cursor <n> --limit <n> --name <you>` returns messages addressed to you. The limit is a positive integer. A limit of `0` is refused. Cursor `0` has seen nothing
- `hotseat read --conversation <name> --cursor <n> --limit <n> --kind <kind>` with no `--name` returns every message of those kinds, whatever its `to`. Repeat `--kind` once for each kind. Use it for findings and stances only, with the kinds the prompt gives. Read every other kind with `--name <you>`
- `hotseat member register --conversation <name> --name <you>` records that you have joined
- `hotseat member list --conversation <name>` returns the rows that exist, in roster order. Each row is a roster name, its launched time, its registered time, and its status. A roster name with no row is left out

## Kinds

`instructions`, `turn`, `say`, `ask`, `error`, `done`

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

`propose`, `dismiss`, `agree`, `object`, and `stand` are stances. `run` publishes its own markers with an empty `to`. A member does not publish a marker.

## Findings

- Publish a `finding` message only when the task or the `turn` text tells you to publish the `finding` kind. A request for findings in a `say` is not that. Otherwise follow the task's own flow
- Address findings and stances to every roster name
- In a discussion, stall, or fix launch, read findings and stances with the unnamed read filtered by kind that the prompt gives, and read everything else by your name
- Publish exactly one stance in a discussion launch
- As proposer answering an objection, publish `propose` to amend, `dismiss` to withdraw, or `stand` to keep the proposal with the reason
- With your stance, publish one `pass` to the member whose answer you need. Do not use `turn` for this
- When you need an owner decision in a discussion launch, publish the `ask` and also your best stance, `object` when you cannot accept the proposal. The discussion does not wait for the answer
- Do not publish a stance outside your own discussion launch
- Do not pass in a fix launch
- As acting seat, do not post `done` while a finding is unsettled, except for the report after a `deadlock`

## Addressing

- Address people by name
- Do not address `all`
