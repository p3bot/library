# Create Ticket Document

Create a new ticket document following the ticket writing guide.

## Process

### Step 1: Check for an Existing Active Ticket

Before creating a new ticket, check whether there is already a current or active ticket document in progress. If the user named a target document, treat that as the ticket to create.

Look for clues in:

- `AGENTS.md` — check for any reference to a current or active ticket
- Repository root — scan for existing ticket or specification documents among the markdown or document files present
- Agent directories: `.agents/`, `.claude/`, `.cursor/`, `.gemini/`, or others
- Documentation folders: `docs/`

A library ticket document is a standalone markdown plan (sections per the writing guide). It is not created with `tk create`, need not live in a tk scope, and need not carry YAML frontmatter. Default discovery is file path, AGENTS.md clues, and document-file scans. If the user or custom instructions name a path or resolve one with `tk get`, `tk next`, or `tk next --claim`, honour that path without treating the file as a tk-managed ticket.

When auto-selecting (no path named by the user or custom instructions), do not treat a file as the library ticket document if it has tk-shaped YAML frontmatter (`id` and `status`) or sits on a tk scope board path. Skip those candidates and continue the scan; if only such files remain, ask which document to use rather than auto-selecting them.

Do not assume a fixed filename. If an active ticket document is found, inform the user and confirm they want to create a new one before continuing.

### Step 2: Load the Writing Guide

Run the following command to load the ticket writing guide, which defines the canonical structure, sections, formatting, and principles for ticket documents:

```bash
start get contexts:ticket/writing
```

The guide is the single source of truth for how a ticket document is written. Follow it for the rest of this task.

### Step 3: Gather Requirements

The writing guide defines the document's sections. Gather the inputs only the user can provide, and investigate the rest from the repository.

Ask the user about:

- Goal — what the ticket builds or changes, and why
- Scope — what is in and explicitly out
- Requirements — the concrete deliverables
- Constraints — hard rules (language version, platforms, tooling, compatibility, standards)
- Acceptance criteria — observable, verifiable signals of completion
- Implementation guidance — any ticket-specific preferences worth recording

Investigate rather than ask:

- Current State — read the relevant existing files, configuration, and dependencies
- References — record any sources consulted while drafting
- Implementation Plan — draft the ordered steps from the requirements and current state

Right-size: omit any optional section that does not apply.

### Step 4: Write the Ticket Document

Write the document following the structure, formatting, and principles defined by the writing guide loaded in Step 2.

File placement:

- If the user specified a filename or location, use it.
- If ticket documents using `NN-<slug>.md` numbering already exist in the repo, continue the sequence — name the new file with the next number.
- Otherwise ask the user what to name the document, suggesting a short kebab-case name derived from the goal.
- Place it in the repository root unless an instruction specifies a different location.

Do not place the document via `tk create` or require tk scope / frontmatter. If the user asks for a path under a tk board, honour that path as a file location only.

### Step 5: Update AGENTS.md

If there is a ticket reference in `AGENTS.md`, update it with the new ticket document.
