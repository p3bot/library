# Reorder the Board

Using tk, fix the sequence of the board.

Do not claim, unclaim, or mark done. Do not do status hygiene. If you notice a status-hygiene item, name it once and leave it.

Do not add or remove `related`. `tk next` is lens plus `todo` only; do not reorder to fix next for tickets the current lens will skip.

A ticket is terminal when its status is `done` or `cancelled`.

## Prepare

- Sync: when `tk status mode` is `tk-driven`, run `tk sync` first. Skip on repo-driven and plain-files. If sync needs-attention, stop.
- Doctor: Run bare `tk doctor`. Mechanical `--repair` if those tokens are present. `--repair` rewrites ids, equal order keys, and archive layout. State what it will do before running it.

### Inventory

- Board: Run `tk list --all --no-lens` to get the full non-terminal set - TSV columns: id, status, title.
- Ignore every terminal row
- Do not use `tk status` counts as the board. They are lens-filtered.

## Sequence

Order is one global sequence. Status is orthogonal. Do not regroup by status.

A fixed sequence:

- Each `depends` prerequisite sits before its dependent
- `todo` and `in-progress` do not sit after the backlog tail unless you call that out as an exception
- Related tickets that are the same change sit adjacent; thematic related can stay put
- Fewest moves that fix inversions and split pairs. Do not restack by theme or by your sense of product urgency
- Two legal sequences that disagree on priority: ask

Keep `in-progress` as an order anchor unless it is in the wrong band. Do not unclaim `in-progress` just because this machine did not claim it.

## Depends

Add `depends` only when A cannot be correct until B is done. Do not add `depends` to serialise independent work, to pin a draft to an epic, or to encode related.

Existing inversions (dependent before prerequisite) are in scope even if you add no new edges.

Leftover doctor residue in scope here is every token whose name starts with `depends_`, plus `order_long`. Include those tokens in the proposal. Resolve `depends_*` with `tk meta add|rm depends` or reorder, not mark. This is not a second diagnosis. Empty or unreadable order keys: `tk reorder` onto an existing ticket. Equal order keys are `--repair` (already in Doctor). Do not route every `schema_error` here.

## Process

1. Read the inventoried tickets. For each: order key, `tk deps`, summary. Also read bodies when the non-terminal count is 500 or fewer. Over 500, skip bodies
2. Propose. Report only the moves. Number them. Each reorder line: id, `--before` / `--after` / `--first` / `--last` target, why. Each depends line: `tk meta add|rm depends`. Then name the unchanged bands. Omit clean categories
3. After approval, on tk-driven: `tk sync` again, then `tk list --all --no-lens` again. If an `--after` / `--before` anchor moved, stop and re-propose. Do not apply a stale plan
4. Apply only after that check: `tk reorder`, `tk meta add|rm depends`. Apply the listed commands in order; each `--after` / `--before` is relative to the board at that step. `--re-space-order` after those writes when `order_long` is present
5. After apply: `tk list --all --no-lens`; `tk deps` on every id you touched; confirm every remaining `depends` edge has the prerequisite earlier; bare `tk doctor`. On tk-driven, `tk sync` again (mutators self-commit and still need a push)
