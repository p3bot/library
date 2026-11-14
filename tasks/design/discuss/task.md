# Discuss a Design

Brief first. Then work with the user on whatever follows.

The design is a design document, a legacy design-profile ticket, or a leftover unmanaged design document.

## Sync

Sync applies to a design or ticket in a tk scope. When `tk pulse mode` is `tk-driven`, run `tk sync` before `tk design get`. Skip on repo-driven and plain-files. If sync needs-attention, stop.

After body edits, `tk sync` again on tk-driven. `tk design mark` and `tk mark` already self-commit.

Do not run `tk doctor` unless `tk design get` or `tk get` fails.

## Identify

When this task is fetched from `tasks:ticket/discuss` with a path already resolved, skip this section and use that path.

1. Identify the design from the user's instructions. If they named an id, run `tk design get <id>`. `design_id:` and no path: stop. Do not `tk mark`. Do not run `tk get`. A path with `parse_error:` for that id: stop. The fence is quarantined. Do not mark, do not edit the fence, and do not run the design session. `parse_error: N unparseable` does not quarantine the file just fetched. A path with no per-id `parse_error:` is the design document. Unknown design id: run `tk get <id>` for a legacy design-profile ticket. If they named a path, use it. If they asked you to find it, look where they pointed. Otherwise ask.
2. If a path is under `design/`, run `tk design get` on the full id in its filename before reading. The id is the first two hyphen-separated tokens (`design/library-h2h7-leave-draft.md` → `library-h2h7`). Scope and short id contain no hyphen; the slug may. `design_id:` and no path: stop. Do not `tk mark`. A path with `parse_error:` for that id: stop. The fence is quarantined. Do not mark, do not edit the fence, and do not run the design session. `parse_error: N unparseable` does not quarantine the file just fetched. A path with no per-id `parse_error:` is the design. A path that is not under `design/` stays the legacy or unmanaged case from step 1.

## Brief

Read the design thoroughly. Look at the code it touches. Check whether the design is already built or redundant: the code already does it, another design or ticket covers it, or the need has gone.

```bash
start get contexts:design/writing
```

Brief against that guide's Document section. This is a brief, not a review. Do not raise findings; soundness is `tasks:design/review`.

If Goals and Non-Goals, Proposed Design, or Alternatives Considered is empty, the design is not yet designed. Say so plainly at the top of the brief.

Then report:

### Summary

A simple explanation of the solution and its shape.

### Where it stands

The status from the fence: `draft`, `accepted`, `decomposed`, or `superseded`. For `decomposed`, the tickets in `produces` and whether they are done. A legacy design-profile ticket or an unmanaged document has no design status. Say which.

### Why it is needed

The problem the design solves, checked against the current code. Whether it is still real.

### Current state

Whether the document's Current State still matches the code. Name any drift.

### Already done or redundant

Whether the design is already built, covered elsewhere, or still needed. If already built, say where.

### Open decisions

The Open Questions and any choice the document leaves unsettled, each with the option you would take.

### Recommendation

Whether to keep designing, review it, accept and decompose it, supersede it, drop it, or something else, and why.

## After the brief

Stay with the user. Discuss. Update the file only after they approve the change. Edit under the H1 with the loaded design writing guide. When the shape is still open, run that guide's design session against the design. Do not hand-edit the fence.

When the discussion settles decisions the document lacks:

```bash
start get contexts:design/cover
```

Do not change the design's status. Do not run `tk design mark accepted` in this session. The owner accepts with that command, and decompose runs it when the owner accepts there. Leave a legacy design-profile ticket's status unchanged.

When they want a soundness review:

```bash
start get tasks:design/review
```

When the owner accepts and wants tickets:

```bash
start get tasks:design/decompose
```
