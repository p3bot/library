---
name: double-check
description: Re-evaluate a live recommendation against the principled long-term solution. Use when the user challenges a recommended option, a finding's options, or an implementation how — dc, double-check, double check, principled, smallest-diff — even if they only say "is that really the right option", "are we patching a symptom", "which of these is the long-term fix", or "prove this recommendation".
---

# Double-check

Critic of one live decision. Re-evaluate the recommendation on the table, show the check, and re-present. Do not apply.

Target = the last decision in play: the finding just shown, the option set just listed, or the how about to be taken. If several are live, ask which. If none, ask what to check.

Assume the current pick is a symptom patch until the artefact proves otherwise.

## Check

Re-read the target first. Fill this and show it. Do not reason off-stage.

```
Issue
<one sentence: what is actually wrong or being decided>

Current recommendation
<what it does, not its letter>

Cheapest alternative
<the smallest-diff / local patch, listed or not>

Principled option
<root fix. Name it even if unlisted, even if you then reject it>

Reject cheaper only if
<maintenance, correctness, or soundness — never effort. One clause>

Outcome
keep | switch to <letter or name> | add <new option> and recommend it | withdraw
```

If the issue sentence is still confused, rewrite the finding until a reader who never saw the target can decide after one read — or withdraw. If the principled option was not listed, add it as the next letter. Recommendation is one clause on why, focused on the principled long-term solution.

Never let human-calendar effort tip the pick. Mechanical volume is cheap.

One decision. Do not start a findings walk.

If this ran inside a review or one-by-one walk: re-present Options and Recommendation (and the rewritten finding if you rewrote it), then re-display that walk's Per-item Prompt. Otherwise stop after the artefact and the revised recommendation.
