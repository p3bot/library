# Design Writing Guide

This guide is for AI agents running a design session. The document shape lives in the design profile of `contexts:ticket/writing`. If the two texts ever drift, the ticket writing guide wins.

Reach for a design session when there is genuine design work to settle first — the shape is not yet obvious, and more than one approach is worth weighing. When the approach is already clear and only the build remains, skip the design and write an implement-profile ticket. The trigger is design uncertainty, not size.

The session produces a ticket tagged `design`. That ticket is read cold: by a reviewer in a fresh session, and by the agent that decomposes it. Everything needed to understand and judge the design must be in that ticket.

Do not implement product code from the design ticket.

## Principles

The value of a design is the reasoning it makes explicit and the solution it commits to, not the format. Hold to these.

- Design the whole solution, then commit to it. Settle on one coherent design rather than presenting a menu. The directions you weighed belong in Alternatives Considered with the reason each lost; the body describes the design you chose
- Weigh real alternatives before committing. Consider at least two genuine directions for the shape, not one plus strawmen built to lose. Designing something new — a system or a feature — you have real design freedom, and the most to lose from anchoring on the first idea
- Make tradeoffs explicit. Every design gives something up. State what the chosen shape costs, not only what it wins. A design with no stated downside is one not yet understood
- Surface load-bearing assumptions. Name the facts the design rests on — a dependency's behaviour, a scale target, a platform capability. If one is wrong the solution fails, so state it where review can test it
- Argue with evidence, not confidence. Prefer a measured number, a citation, or a small worked example over assertion. Confident prose hides weak designs, and review exists to find them
- Design the solution, not the code. Specify the architecture, the components and their responsibilities, and the interfaces and data that define the system. Leave function signatures, naming, file placement, and defensive detail to later implement tickets
- Right-size to the design. A large system earns every section. A focused feature needs a Summary, a Proposed Design, the alternatives weighed, and the seams it touches, and little else
- Be explicit and complete. The ticket is read cold. Do not reference the session that produced it
- Resolve what you can; surface what you cannot. Fold settled questions into the body. Genuinely open decisions that need an owner go in Open Questions
- Record references. Prior art, similar systems, benchmarks, and documentation that shaped the design belong in the ticket so the reviewer can check the sources

## Handoff

If this session was started against an existing design-profile ticket (a working path from build, continue, or begin), fill that ticket. Do not `tk create` another. Do not mark it done.

Otherwise, once the session has settled the shape, write a ticket tagged `design` following the design profile in the ticket writing guide:

```bash
start get contexts:ticket/writing
```

If `command -v tk` succeeds and they did not ask for an unmanaged path, `tk create` with `--tag design` and fill under the H1 it printed. Otherwise use that guide's unmanaged File Placement. Do not mark that ticket done.

Then decompose after the owner accepts the design. That task marks the design done after it writes the follow-ups. Do not implement from the design ticket.
