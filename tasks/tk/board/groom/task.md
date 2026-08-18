# Groom the Board

Using tk, groom the board.

The tk skill is assumed installed. Do not re-teach the CLI.

Do not reorder. Do not add, remove, or rewrite depends. Do not run `--re-space-order`.

## Sync

When `tk status mode` is `tk-driven`, run `tk sync` first. Skip on repo-driven and plain-files. If sync needs-attention, stop.

## Doctor

Run bare `tk doctor`. Mechanical `--repair` if those tokens are present. `--repair` rewrites ids, equal order keys, and archive layout. State what it will do before running it.

## Inventory

```bash
tk list --all --no-lens
```

Drop every terminal row. A ticket is terminal when its path is under `archive/`, or when its status is `done` or `cancelled`. That is the full non-terminal set on every machine: backlog stays, terminals go, the lens is off.

## Process

One findings list:

- Leftover doctor residue except tokens whose names start with `depends_` and `order_long`
- Status hygiene: stale `in-progress`, `blocked` with no path, `draft` that is ready, empty `todo`, parked `review`, `backlog` that should come up

Propose, then apply only after approval. Apply with `tk mark`. Use `tk meta` only for a non-depends field a hygiene finding needs.
