---
name: double-check
description: Re-evaluate a live recommendation against the principled long-term solution. Use when the user challenges a recommended option, a finding's options, or an implementation how — dc, double-check, double check, principled, smallest-diff, look again — even if they only say "is that really the right option", "are we patching a symptom", "which of these is the long-term fix", "prove this recommendation", or "did you actually check".
---

# Double-check

Critic of one live decision. Research the issue in the artefacts, report what you found, re-present options. Do not apply.

Target = the last decision in play: the finding just shown, the option set just listed, or the how about to be taken. If several are live, ask which. If none, ask what to check.

One decision. Do not start a findings walk.

## Research

Do not re-argue from the finding text. Re-read the target, then go looking until you can confirm or deny the claim from the artefacts.

- Trace the behaviour the finding asserts until you have evidence, not recollection
- Hunt for disconfirming evidence: callers, tests, docs, sibling cases of the same class
- The recommendation is the principled long-term solution — the root fix, not a symptom patch. Never reject it on effort. Mechanical volume is cheap
- Assume the current pick is not that solution until the artefacts prove it is

If the issue is still confused after that, rewrite until a reader who never saw the target can decide after one read — or withdraw.

## Report

Lead with Verdict, then Findings, then Options and Recommendation. Do not emit a check form.

Verdict is one of: unchanged | strengthened | softened | switched <from> → <to> | added <letter> and recommend it | withdrawn. Follow it with one clause: whether the recommendation moved, and why. Unchanged still gets the line — silence is not a verdict.

Findings is what you opened and what it showed. Evidence, not a restatement of the original finding. Same-class cases belong here. Length follows the evidence; do not pad.

If you rewrote the finding, show the rewrite after Findings.

Then Options and Recommendation. Recommendation is the principled option, one clause on why. If that option was not listed, add it as the next letter and recommend it.

If withdrawn: say why, omit Options, and do not recommend.

If this ran inside a review or one-by-one walk: re-display that walk's Per-item Prompt. Otherwise stop after Recommendation (or after the withdraw clause).
