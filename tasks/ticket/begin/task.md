# Begin Ticket

Load the current or active ticket document and implement it.

## Process

### Step 1: Identify the Ticket Document

Identify the ticket document from the user's instructions. If they named a path, use it. If they asked you to find it, look where they pointed. Otherwise ask.

A library ticket document is a standalone markdown plan for one implementation pass.

### Step 2: Implement

Run the following command to load the implementation guide and follow it:

```bash
start get contexts:ticket/implementation
```

The guide defines the full implementation workflow — Orient, Implement, Verify, Report — and how to surface gaps discovered mid-implementation. Orient against the located ticket document, then work its Implementation Plan through that workflow, asking the user for input only when genuinely blocked.
