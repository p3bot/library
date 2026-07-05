# Create Project Document

Create a new project document following the project writing guide.

## Process

### Step 1: Check for an Existing Active Project

Before creating a new project, check whether there is already a current or active project in progress. If the user named a target document, treat that as the project to create.

Look for clues in:

- `AGENTS.md` — check for any reference to a current or active project
- Repository root — scan for existing project or specification documents among the markdown or document files present
- Agent directories: `.agents/`, `.claude/`, `.cursor/`, `.gemini/`, or others
- Documentation folders: `docs/`

Do not assume a fixed filename. If an active project is found, inform the user and confirm they want to create a new one before continuing.

### Step 2: Load the Writing Guide

Run the following command to load the project writing guide, which defines the canonical structure, sections, formatting, and principles for project documents:

```bash
start get contexts:project/writing
```

The guide is the single source of truth for how a project document is written. Follow it for the rest of this task.

### Step 3: Gather Requirements

The writing guide defines the document's sections. Gather the inputs only the user can provide, and investigate the rest from the repository.

Ask the user about:

- Goal — what the project builds or changes, and why
- Scope — what is in and explicitly out
- Requirements — the concrete deliverables
- Constraints — hard rules (language version, platforms, tooling, compatibility, standards)
- Acceptance criteria — observable, verifiable signals of completion
- Implementation guidance — any project-specific preferences worth recording

Investigate rather than ask:

- Current State — read the relevant existing files, configuration, and dependencies
- References — record any sources consulted while drafting
- Implementation Plan — draft the ordered steps from the requirements and current state

Right-size: omit any optional section that does not apply.

### Step 4: Write the Project Document

Write the document following the structure, formatting, and principles defined by the writing guide loaded in Step 2.

File placement:

- If the user specified a filename or location, use it.
- If project documents using `NN-<slug>.md` numbering already exist in the repo, continue the sequence — name the new file with the next number.
- Otherwise ask the user what to name the document, suggesting a short kebab-case name derived from the goal.
- Place it in the repository root unless an instruction specifies a different location.

### Step 5: Update AGENTS.md

If there is a project reference in `AGENTS.md`, update it with the new project document.
