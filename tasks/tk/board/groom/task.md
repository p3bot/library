# Groom the Board

Using tk, groom the board.

Do not reorder. Do not add, remove, or rewrite depends. Do not run `--re-space-order`.

Never propose `draft` → `todo`. That mark is a user action.

A ticket is terminal when its status is `done` or `cancelled`.

## Prepare

- Sync: when `tk status mode` is `tk-driven`, run `tk sync` first. Skip on repo-driven and plain-files. If sync needs-attention, stop.
- Doctor: Run bare `tk doctor`. Mechanical `--repair` if those tokens are present. `--repair` rewrites ids, equal order keys, and archive layout. State what it will do before running it.

### Inventory

- Board: Run `tk list --all --no-lens` to get the full non-terminal set
- Ignore every terminal row
- Do not use `tk status` counts as the board. They are lens-filtered.

## Process

Look for:

- Leftover doctor residue except tokens whose names start with `depends_` and `order_long`
- Status hygiene: stale `in-progress`, `blocked` with no path, empty `todo`, parked `review`, `backlog` that should come up
- Stub in `todo`: read each `todo` body. No writing-guide section headings under the H1, or the body is primarily a log or paste. Propose `tk mark <id> draft`. Do not expand

Do not unclaim `in-progress` just because this machine did not claim it. Ask if the owner is unclear.

Report only items that need a decision. Number them. Each line: id or path, what is wrong, the proposed command or delete. Omit clean categories.

Propose, then apply only after approval.

- `tk mark` for status
- Delete or move stray `non_allowlist` paths
- `tk meta` only for a non-depends field a hygiene finding needs

Re-run bare `tk doctor` and if needed `tk sync` after residue cleanup.

