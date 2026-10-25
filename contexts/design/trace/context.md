# Design Trace

Check that the design's content is present in the tickets it produced. The files are the source. This session or a fresh session both work.

The decompose conversation is not evidence.

## Job

Every part of the design that would change what a ticket does, or what done means, has a home in the ticket set. Write the missing part into the ticket that owns it.

## What must map

Map a design statement when a fresh agent, given only its ticket, would do the wrong work without it:

- A goal, and the Proposed Design behaviour that achieves it
- A constraint from Tradeoffs, Cross-Cutting Concerns, Risks and Mitigations, or Rollout
- An open question that is still open. Map it to a decide or investigate ticket. When the design does not say enough to do that, name the question and do not invent a ticket for it
- An in-scope Follow-up

Problem, Current State, Alternatives Considered, Non-Goals, and References map where a ticket would otherwise contradict them or wander into them.

One ticket may carry many statements. A statement may appear in more than one ticket, each stating the part that ticket needs. A reference to the design is not a mapping.

## Input

Identify the design from the user's instructions. If they named an id, run `tk design get <id>`. `design_id:` and no path: stop. Do not `tk mark`. Do not run `tk get` for that id. A path with `parse_error:` for that id: stop. The fence is quarantined. Do not mark, do not edit the fence, and do not trace. `parse_error: N unparseable` does not quarantine the file just fetched. A path with no per-id `parse_error:` is the design document. Unknown design id: run `tk get <id>`. A path is a legacy design-profile ticket. If they named a path, use it.

If a path is under `design/`, run `tk design get` on the full id in its filename before reading. The id is the first two hyphen-separated tokens (`design/library-h2h7-leave-draft.md` → `library-h2h7`). Scope and short id contain no hyphen; the slug may. `design_id:` and no path: stop. Do not `tk mark`. A path with `parse_error:` for that id: stop. The fence is quarantined. Do not mark, do not edit the fence, and do not trace. `parse_error: N unparseable` does not quarantine the file just fetched. A path with no per-id `parse_error:` is the design.

On a design document, `tk get` each id on `produces`. An empty `produces` list stops the pass. Do not invent a breakdown. A legacy design-profile ticket or an unmanaged file has no `produces` list. The owner names the tickets. If they have not, ask.

Before the first edit to a ticket, load the ticket writing guide when this session has not loaded it:

```
start get contexts:ticket/writing
```

## Passes

Repeat until a pass changes nothing important. Important means a fresh agent on that ticket would miss a design constraint or behaviour.

Cycle these lenses in order. After the last lens, start again at the first:

1. Inventory the design statements that change the work. Point each at the ticket and the place in that ticket that carries it. Write each miss into that ticket
2. Re-read the tickets and check the inventory against the text just written

Each pass ends with one line per change. The next pass treats that list as done.

Extend an existing ticket as part of the pass. Edit only under the H1. Do not hand-edit the fence.

Pause before creating a new ticket. A new ticket changes the breakdown the owner approved. On approval, when `command -v tk` succeeds and they did not ask for an unmanaged path, `tk create` in the design's scope. `--scope` is the scope name, not the design id or a ticket id. Fill under the H1. Then `tk design meta add <design-id> produces <full-ticket-id>` once that ticket exists. Otherwise use the writing guide's unmanaged File Placement.

The design stays `decomposed`. Do not mark it `draft` or `accepted`. New tickets stay at the status `tk create` gave them. Do not mark them `todo`.
