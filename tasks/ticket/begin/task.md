# Begin Ticket

Load the current or active ticket document and work its matched profile.

## Process

### Step 1: Identify the Ticket Document

Identify the ticket document from the user's instructions. If they named a path, use it. If they asked you to find it, look where they pointed. Otherwise ask.

A library ticket document is a standalone markdown document a fresh-session agent can act on. Match its profile from headings.

### Step 2: Work

Run the following command to load the implementation guide and follow it:

```bash
start get contexts:ticket/implementation
```

The guide defines the shared workflow — Orient, Work, Verify, Report, Progress, gaps — and works the matched profile the same way `tasks:tk/id/build` would, unmanaged or tk. Do not invent an Implementation Plan for a profile that has none. For design, that guide loads the design session; do not treat the ticket as complete — the owner accepts, then decompose. Ask the user for input only when genuinely blocked.
