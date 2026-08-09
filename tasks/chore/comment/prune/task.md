# Comment Prune

Prune comment bloat from the current repository. Delete comments that restate the code, duplicate rationale already present elsewhere, or carry roadmap and future-work notes. Preserve every non-obvious WHY in compressed form. Harvest marker comments (TODO, FIXME, and similar) into a tracked list on the way out. The outcome is a lower token cost for loading source files into agent context, with no real information lost.

This task runs against the repository at the current working directory. It maintains its own state in a working document at the repo root so a fresh agent can resume an interrupted run.

## Goal

Reduce code-comment bloat across the repository by deleting comments that do not earn their place, compressing the few that carry genuine non-obvious WHY, and rescuing actionable markers into a reviewable list. Bias toward deletion: when in doubt between deleting and compressing, delete.

## Scope

In scope:

- Source code files in the primary code language(s) of the repository
- Test files in those languages

Out of scope:

- Configuration files (YAML, HCL, Dockerfile, Makefile, JSON)
- Markdown documents and other narrative documentation
- Generated code (protobuf output, OpenAPI clients, codegen artefacts)
- Vendored or in-tree third-party libraries (identify and confirm with the user during Phase 1)
- Repository configuration (`.gitignore`, lint configs, CI files)

## Working Document

All mutable state for this task lives in a single working document at the repo root, named `NN-comment-prune-yyyy-mm-dd.md`:

- `NN` is a two-digit sequence from `01` to `99`. Before creating a new document, `ls` the repo root and read the highest existing `NN-` prefix across all files; use the next number. If none exist, start at `01`.
- `yyyy-mm-dd` is the date the document was created, taken from the datetime provided in your prompt (use the date portion only).

This document holds the Current State, Files checklist, and TODOs sections that drive the work. The Files checklist is the only resume state: its marks tell a fresh agent where to continue. Do not store this state in any other file, and do not write it back into this task prompt.

Locate or create at the start of every run:

1. Glob the repo root for `*-comment-prune-*.md`.
2. If an unfinished document exists (Files entries remain unchecked), resume it. Keep its existing name and date; do not rename or re-date it.
3. If no such document exists, determine `NN` per the rule above and create `NN-comment-prune-<date>.md` using the template below, then run Phase 1 to populate it.

Working-document template:

```markdown
# Comment Prune NN — yyyy-mm-dd

## Current State

- Primary code language(s):
- File extensions in scope:
- Exclusion patterns identified:
- In-tree third-party directories identified:
- Baseline comment volume (characters):
- Final comment volume (characters):

## TODOs

Collected during Phase 2. One entry per marker comment removed from source, in the order encountered. Format: `path/to/file:line — full original comment text`.

## Files

Populated in Phase 1. One markdown checklist entry per source file in scope, in alphabetical order by path.
```

Lifecycle: the working document is not part of the cleanup commit (see Constraints). It persists across sessions for resume. After the single cleanup commit lands in Phase 3, ask the owner whether to delete it.

## Rules

Apply these rules in order to every comment encountered during Phase 2. When a rule says delete, do not look for a clever way to keep the comment.

1. Default to no comment. Add one only when the WHY is non-obvious and cannot be re-derived from reading the code.
2. Document WHY, not WHAT. Code shows what; comments exist for hidden constraints, invariants, race windows, intentional tradeoffs, and decisions whose rejected alternatives are not visible in the chosen code.
3. Do not restate the identifier. A function named `parseConfig` does not need a comment saying it parses the config.
4. One canonical home per fact. Pick the point of consequence; do not duplicate the same WHY across multiple sites.
5. No file-layout maps. The filesystem already answers that question, accurately, by construction.
6. No roadmap or future-work notes. Notes like "Future: revisit when X" or "Will be replaced by Y" duplicate the roadmap and rot.
7. No task, ticket, PR, or caller references. Git blame surfaces the introducing commit; the commit body is the right home for that context.
8. No conversation references. "As discussed", "per the design doc chat" — meaningless to anyone outside the conversation that produced them.
9. Compress aggressively. If a WHY cannot be stated in one short line, the rationale is not essential or belongs in the commit body.
10. Respect tool-mandated doc-comment forms. Godoc on exported Go symbols, rustdoc on `pub` items, Sphinx docstrings on public Python APIs, TypeDoc on exported TypeScript APIs. The form is required, including the language's summary-line convention. The non-obvious WHY belongs in subsequent sentences, not in place of the summary.
11. Trailing end-of-line comments stay one line. If you find yourself adding a second line to a trailing comment, rename the variable or extract a helper instead.

Delete-on-sight patterns:

