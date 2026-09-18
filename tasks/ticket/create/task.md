# Create Ticket Document

Create a new ticket document following the ticket writing guide.

## Process

### Step 1: Check for an Existing Active Ticket

If the user named a target document, treat that as the ticket to create. If they asked you to check for an existing active ticket, look where they pointed. Otherwise ask whether they want a new ticket or have an existing one in mind.

A library ticket document is a standalone markdown document (profile and sections per the writing guide).

### Step 2: Load the Writing Guide

Run the following command to load the ticket writing guide, which defines the canonical structure, sections, formatting, principles, and profiles for ticket documents:

```bash
start get contexts:ticket/writing
```

The guide is the single source of truth for how a ticket document is written. Follow it for the rest of this task.

### Step 3: Choose a Profile and Gather

Ask which profile fits, or infer from what they said. Gather only that profile's inputs. Do not gather implement sections for a capture, decide, design, bug, or investigate ticket.

Gather the inputs only the user can provide, and investigate the rest from the repository. Right-size: omit any optional section that does not apply. Keep identifying headings even when empty.

### Step 4: Write the Ticket Document

Write the document following the structure, formatting, and principles defined by the writing guide loaded in Step 2.

If `command -v tk` succeeds and they did not ask for an unmanaged path, `tk create` with a title from what they named, or from Problem, Summary, or Goal. Do not gather a Goal just to name the file. Add `--tag design` when the profile is design. Fill under the H1 `tk create` printed. Unmanaged File Placement does not apply.

Otherwise follow the writing guide's unmanaged File Placement. Write the markdown file yourself at the chosen path.

### Step 5: Update AGENTS.md

If there is a ticket reference in `AGENTS.md`, update it with the new ticket document.
