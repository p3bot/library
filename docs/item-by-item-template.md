# Item-by-item Template Versions

History of the per-item finding template used by the interactive review tasks
(`tasks/review/pre-commit`, `tasks/project/review`, and
`tasks/review/multi-agent/orchestrator`). The tasks share this template; they
differ only in the title line and the Category placeholder:

- pre-commit: `### Issue n of T — <ID>: <short title>`, Category `<e.g. Security, Correctness>`
- project review: `### Finding n of T: <short title>`, Category `<decision | design | gap | risk | dependency>`
- orchestrator: `### Issue n of T — <ID>: <short title>`, labelled `Review:` rather than `Category:`

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

## v3 — evidence-first (new)

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
