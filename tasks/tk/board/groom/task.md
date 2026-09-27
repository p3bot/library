# Groom the Board

Using tk, groom the board.

Do not reorder. Do not add, remove, or rewrite depends. Do not run `--re-space-order`.

Never propose `draft` → `todo`. That mark is a user action.

A ticket is terminal when its status is `done` or `cancelled`.

## Prepare

- Sync: when `tk pulse mode` is `tk-driven`, run `tk sync` first. Skip on repo-driven and plain-files. If sync needs-attention, stop.
- Doctor: Run bare `tk doctor`. Mechanical `tk repair` when the findings are id collisions, equal order keys, or archive layout. State what it will do before running it. `design_id:` and `produces_dangling:` are diagnose-only. Report them. Do not send them to `tk repair`. A design `parse_error:` is not a `tk repair` input. Repair does not rename a design file. Do not `tk design mark` or `tk design meta` a design until its fence parses.

### Inventory

- Board: Run `tk list --all --no-lens` to get the full non-terminal set
- Designs: Run `tk design list` for `draft` and `accepted`. Use `--all` only when hunting `decomposed`, `superseded`, or an unknown status
- Ignore every terminal ticket row
- Do not use `tk pulse` counts as the board. They are lens-filtered.

## Process

Look for leftover doctor residue except tokens whose names start with `depends_` and `order_long`. Look for status hygiene on the inventory: stale `in-progress`, `blocked` with no path, empty `todo`, parked `review`, `backlog` that should come up.

```bash
start get contexts:ticket/writing
```

Run that guide's matcher and stub test on each `todo` body:

- Capture in `todo`: the match is capture. Premature for `tk next`. Propose `tk mark draft <id>` or `tk mark backlog <id>`. Do not call a matching capture a stub. Do not expand
- Stub in `todo`: the stub test fails. Propose `tk mark draft <id>`. Do not expand
- Unknown design status (`schema_error:` on a path under `design/`): propose `tk design mark` to one of `draft`, `accepted`, `decomposed`, `superseded`. Do not `tk meta set` a design
- `design_id:` or `produces_dangling:`: report the doctor line. Do not repair it and do not rewrite the fence by hand
- Design `parse_error:` on a path under `design/`: report the doctor line. Do not send it to `tk repair`. Do not `tk design mark` or `tk design meta` until the fence parses. Propose an in-place repair that keeps the path, the id, and `created`, and restores status and `produces` only when the broken text already shows them. Apply it only after approval. If the fence carries conflict markers, stop and report the line for the owner

Do not unclaim `in-progress` just because this machine did not claim it. Ask if the owner is unclear.

Report only items that need a decision. Number them. Each line: id or path, what is wrong, the proposed command or delete. Omit clean categories.

Propose, then apply only after approval.

- `tk mark` for status
- Delete or move stray `non_allowlist` paths
- `tk meta` only for a non-depends field a hygiene finding needs

Re-run bare `tk doctor` and if needed `tk sync` after residue cleanup.