- Paraphrases of the next line or block of code
- Comments naming the identifier they sit on
- File-layout maps in package or module docs
- "Future:", "Revisit when", "Down the line" notes
- "Tracked in X" or "See project N" pointers
- "As discussed", "Per the design doc", "See chat" conversation references
- "Added for ticket X", "Used by Y", "Fix from PR Z" references that rot
- Apologetic openers like "this looks weird but", "I know this is unusual"
- The same WHY repeated in two or more locations
- Commented-out code (delete it; git remembers)
- Section headers in code (`// --- helpers ---`); use functions or files to structure instead
- Decorative banners, ASCII art, separator lines
- Author tags, change logs, version notes (git owns this)

Tool-mandated doc-comment form is the only category that must remain even when it carries no non-obvious WHY. Strip the body, keep the canonical opening line so godoc / rustdoc / Sphinx / TypeDoc and their linters do not break.

Marker comments — TODO, FIXME, XXX, HACK, KLUDGE, BUG, OPTIMIZE (case-insensitive) — are markers of known gaps, not bloat. They get special handling — see Phase 2 step 3a. NOTE is not a marker; treat it as a regular comment.

## Requirements

1. Every source file in scope has been audited against the rules above.
2. No comments matching the delete-on-sight patterns above remain in scope files.
3. Surviving comments document non-obvious WHY in one short line, except where a tool-mandated doc-comment form requires the canonical opening line.
4. Tool-mandated doc-comment forms (godoc, rustdoc, Sphinx docstrings, TypeDoc) are preserved on public APIs that require them.
5. Test suite passes at the end of the run.
6. Linter passes at the end of the run.
7. Baseline and final comment-volume measurements are recorded in the working document.
8. The entire cleanup is captured in a single commit at the end of the run.

## Constraints

- Comments only. Do not refactor code, rename identifiers, change behaviour, restructure files, or modify tests beyond removing or compressing comments. Re-adding marker comments via Phase 3 step 6 option (R) is the only permitted addition.
- Do not migrate extracted comment rationale to `docs/decisions.md`, `roadmap.md`, or any other source-adjacent document. If a rationale cannot compress to one source line, delete it and trust git history. Files created by Phase 3 step 6 dispositions (options S, T) are exempt.
- Do not invent commit-body rationale for behaviour you do not understand. If a comment carries WHY you cannot evaluate, ask the user before deleting it.
- Respect tool-mandated doc-comment forms. Stripping godoc on exported Go symbols, rustdoc on `pub` items, or Sphinx docstrings on Python public APIs will break linters and external documentation.
- Do not commit per file or per phase. Commit once at Phase 3.
- The working document is not part of the cleanup. Do not stage or commit it. Keep code and tests as the only content of the single commit.

## Implementation Plan

### Phase 1: Survey (one-time setup)

Skip this phase if the working document's Files section is already populated; resume from Phase 2 instead.

1. Locate or create the working document per the Working Document section above.
2. Identify the primary code language(s) of the repository. Use file-extension counts and the presence of language manifests (`go.mod`, `pyproject.toml`, `package.json`, `Cargo.toml`, etc.).
3. Derive the list of file extensions in scope for those languages.
4. Identify exclusion patterns specific to this repository. Common patterns: `vendor/`, `node_modules/`, `dist/`, `build/`, `target/`, `__pycache__/`, `.terraform/`, `generated/`, `*.pb.go`, `*_generated.*`.
5. Identify any in-tree third-party libraries or vendored code. Ask the user whether to include each in scope before adding to the file list.
6. Derive the comment-extraction command for the language. Examples:
   - Go: `rg -No --no-filename -t go '//.*'` plus `rg -No --no-filename -t go --multiline '/\*[\s\S]*?\*/'`
   - Python: `rg -No --no-filename -t py '#.*'` plus `rg -No --no-filename -t py --multiline '"""[\s\S]*?"""'`
   - TypeScript: `rg -No --no-filename -t ts '//.*'` plus `rg -No --no-filename -t ts --multiline '/\*[\s\S]*?\*/'`
   - Rust: `rg -No --no-filename -t rust '//.*'`
7. Run the extraction command piped to `wc -c` to record the baseline comment volume. Write the numbers into the Current State section of the working document.
8. Enumerate every source file in scope using `fd` or `rg --files`. Populate the Files section of the working document as a markdown checklist, one file per line, in deterministic order (alphabetical by path).

### Phase 2: Per-file walk

For each unchecked file in the working document's Files section, in checklist order:

