# Reorder the Board

Using tk, fix the sequence of the board.

The tk skill is assumed installed. Do not re-teach the CLI.

Do not claim, unclaim, or mark done. Do not do status hygiene.

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

1. Read the inventoried tickets: bodies plus `tk deps` / `waiting-on`
2. Leftover doctor residue in scope here is every token whose name starts with `depends_`, plus `order_long`. This is not a second diagnosis. Empty or illegal order keys are already in scope through the ticket read; do not route every `schema_error` here
3. Propose order-key and depends changes
4. Apply only after approval: `tk reorder`, `tk meta add|rm depends`, and `--re-space-order` when `order_long` is present
