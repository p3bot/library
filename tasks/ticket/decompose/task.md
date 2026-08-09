# Decompose a Design into Tickets

Analyse a polished design and the surrounding codebase, find the natural seams, and propose a right-sized set of ticket documents for implementation.

This task sits after design review and before ticket writing. The design is ready to implement. The question is how to carve that design into ticket documents an implementer agent can execute one at a time.

IMPORTANT: Run `start get contexts:ticket/writing` before proposing or writing any ticket document. That guide defines what a ticket is, what sections it carries, and how it must stand alone for a fresh-session agent.

## Goal

Produce a ticket breakdown the owner can approve — then, only after approval, write the ticket documents.

A good breakdown:

- Covers the design completely (nothing left unimplemented by silence)
- Avoids one massive ticket that buries multiple independent outcomes
- Avoids a swarm of micro-tickets that restate the same context and cannot stand alone
- Makes dependencies and order explicit
- Leaves the system coherent after each ticket completes

A single ticket is a valid outcome. Small features often should not be split.

## What a Ticket Is

A ticket document is the sole context for a different agent in a fresh session. The implementer has no conversation history. Everything needed to understand and execute the work must live in the document itself.

From that definition:

- A ticket is a unit of implementation with a clear outcome, not a chapter heading from the design
- A ticket must be completable and verifiable on its own once its declared dependencies are done
- Implementation Plan steps inside a ticket are not tickets. Sequential steps of one coherent change belong together
- The document defines what and why. The implementer owns how

## Sizing Principles

These are the load-bearing rules. Apply them in order when a boundary is ambiguous.

### 1. Split on real seams, not on volume

Do not split because the work "looks large." Agent-time makes mechanical volume cheap. Split only when there is a genuine seam: independent outcomes, layered foundations, distinct integration surfaces, or different risk profiles that should not share one acceptance set.

### 2. Prefer fewer fuller tickets over many thin ones

Fragmentation has a cost the agent-time principle does not remove:

- Each ticket restates design context for a fresh session
- Thin tickets often leave the system half-wired
- Dependency graphs become ceremony instead of signal
- The owner reviews and sequences more documents than the design warrants

When unsure whether two units should merge, merge them — unless an explicit too-large signal fires.

### 3. Prefer a working intermediate state

Each ticket should leave the codebase in a coherent state: builds, tests pass, partial capability is real rather than a permanent half-migration. If ticket B must land in the same breath as ticket A to avoid a broken tree, they are one ticket.

### 4. One clear outcome per ticket

A ticket answers: what is true when this is done that was not true before? If you cannot state that in one or two sentences, the unit is either too vague (rewrite) or too broad (find the seam).

### 5. Small designs stay whole

If the design is a focused feature, a localised change, or a tightly coupled set of edits that only make sense together, produce one ticket. Do not invent seams to justify process.

## Signals

### Split signals (too large for one ticket)

- Multiple independent outcomes that could ship or be valued separately
- Distinct code areas with no shared integration in this design
- A foundation that other work must build on, with a clean handoff after the foundation lands
- A nested sub-feature with its own requirements, scope, and acceptance criteria
- Different risk or reversibility profiles bundled together (for example a data migration with a cosmetic UI pass)
- An Implementation Plan that partitions cleanly into stages with natural verification between them

### Merge signals (too small as its own ticket)

- No independently meaningful outcome once the ticket is done
- Would only touch a trivial slice with acceptance criteria that are steps, not results
- Purely sequential steps of one logical change
- Shared context so heavy that each ticket would restate most of the design
- Intermediate state is broken or unusable without the next ticket immediately
- The unit exists only to match a design section heading, not a real boundary

### Keep-together signals (resist artificial splits)

- Shared types, interfaces, or contracts that would thrash if introduced across tickets
- A vertical slice where UI, API, and storage only verify together
- Refactors that exist solely to enable the feature and have no standalone value
- Test and implementation of the same behaviour

## Workflow

### Phase 1: Orient

1. Identify the design document(s). Prefer documents named by the user. Otherwise look for:
   - `design.md`, `rfc.md`, or similar at the repo root
   - Design folders: `docs/design/`, `.agents/design/`, `design/`
   - References in `AGENTS.md`

   One design may span multiple files (main design plus design records). Read all that apply. If multiple unrelated designs are candidates, ask which to decompose.

2. Confirm the design is ready for decomposition. If it still has unresolved architectural decisions, open alternatives, or contradictions, stop and say so. Point the owner at design review rather than inventing ticket boundaries around unfinished design.

3. Load the ticket writing guide:

   ```bash
   start get contexts:ticket/writing
   ```

4. Read repo-level agent instructions (`AGENTS.md` and equivalents) and note any existing ticket conventions (location, numbering, naming).

### Phase 2: Analyse

1. Read the design end-to-end. Extract:
   - Goals and non-goals
   - Proposed shape (components, boundaries, data flow)
   - Explicit deliverables and requirements
   - Constraints and accepted tradeoffs
   - Migration, rollout, or compatibility obligations
   - Testing or observability expectations that are design-level, not routine

