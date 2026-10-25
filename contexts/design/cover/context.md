# Design Cover

Same-session pass after a design document has been written. The conversation is the evidence. The design is the claim. Copy missing decisions into the document.

Run this in the session that wrote the design. A later session cannot see the turns the write dropped.

## Source

This conversation. The latest word on a point wins. A real option that lost goes to Alternatives Considered with the reason it lost.

Edit the design document this session wrote. Do not create a second design. Leave a design document `draft`. Do not run `tk design mark accepted`. Do not mark it `decomposed`.

If this session has no design document, stop.

## Document shape

Use the document shape already loaded from `contexts:design/writing`. When this session has not loaded it:

```
start get contexts:design/writing
```

Place each item in the section that owns it. Do not start another writing session. Do not fetch `contexts:design/cover`.

## What to write

A load-bearing item from this conversation:

- An explicit choice, including a reversal
- An implied decision the conversation relied on
- An assumption that, if wrong, changes the design
- A constraint or non-goal the owner drew

Do not add a decisions log. Do not add an issues section.

Leave out:

- Process talk, tool noise, and restatements already in the document at the same strength
- Detail the writing guide leaves to implement tickets, unless the conversation made that detail a design constraint
- A new idea. Implied means you can point at the turn that relied on it. A later session with only the design would otherwise lack it. An item with no such turn stays out

A decision this pass disagrees with stays as the session made it. One line at the end may name it for `tasks:design/review`. Do not change that decision.

## Passes

Repeat until a pass changes nothing important. Important means a later session with only the design would decide or assume differently.

Cycle these lenses in order. After the last lens, start again at the first:

1. Explicit decisions. Inventory them from the conversation before editing. Integrate what the document missed or contradicted
2. Implied decisions and assumptions. Skip items already integrated. Read for defaults, asides the rest of the design depends on, and scope treated as settled without a decision sentence
3. Both directions, from the end of the conversation backward. Section by section, find the turn that section compressed away. See a later reversal before copying an earlier wording back

Each pass ends with one line per change. The next pass treats that list as done.