1. Read the entire file. If the file no longer exists (deleted in a separate change since the checklist was built), mark `[x] (deleted)` in the Files section and skip to the next file. Otherwise, before processing, scan the working document's TODOs section and delete any pre-existing entries matching this file's path — the file is being re-walked wholesale; any prior entries from an interrupted run will be re-discovered as the walk proceeds.
2. Identify every comment block (line and multiline forms).
3. For each comment, apply the rules above:
   a. If it is a marker comment (TODO, FIXME, XXX, HACK, KLUDGE, BUG, or OPTIMIZE — case-insensitive), record it in the working document's TODOs section with a `path/to/file:line — comment text` entry (preserve the original phrasing and marker keyword), then delete from source. If the marker appears within a larger comment block (e.g. a TODO line inside a doc-comment), extract only the marker line; the rest of the block continues through rules b–g.
   b. If it is a tool-mandated doc-comment form on an exported symbol, public symbol, or package declaration, keep the canonical opening line and apply rules c–f to the body.
   c. If it matches a delete-on-sight pattern, delete it.
   d. If it restates the identifier or paraphrases the code, delete it.
   e. If it duplicates a WHY documented elsewhere, delete the duplicate (keep the one at the point of consequence).
   f. If it carries real non-obvious WHY, compress to one short line.
   g. If you cannot evaluate the rationale, defer that comment until you have audited the entire file, then ask the user about every deferred comment in one batch before marking the file done.
4. Re-read the file after edits. Confirm no rule violations remain.
5. Mark the file as `[x]` in the Files section. Mark even when no edits were required (every comment was conformant).
6. Continue to the next file. Do not commit.

Resume protocol: if the session is interrupted mid-file, leave the file unchecked. A new agent reading the working document will re-process the file from scratch; step 1's TODOs-section scan wipes any partial-state entries for that file so the re-walk replaces them cleanly.

### Phase 3: Final measurement and commit

1. Re-run the comment-extraction command and pipe to `wc -c`. Record the final comment volume in the working document's Current State section and in the commit message.
2. Compute the delta from baseline. Record it in the commit message.
3. Run the full test suite. Confirm it passes.
4. Run the full linter. Confirm it passes.
5. Run a final grep for textual offenders that should not survive (one pass per pattern, case-insensitive):
   - `Future:`
   - `Tracked in`
   - `Revisit when`
   - `Down the line`
   - `As discussed`
   - `See chat`
   - `See project`
   - `Per the design doc`
   - `Added for ticket`
   - `Used by`
   - `Fix from PR`
   Investigate every hit. Either delete or justify to the user.
6. Print every entry from the working document's TODOs section to the user as a numbered list, in collection order, with `path/to/file:line — text` per entry. The user must be able to review every TODO without opening another file and must be able to reference items by number when choosing per-TODO dispositions. Then present the disposition options and accept any combination — a single choice for the whole list, or different choices per TODO (e.g. "(T) for 1, 3, 5; (R) for 2; (D) for the rest"):
   - (S)ave: write the list to a dedicated document (e.g. `todos.md` at the repo root).
   - (T)icket: create a standalone ticket document to walk through and resolve each TODO.
   - (I)ssues: file one issue per TODO in the user's tracker (Jira, GitLab, GitHub).
   - (R)estore: re-introduce specific TODOs to their original location in source.
   - (D)iscard: delete the list without further action.
   Do not act unilaterally. Wait for the user's choices before executing.
7. Stage every modified source and test file. Do not stage the working document.
8. Commit with a structured message:
   - Subject: short summary of the cleanup
   - Body: scope (languages, file count), baseline and final comment volume with delta, rule categories applied, TODO disposition, anything escalated to the user during the walk
9. Do not push.
10. Ask the owner whether to delete the working document now that the run is complete.

## Implementation Guidance

- Bias toward deletion. The user's stated preference is "code speaks for itself". When in doubt between deleting and compressing, delete.
- The Files checklist in the working document is the only state. The checklist marks tell a fresh agent where to resume across sessions.
- File-at-a-time, not package-at-a-time. If a doc comment in file A references a symbol in sibling file B, process both files before marking either as done.

## Acceptance Criteria

1. Every entry in the working document's Files section is marked `[x]`.
2. The final grep listed in Phase 3 step 5 returns zero hits in scope files, or every hit has been justified to the user.
3. The full test suite passes.
4. The full linter passes.
5. Baseline and final comment-volume measurements are present in the working document's Current State section and the commit message, with the delta computed.
6. A single commit on the working branch captures the entire cleanup, and the working document is not part of it.
7. No new files were created to hold extracted comment rationale. Files created by Phase 3 step 6 dispositions (options S, T) are exempt.
8. Every marker comment encountered during Phase 2 is recorded in the working document's TODOs section with a `path/to/file:line — text` entry, and its disposition is recorded in Phase 3 step 6.
