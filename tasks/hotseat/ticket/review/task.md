# Review a ticket

Review the ticket document, fix what every member agrees, and mark `todo` only when a later session can implement it. Do not change the product.

The ticket id is the `ticket:` line in the instructions. Do not ask for one.

Every member reads the instructions and joins. A member who is not the acting seat then exits. Phase work starts when a `turn` names you.

Edit only under the H1. The fence stays sealed. On a tk-driven scope, `tk sync` after a body edit. `tk mark` self-commits.

## Phase 1

The acting seat sends one parallel review `turn` to every name `hotseat chat members <chat>` returns, including itself.

The first line is `mode: parallel`. The phase text is: run the Review section of the instructions against the ticket. Do not edit the ticket.

Send each issue as its own `finding`, addressed to every roster name, with `--re` set to the `turn`'s `seq`. Use the Finding Template. An issue written only in the `say` gets no discussion and is not fixed.

Then send one `say` to the seat with the report in the Report Format and the same `--re`. When you have no findings, the `say` also says `no findings`.

## Phase 2

`run` discusses each finding and launches the finder to apply an agreed fix. Members take their stances when `run` launches them. The finder applies the agreed proposal in its fix launch.

The seat does not apply edits and does not schedule a discussion.

## Phase 3

The follow-up prompt for the review set carries `fixed: <n>`.

- `fixed: 0`: go to Phase 4
- Any other count: the seat sends one parallel satisfaction `turn` to every roster name, including itself

The first line is `mode: parallel`. Each member re-reads the document only for inconsistencies the fixes introduced. This is not a second full review. Send `clean` as a `say` to the seat, or one regression as a `finding` addressed to every roster name, with `--re` set to the satisfaction `turn`'s `seq`. A regression goes through the same discussion and fix.

On the follow-up after the satisfaction set, go to Phase 4. There is no second satisfaction pass.

## Phase 4

The seat sends `done` to `owner`. The body starts with the outcome line and then the report, with the Remediation Summary.

An issue blocks work if proceeding without resolving it would force a fresh session to rework or guess.

- No blocking issue remains, and the profile is implement, or a bug whose work is a fix: `tk mark todo <id>`, then `outcome: proceed`
- Anything else, including a split, a stub, a capture, a decide, an investigate, a design, a terminal ticket, or a bug that is not yet a fix: leave the status, and send `outcome: hold`. Name the blocking findings, the seam, or the reason the ticket was not reviewed

A split names the seam and does not create the children.

## Review

Goal: catch issues that would force rework if a fresh session started the work. For implement, that is mid-implementation. For decide, whether the question and options are enough to choose. For investigate, whether the question and method are enough to research. Empty Decision or Recommendation is the work, not a defect. For a bug still in diagnosis, empty Expected, Actual, or Repro is the work, not a defect. Routine implementation judgement, such as naming, defensive code, and local refactors, stays with the implementer.

Finding no new issues is a valid outcome. If the ticket document is complete and prior reviews have surfaced the real concerns, say so rather than invent findings to justify the run.

1. `tk get <id>`. The working path is the path it prints
2. Stop the review and send no findings when any of these holds. Say which in the `say`:
   - `tk get` does not find the ticket, or reports a `parse_error:` for this id
   - The ticket is terminal: the path is under `archive/`, or the status is `done` or `cancelled`
   - The path is a design document, or the matched profile is design
3. Match the profile from the headings under the H1. `start get contexts:ticket/writing` only when the profile match or the stub test is in question
4. A stub or a capture gets no findings walk. Say `stub` or `capture` in the `say`. Do not expand a stub
5. Read the ticket document thoroughly
6. Run the Size and Coherence Check on implement tickets, and on bug tickets when the work is a fix. When it fires, say `split` and the seam in the `say`, and send no other findings
7. Analyse the repository:
   - Validate the stated current state against the actual codebase when Current State exists
   - Check whether a fresh-session agent can do that profile's work from the document. Do not treat an unfilled Decision or Recommendation as a gap. Do not treat empty Expected, Actual, or Repro as a gap when the bug is still diagnosis. Do not treat missing Requirements as a gap on capture, bug, investigate, decide, or design
   - Research external facts only when the ticket's approach turns on them: a specific dependency version, an API behaviour, or a platform capability. Generic dependency scans produce noise over repeated runs
8. Identify concerns that meet the Goal bar. Apply the Articulation Test and Regret Filter before sending each one

### Size and Coherence Check

Signals that a ticket is too broad for a single implementation pass:

