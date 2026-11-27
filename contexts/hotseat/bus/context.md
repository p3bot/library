# Hotseat bus

Client commands for one chat. This context is not required. An ordinary start does not load it.

## Commands

`run` sets `HOTSEAT_ADDRESS` and, when the bus needs a token, `HOTSEAT_TOKEN_FILE` in your environment. The commands read them, so no command line here carries `--address` or `--token-file`.

- `hotseat chat send <chat> --from <you> --kind <kind> --body <text>` stores one message. Repeat `--to <addressee>` once for each addressee, in that order. Omit `--to` to store an empty addressee list. A read with `--to` does not return that message. Add the optional `--re <seq>` to name the message this one responds to: an earlier message of the same chat. `--body-file <file>` reads the body from a file, and `-` reads stdin
- `hotseat chat read <chat> --cursor <n> --to <you>` returns messages addressed to you. Cursor `0` has seen nothing. `--limit` defaults to `100`. A limit below `1` or above `1000` is refused. An `ok` read prints `more: true` when a further matching message follows the page, and `more: false` otherwise. On `more: true`, read again with the last `seq` printed as `--cursor`
- `hotseat chat read <chat> --cursor <n> --kind <kind>` with no `--to` returns every message of those kinds, whatever its `to`. Repeat `--kind` once for each kind. Use it for findings and stances only, with the kinds the prompt gives. Read every other kind with `--to <you>`
- `hotseat chat join <chat> <you>` records that you have joined. It writes your member row and is not a message
- `hotseat chat members <chat>` returns the rows that exist, in roster order. Each row is a roster name, its status, its launched time, and its joined time. A roster name with no row is left out

## Exit status

Each command above prints `outcome:` and exits by it.

| Exit | Outcome |
| --- | --- |
| 0 | `ok` |
| 1 | Usage or startup error, with nothing on stdout |
| 2 | `refused`, with a `reason` |
| 3 | `timeout` |
| 4 | `unavailable` or `connection_failure` |

A send landed when it exits 0 with `outcome: ok`. `already_stored: true` means an earlier send with the same `--txid` stored it. A send without `--txid` mints one, so a retry without it can store the message twice. Pass the same `--txid` when you retry. Do not retry a `refused` send unchanged.

## Kinds

`instructions`, `turn`, `say`, `ask`, `error`, `settled`, `done`

- `instructions`, `turn`, and `done` have no `re`
- A `say` answering a `turn` has that `turn` as its `re`
- An `ask` has the message it asks about as its `re`, when there is one

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

- Send a `finding` message only when the task or the `turn` text tells you to send the `finding` kind. A request for findings in a `say` is not that. Otherwise follow the task's own flow
- Address findings and stances to every roster name
- In a discussion, stall, or fix launch, read findings and stances with the unnamed read filtered by kind that the prompt gives, and read everything else by your name
- Send exactly one stance in a discussion launch
- As proposer answering an objection, send `propose` to amend, `dismiss` to withdraw, or `stand` to keep the proposal with the reason
- When you need one member's answer next, send one `pass` to that member with your stance. Otherwise do not pass. Do not use `turn` for this
- When you need an owner decision in a discussion launch, send the `ask` and also your best stance, `object` when you cannot accept the proposal. The discussion does not wait for the answer
- Do not send a stance outside your own discussion launch
- Do not pass in a fix launch
- As acting seat, do not send `done` while a finding is unsettled, except for the report after a `deadlock`

## Addressing

- Address people by name
- Do not address `all`
