# Begin Project

Load the current or active project document and implement it.

## Process

### Step 1: Identify the Project Document

If the user named a project document — in the task instructions or the conversation — use it.

Otherwise locate the current, in progress, or active project document. Look for clues in:

- `AGENTS.md` — check for any reference to a current or active project
- Repository root — scan for a project or specification document among the markdown or document files present
- Agent directories: `.agents/`, `.claude/`, `.cursor/`, `.gemini/`, or others
- Documentation folders: `docs/`

The project may be described as "active", "current", "in progress", "working on", or similar terms. Do not assume a fixed filename.

If exactly one clear candidate is found, use it. If multiple candidates are found, or none can be identified with confidence, ask the user which file to use.

### Step 2: Implement

Run the following command to load the implementation guide and follow it:

```bash
start get contexts:project/implementation
```

The guide defines the full implementation workflow — Orient, Implement, Verify, Report — and how to surface gaps discovered mid-implementation. Orient against the located project document, then work its Implementation Plan through that workflow, asking the user for input only when genuinely blocked.