- Multiple independent outcomes that could ship separately
- Distinct code areas with no shared integration
- A refactor or sub-feature nested inside the parent with its own requirements, scope, and acceptance criteria
- Implementation Plan steps that partition cleanly with a natural handoff

If these signals fire, the review short-circuits. Finer issues found against a ticket that is about to be split will mostly go stale.

## Reviewer Guidance

- Trust the implementer. Routine judgement on naming, defensive code, local refactors, and style stays with them
- Goal bar: flag a finding only if leaving it unresolved would force a fresh session to rework or guess
- Articulation Test: if you cannot articulate what goes wrong when an item is left unresolved, it does not belong in the list
- Regret Filter: before finalising a finding, ask whether you would regret not flagging this after that profile's work lands. If not, drop it
- Permission to find nothing: a late-run review that produces no findings is evidence the document is complete. Inventing findings to justify the run destroys the signal
- Proposals target the principled long-term solution in the ticket document. Correct the design or requirement at the root, not a downstream workaround the implementer would paper over. Do not default to the smallest-diff edit

## Issue Categories

| Category | Use when |
|----------|----------|
| decision | The owner needs to choose between valid alternatives |
| design | A flaw, weakness, or missing element in the design or architecture |
| gap | Something that profile needs is missing from the document. Not missing Requirements on capture, bug, investigate, decide, or design |
| risk | A potential problem that may not occur but should be acknowledged |
| dependency | An external dependency with version, compatibility, or availability concerns |

A `decision` finding proposes the alternative you recommend, and names the others. When the choice is the owner's and not the members', send an `ask` as the member role says, and take your best stance.

## Finding Template

A finding is read by members who have not opened the ticket document, and the discussion settles on its proposal. The bar: a member can restate the problem in their own words after reading it once. A finding that fails this has failed, however accurate it is.

Open with the smallest concrete instance that shows the problem, then explain it. Four moves, in order:

1. Establish what correct looks like and show the break against it. Where the target runs, that is a command and its output with the expected value alongside. Where it does not, such as a plan, a proposed design, or a document, it is the scenario the change would break, in plain language. Contrast two cases when the rule is conditional
2. Give the Simple Explanation: one or two sentences in everyday language naming the problem
3. Say what causes it, in the same terms
4. Say what it costs

Writing rules:

- Name things by what they are, not by what they are called in the code. "the providers column", not `KnownAgent.Provider`. Symbols and `file:line` follow the plain-language noun in parentheses as anchors
- Spell out internal shorthand on first use. Requirement ids, section codes, and codebase acronyms mean nothing to the reader
- Never fabricate an observable. If the thing under review does not run yet, show the scenario instead
- Length follows comprehension. Cut padding, never cut the setup that makes the rest land
- Do not argue the finding is real or recap the ticket's intent
- The Proposal is one solution, stated as the edit the finder will make to the ticket document, fully integrated so the issue is covered by the new content. Name a rejected alternative only when the choice is not obvious

```
<short title>

Category: <decision | design | gap | risk | dependency>
Location: <file:line, or section heading>

<the smallest concrete instance, or the scenario the change would break where the target does not run>

Simple Explanation

<one or two sentences naming the problem in everyday language>

Details

<continuous prose: what causes it and what it costs>

Proposal

<the one edit to make, and one clause on why it is the principled long-term solution>
```

## Report Format

After the header, bullet what the ticket does before listing findings. Each bullet is one outcome or change after the ticket lands, not the implementation plan and not a dump of the requirements.

```
## Ticket Document Review

Ticket: <working path>
Profile: <matched profile>
Stub: <yes | no>
Split: <no, or the seam>
Intent: <one sentence on what the ticket sets out to do>
Findings: <count by category, e.g. 1 decision, 2 design, 1 gap>

## What this ticket does

- <outcome or change>

## Findings

| Seq | Category | Finding |
|-----|----------|---------|
| <finding seq> | <category> | <one-line summary> |

## Assessment

<overall assessment of the ticket document, noting strengths and weaknesses>
```

List every finding. Do not truncate. A review stopped under Review step 2 gives the header and the reason only.

## Remediation Summary

The seat's `done` body carries this table, one row per finding kept after aggregation:

- `Fixed`: the settled change was applied to the ticket document
- `Dismissed`: the discussion settled on no change
- `Unresolved`: the discussion deadlocked, or the settled change was not applied

```
| Seq | Category | Finding | Outcome |
|-----|----------|---------|---------|
| <seq> | <category> | <brief description> | Fixed |
```