2. Analyse the codebase as it exists today:
   - What already implements parts of the design
   - Where new work must land
   - Existing patterns and boundaries that suggest natural seams
   - Coupling that would make a proposed split painful
   - Gaps between design assumptions and actual current state

3. Inventory the work. List discrete units of change implied by the design — features, foundations, integrations, migrations, removals. These are candidates, not tickets yet.

4. Map dependencies between inventory items: hard prerequisites, soft ordering preferences, and true independence.

### Phase 3: Find Seams

1. Start from the inventory and apply the Sizing Principles and Signals.
2. Group units into proposed tickets. For each candidate boundary, force an explicit choice:
   - Merge — same ticket
   - Split — separate tickets with a stated dependency or independence
   - Defer — out of scope for this design's implementation wave (must be justified against the design; do not silently drop in-scope work)
3. Stress-test the proposal:
   - Cover test: does every in-scope design obligation land in exactly one ticket (or an explicit shared foundation)?
   - Standalone test: could a fresh agent complete each ticket from its document once dependencies are done?
   - Coherence test: is the tree healthy after each ticket?
   - Count test: if there is only one ticket, is that because the design is small or coupled — or because seams were missed? If there are many, can any adjacent pair merge without failing a split signal?
4. Order the tickets. Prefer dependency order. When tickets are independent, prefer higher risk/uncertainty earlier, or the order that yields usable partial product sooner — state which heuristic you used.

### Phase 4: Propose

Present the breakdown inline. Do not write ticket files yet.

Use the Proposal Format below. Then pause for owner approval.

Approval may adjust boundaries, merge or split candidates, change order, or rename tickets. Revise the proposal until the owner accepts it.

### Phase 5: Write (only after approval)

Once the owner accepts the breakdown:

1. Follow `start get contexts:ticket/writing` for structure, principles, and placement.
2. Write one ticket document per accepted ticket.
3. Each document must stand alone. Reference the design document and relevant design records in References. Do not assume the implementer has read sibling tickets — state only what that ticket needs, including which dependency tickets must already be done.
4. Encode dependencies in the Implementation Plan order across the set (and in any frontmatter or index the repo uses).
5. Right-size sections per ticket. A small ticket omits empty sections.
6. Report what was written: paths, titles, dependency order, and any open questions still owned by the human.

If the owner wants only the plan and will write tickets later, stop after Phase 4.

## Proposal Format

```
# Ticket Breakdown: <design title>

## Design sources

- <path> — <one-line role>

## Codebase read

- <relevant areas touched or inspected>

## Inventory

| ID | Unit | Notes |
|----|------|-------|
| U1 | ... | ... |

## Proposed tickets

| Ticket | Outcome | Includes units | Depends on | Why this boundary |
|--------|---------|----------------|------------|-------------------|
| T1 | ... | U1, U2 | — | ... |
| T2 | ... | U3 | T1 | ... |

## Execution order

1. T1 — <one line>
2. T2 — <one line>

## Kept together (and why)

- <units or concerns that look separable but are one ticket, with reason>

## Split apart (and why)

- <boundary and the seam that justifies it>

## Deliberately single ticket

<If only one ticket: state why splitting would be wrong. Omit this section if multiple.>

## Coverage

- In design, in a ticket: <confirm complete, or list gaps>
- In design, deferred: <item and justification, or "none">
- Not in design, suggested by code: <item and whether folded in or ignored>

## Open questions

- <anything that blocks writing tickets or choosing a boundary>
```

Omit sections that have nothing to say. Keep the proposal short enough to decide on; expand only where a boundary is non-obvious.

## Guidance for Agents

### Do

- Treat the design as the source of truth for intent; treat the codebase as the source of truth for current state
- Name outcomes in product or system terms, not file lists
- Make dependencies real prerequisites, not preferred scheduling
- Call out when the design itself is still multiple designs (that is a design split, not a ticket split — send it back)
- Prefer honest single-ticket proposals for small work

### Do not

- Produce one ticket per design heading by default
- Produce one ticket per file or function
- Split solely because an Implementation Plan has many steps
- Write ticket documents before the owner accepts the breakdown
- Leave in-scope design work unassigned without an explicit deferral
- Dictate implementation detail that belongs inside a ticket document's implementer judgement
- Inflate the count to look thorough, or collapse everything to avoid thinking about seams

### When the design and code disagree

Surface the disagreement in Open Questions or in Coverage. Do not paper over it by writing tickets against a fiction. If current state makes a design obligation free (already done), drop or shrink that unit and say so.

### Relationship to adjacent tasks

| Stage | Task |
|-------|------|
| Design still fluid | design review / design-phase — not this task |
| Design accepted, need ticket boundaries | this task |
| Ticket documents written, need quality check | ticket review |
| Ticket ready to build | ticket begin / implementation |

## Outcome

Done means:

- Design and relevant code analysed
- Inventory of work units produced
- Ticket breakdown proposed with explicit merge/split rationale
- Dependencies and order stated
- Owner approved the breakdown
- If requested: ticket documents written per the ticket writing guide, each standalone and right-sized
