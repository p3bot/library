# Create Ticket Document

Create a new ticket document following the ticket writing guide.

## Process

### Step 1: Check for an Existing Active Ticket

If the user named a target document, treat that as the ticket to create. If they asked you to check for an existing active ticket, look where they pointed. Otherwise ask whether they want a new ticket or have an existing one in mind.

A library ticket document is a standalone markdown plan (sections per the writing guide).

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

- Use the path they gave
- If none, ask, offering to continue any existing `NN-<slug>.md` sequence at the repository root, else a short kebab-case name derived from the goal
- Place it in the repository root unless they specified a different location

Write the markdown file yourself at the chosen path. Do not require ticket-CLI scope or frontmatter.

### Step 5: Update AGENTS.md

If there is a ticket reference in `AGENTS.md`, update it with the new ticket document.
