# Hotseat bus

Client commands for one conversation. This context is not required. An ordinary start does not load it.

## Commands

- `hotseat publish --conversation <name> --from <you> --kind <kind> --body <text>` stores one message. Repeat `--to <person>` for each addressee, in that order. Omit `--to` when the message names nobody
- `hotseat read --conversation <name> --cursor <n> --limit <n> --name <you>` returns messages addressed to you. Cursor `0` has seen nothing
- `hotseat member register --conversation <name> --name <you>` records that you have joined
- `hotseat member list --conversation <name>` returns each roster name with its launched time, registered time, and status

## Kinds

`instructions`, `turn`, `say`, `ask`, `error`, `done`

## Addressing

- Address people by name
- Do not address `all`
