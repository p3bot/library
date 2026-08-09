# Begin Ticket

Load the current or active ticket document and implement it.

## Process

### Step 1: Identify the Ticket Document

If the user named a ticket document — in the task instructions or the conversation — use it. If the user or custom instructions resolve a path with `tk get`, `tk next`, or `tk next --claim`, honour that path as the ticket document without treating the file as a tk-managed ticket.

Otherwise locate the current, in progress, or active ticket document. Look for clues in:

- `AGENTS.md` — check for any reference to a current or active ticket
- Repository root — scan for a ticket or specification document among the markdown or document files present
- Agent directories: `.agents/`, `.claude/`, `.cursor/`, `.gemini/`, or others
- Documentation folders: `docs/`

A library ticket document is a standalone markdown plan for one implementation pass. It is not created with `tk create`, need not live in a tk scope, and need not carry YAML frontmatter. Default discovery is file path, AGENTS.md clues, and document-file scans. Do not teach tk workflows end-to-end.

When auto-selecting (no path named by the user or custom instructions), do not treat a file as the library ticket document if it has tk-shaped YAML frontmatter (`id` and `status`) or sits on a tk scope board path. Skip those candidates and continue the scan; if only such files remain, ask which document to use rather than auto-selecting them.

The ticket may be described as "active", "current", "in progress", "working on", or similar terms. Do not assume a fixed filename.

If exactly one clear candidate is found, use it. If multiple candidates are found, or none can be identified with confidence, ask the user which file to use.

### Step 2: Implement

Run the following command to load the implementation guide and follow it:

```bash
start get contexts:ticket/implementation
```

The guide defines the full implementation workflow — Orient, Implement, Verify, Report — and how to surface gaps discovered mid-implementation. Orient against the located ticket document, then work its Implementation Plan through that workflow, asking the user for input only when genuinely blocked.
