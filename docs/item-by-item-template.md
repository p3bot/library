# Item-by-item Template Versions

History of the per-item finding template used by the interactive review tasks
(`tasks/review/pre-commit`, `tasks/project/review`, `tasks/design/review`, and
`tasks/review/multi-agent/orchestrator`) and by the external `one-by-one` skill.
They share this template; they differ only in the title line, the label, the
category placeholder, and the worked example:

- pre-commit: `### Issue n of T — <ID>: <short title>`, Category `<e.g. Security, Correctness>`
- project review: `### Finding n of T: <short title>`, Category `<decision | design | gap | risk | dependency>`
- design review: `### Finding n of T: <short title>`, Category `<approach | alternative | tradeoff | assumption | risk | gap | decision | dependency>`
- orchestrator: `### Issue n of T — <ID>: <short title>`, labelled `Review:` rather than `Category:`
- one-by-one: `### Finding k of T — <id or short title>`, labelled `Category / Severity:`, carried from the source list

Each version below shows the canonical (pre-commit) form. Recorded here for easier
comparison when adjusting the template; the authoritative copies live in each task's
`task.md`.

## v1 — original

Source: before commit `a51c953`. A single freeform `Issue` block carrying both
the problem and its significance, then Options and Recommendation.

````
This template is a suggestion. Keep details succinct; expand only when the finding genuinely warrants it.

```
### Issue n of T — <ID>: <short title>

Category: <e.g. Security, Correctness>
Location: <file:line>

Issue
<what the issue is and why it matters in context>

Options
A. <option>
B. <option>
C. <option>

Recommendation (B): <which option, with a brief why focused on the principled long-term solution>
```
````

## v2 — softened (current)

Source: commit `a51c953` (rewrite finding presentation for agent directors),
with the menu-marking change in `404e655`. Splits `Issue` into `What is wrong`
and `Why it matters`, adds a `Decision` line, and adds a preamble directing the
finding at the person directing the agent rather than whoever wrote the code.

The preamble wording differs slightly per task (project review says "document"
and "sections"; pre-commit says "code" and "files or symbols").

````
This template is a suggestion. Keep details succinct; expand only when the finding genuinely warrants it.

Write every finding for the person directing the agent, not for whoever wrote the code. They may not have the code in their head and will not read it to decode the finding. Lead with the impact in plain language, state the decision they must make, and reference files or symbols only as pointers, not as the explanation. Report the conclusion — do not narrate your reasoning or hedge across confidence levels.

```
### Issue n of T — <ID>: <short title>

Category: <e.g. Security, Correctness>
Location: <file:line>

What is wrong
<one or two plain sentences naming the problem, without internal symbols unless unavoidable>

Why it matters
<the concrete consequence — what breaks, for whom, or what risk it carries>

Decision
<the single question being put to the reader>

Options
A. <option — what it does and its tradeoff, in plain terms>
B. <option>
C. <option>

Recommendation (B): <which option, then one plain-language sentence on why, focused on the principled long-term solution>
```
````

## v3 — evidence-first

Leads with concrete, observable evidence instead of prose, described from the
perspective of someone who does not have the code in their head. Bold field
labels on their own line for scannability. `Cause`, `Impact`, and `Options` are
optional blocks; the evidence, `Decision`, and `Recommendation` always present.
The companion Per-item Prompt collapses to `(R)ecommended  (N)ext  (P)roject  (S)ave`.

````
This template is a suggestion. Keep details succinct; expand only when the finding genuinely warrants it.

Describe every finding from the perspective of someone who does not have the code in their head. Lead with what they would observe — run this, get that; send this, receive that; call this, it returns that — using the smallest concrete instance that fits the code under review. Show it; do not explain the problem through the code's internal structure. Then add only what is needed to decide: one line of cause, and one line of impact when it is not already obvious. Do not quote requirements, recap intent, or argue the finding is real — the evidence carries it. Keep the finding scannable.

```
### Issue n of T — <ID>: <short title>

Category: <e.g. Security, Correctness>
Location: <file:line>

<evidence — the smallest concrete instance of the problem: command → output,
request → response, call → return, a before/after, or the exact offending line.
Show it; do not describe it.>

**Cause**

<one sentence: why it happens, only when the reader needs it to decide>

**Impact**

<one line: the consequence, only when it is not obvious from the evidence>

**Decision**

<the single question being put to the reader>

**Options**

A. <option — what it does, its tradeoff>
B. <option>

**Recommendation (B)**

<option letter, then one clause on why, focused on the principled long-term solution>
```
````

Worked example (CLI, Recommendation-only — no Options block):

````
### Finding 1 of 1: --help still advertises --raw after removal

Category: gap
Location: console.go:30, network.go:33, cookies.go:31

  $ webctl console --raw     → Error: unknown flag: --raw   (flag removed)
  $ webctl console --help    → "--raw   Skip formatting"     (still printed)

**Cause**

The --raw help line is hand-typed in each command's Long string; Requirement 5
scopes docs to the agent-help markdown, so these three get missed.

**Decision**

Add the three Long-string lines to the removal scope?

**Recommendation (R)**

Yes — list the three files so --help and the flag go together.
````

Worked example (plain logic, with Options):

