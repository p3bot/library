# Review Ideas

Parking lot for redoing the review tasks. Extracted from staged edits to `docs/review-types.md` that treated the type catalogue as a review procedure.

`docs/review-types.md` stays the vocabulary and scope catalogue. Invoking tasks bind subject, types, and depth. The material below is candidate procedure for those tasks, not type definitions.

## Operating rules

These were framed as applying to every bind, not as a fourth axis:

- Review Conduct
- Review Artefact
- Severity Rubric (already in the types document as finding vocabulary)
- Overlap and Ownership (already in the types document as type-boundary rules)

Severity and ownership stay in the catalogue. Conduct and artefact belong in the tasks.

## Review Conduct

How to investigate.

Locate the relevant scope from the subject's own materials. Do not scan the rest of the repository aimlessly.

Prioritise, in this order, whatever exists for the subject:

- Project descriptions such as README, AGENTS.md, and CLAUDE.md
- Specs, design docs, tickets, and requirements
- The current diff and recent related commits, when the subject is a change
- Entry points, core modules, and their call relationships
- Data models, permission controls, and external interfaces
- Tests covering the subject's key scenarios
- Code and documentation directly related to the subject

Do not ask for information that is in the repository, the code, the configuration, the tests, or the Git history.

Ask a question only when all of these hold:

- The answer cannot be found in the subject
- Different answers would change the review's conclusions
- The question cannot be resolved by further read-only inspection

Ordinary uncertainties are recorded on the artefact. They do not halt the review.

Check callers, data flows, and affected scope, not only the local patch.

If continuing has entered diminishing returns — further reading will not change the bound types' conclusions or the set of material findings — stop and record that on the artefact.

Do not manufacture findings. If no material issues remain, say so.

## Review Artefact

Every bind produces a review artefact. Depth is a claim the artefact must not contradict. A Survey must not present itself as having walked every scope item; a Deep review must not skip bound scope items without stating why they do not apply.

Every finding records severity and confidence. Invoking tasks may choose layout and may defer finding bodies to an interactive walk.

Scale the artefact to the bind:

- Every artefact states investigation scope (what was read, what was skipped, and why) and the findings, each with severity and confidence
- A Survey also states whether a Deep pass is warranted, and on which types. It does not produce a Deep-shaped reconstruction
- A Deep review also states reconstructed goals (what problem the subject aims to solve, what solution is in use, which files that judgement came from, the key assumptions, and what remains uncertain), documentation versus code (when they conflict, which side the review is judging against), the highest-priority items to handle, and residual risks the review is willing to accept for now
- When Architecture is bound, the artefact states the direction conclusion: Retain, Adjust, Replace, or Insufficient information, with the comparison that produced it. If the current solution is already reasonable, say why it is worth retaining rather than inventing alternatives. Do not propose implementation patches that assume the current shape before that conclusion

## Finding quality

If several observations share one root cause, file one finding at the root and describe the symptoms there. Do not emit a finding per symptom.

Confidence:

- Confirmed: Reproduced, demonstrated with evidence, or proven by inspection of the controlling code path
- Probable: Strong indications from code or config; not fully reproduced. A reasonable risk lives here when the path is plausible but not proven
- Speculative: Hypothesis or pattern match without direct evidence on this subject

Without code or documentation evidence, a theoretical possibility is Speculative. It is not a confirmed defect. Record it on the artefact; do not present it as a bug.

## Architecture direction

Candidate change to Architecture as a type, plus the wait-on-conclusion protocol.

Purpose: Evaluate system structure, design decisions, component organisation, and whether the current solution is the right one for the subject's stated purpose.

Solution Fit is evaluated first and produces a direction conclusion: Retain, Adjust, Replace, or Insufficient information. Do not assume the current architecture, technology choices, or implementation methods are correct because they exist or because much code has been written. Other Architecture scope items wait on that conclusion. When this type is bound with others, implementation findings that assume the current shape wait on it too.

Solution Fit: Whether the current solution is the right one for the subject's stated purpose, not only whether the implementation matches the stated architecture. Compare a genuine alternative only when it would eliminate a class of problems at the root and the migration cost is justified; if the current solution is already reasonable, say why it is worth retaining.

Family-table purpose line that went with this: "Evaluating structure, design decisions, and whether the current solution is the right one."
