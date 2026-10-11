# Hotseat bus

Client commands for one conversation. This context is not required. An ordinary start does not load it.

## Commands

- `hotseat publish --conversation <name> --from <you> --kind <kind> --body <text>` stores one message. Repeat `--to <addressee>` once for each addressee, in that order. Omit `--to` to store an empty addressee list. A read with `--name` does not return that message
- `hotseat read --conversation <name> --cursor <n> --limit <n> --name <you>` returns messages addressed to you. The limit is a positive integer. A limit of `0` is refused. Cursor `0` has seen nothing
- `hotseat member register --conversation <name> --name <you>` records that you have joined
- `hotseat member list --conversation <name>` returns the rows that exist, in roster order. Each row is a roster name, its launched time, its registered time, and its status. A roster name with no row is left out

## Kinds

`instructions`, `turn`, `say`, `ask`, `error`, `done`

## Addressing

- Address people by name
- Do not address `all`