````
### Issue 1 of 1 — M1: ParseDuration truncates sub-second values to zero

Category: Correctness
Location: internal/timeutil/parse.go:42

  ParseDuration("500ms")  → 0s     (want 500ms)
  ParseDuration("1500ms") → 1s     (want 1.5s)

**Cause**

The result is built in whole seconds, so the millisecond remainder is dropped
before the Duration is constructed.

**Decision**

Rebuild from nanoseconds, or carry a float through?

**Options**

A. Build the Duration from nanoseconds, then convert — exact, mirrors stdlib.
B. Keep seconds, add a millisecond field — wider change, more surface.

**Recommendation (A)**

Nanosecond base matches time.ParseDuration and drops no precision.
````

## v4 — comprehension-first (current)

Keeps v3's concrete opening instance but fixes two failures it produced. Against
a target that does not run — a proposed design, a plan, a document — v3 still
demanded a runtime observable, and findings were written with structure diffs
dressed up as command output. And `Cause` plus `Impact`, each capped at one line,
split a single causal chain into two compressed fragments the reader had to
reassemble.

Changes from v3:

- Collapses `Cause` and `Impact` into one `Issue` block of continuous prose
- States what the opening instance is when the target does not run: the scenario
  the change would break, in plain language
- Adds an explicit bar — the reader can restate the problem in their own words
  after one read
- Adds a rule that things are named by what they are, with symbols and `file:line`
  demoted to parenthetical anchors
- Adds a rule against fabricating an observable
- Replaces "keep details succinct" with length following comprehension, since the
  succinctness instruction was the direct cause of the compression
- Drops "keep the finding scannable" — scannable and understandable were in
  conflict, and the template named the wrong one
- Each consumer carries a worked example matched to its target type

````
Findings are read by someone who has not opened the code, cannot look anything up, and has to decide something after one read.

The bar: that reader can restate the problem in their own words after reading it once. A finding that fails this has failed, however accurate it is.

Open with the smallest concrete instance that shows the problem, then explain it. Three moves, in order:

1. Establish what correct looks like and show the break against it. Where the code runs, that is a command and its output, a call and its return, or a request and its response, with the expected value alongside — `ParseDuration("500ms") → 0s (want 500ms)`. Where the change is structural and produces no output, it is the scenario it would break, in plain language. Contrast two cases when the behaviour is conditional; the contrast is usually what makes the break obvious
2. Say what causes it, in the same terms
3. Say what it costs

Writing rules:

- Name things by what they are, not by what they are called in the code. "the retry counter", not `svc.rc`. Symbols and `file:line` follow the plain-language noun in parentheses as anchors; they never carry the explanation
- Spell out internal shorthand on first use. Requirement ids, ticket numbers, and project acronyms mean nothing to the reader
- Never fabricate an observable. If the code path cannot be run as written, do not dress a structure diff up as command output — show the scenario instead
- Length follows comprehension. Cut padding, never cut the setup that makes the rest land
- Do not argue the finding is real or recap intent. The instance and the explanation carry it

```
### Issue n of T — <ID>: <short title>

Category: <e.g. Security, Correctness>
Location: <file:line>

<the smallest concrete instance: command → output, request → response, call →
return, with the expected value alongside — or the scenario the change breaks
where nothing runs. Show it; do not describe it.>

**Issue**

<continuous prose: what causes it and what it costs, in the same plain terms as
the instance above. As long as it needs to be to land, and no longer.>

**Decision**

<the single question being put to the reader>

**Options**

A. <option — what it does, its tradeoff>
B. <option>

**Recommendation (B)**

<option letter, then one clause on why, focused on the principled long-term solution>
```
````

Worked example (document target, no runtime observable — the case v3 handled badly):

````
### Finding 2 of 4: Redesign drops the provider list the CLI prints

Category: design
Location: R3 Query, result, and detail types

  agents get claude-code                     → providers: anthropic
  agents get opencode --provider anthropic   → providers: anthropic   (today)
                                             → providers: <empty>     (under R3)

**Issue**

The CLI prints a providers column for each agent. An agent like claude-code has
a built-in provider, anthropic, so the column shows anthropic. An agent like
opencode has no built-in provider — you tell it which one to use on the command
line, and the column should then show what you passed.

Today the library hands the CLI one ready-made field holding the providers
actually used: the built-in ones, or the ones you passed. The CLI prints that
field and nothing else. The redesign in R3 deletes that field and keeps only the
built-in list, which for opencode is empty, so nothing in the returned data
holds anthropic.

The CLI's only recourse is to detect the no-built-in-provider case itself and
substitute the value it passed in — which puts the provider-source decision back
in the CLI, the exact thing R3 set out to remove.

**Decision**

How does the returned agent expose the provider list the CLI prints?

**Options**

A. Add a resolved-providers field alongside the built-in list — always
   populated, holding the built-in providers or the ones passed in. Keeps both
   the declared and the resolved sets visible.
B. Replace the built-in list with the resolved one. Smaller surface, but the
   declared-versus-resolved distinction is lost.

**Recommendation (A)**

Option A: it restores the field the CLI already reads with no special-casing,
and keeps the built-in list as the capability fact it is.
````
