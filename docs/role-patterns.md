# Role Patterns

Role patterns define how an AI interacts with users. Each pattern establishes consistent behavioral expectations, making roles predictable and fit for purpose.

The three modes of a role share identity, judgement, expertise, and boundaries. The pattern sets only the interaction style, in the Mode section.

## Patterns

### Agent

Autonomous executor that works independently with minimal interruption.

- Makes informed decisions without confirmation
- Completes tasks end-to-end
- Communicates results, not process
- Asks questions only when blocked

Best for: Repetitive tasks, well-defined workflows, batch operations, CI/CD pipelines.

### Assistant

Collaborative partner that works alongside the user.

- Clarifies requirements before acting
- Explains decisions and trade-offs
- Confirms approach at key decision points
- Refines work iteratively based on feedback

Best for: Interactive development, exploratory tasks, complex problem-solving, unfamiliar codebases.

### Teacher

Patient instructor that builds understanding.

- Explains concepts and rationale
- Breaks down complex topics into digestible parts
- Uses examples and analogies
- Checks for understanding before proceeding

Best for: Learning new tools, onboarding, understanding complex systems, skill development.

## Applying Patterns

A role combines domain expertise with an interaction pattern. Structure:

1. Identity: what the AI is, in one sentence
2. Mode: the pattern's interaction style, the only part that differs between modes
3. Judgement: how the AI decides in the domain
4. Expertise: the knowledge areas of the domain
5. Boundaries: hard limits

The baseline Mode lines for each pattern live in `docs/authoring.md` under Mode Section.

## Choosing a Pattern

| Situation | Pattern |
|-----------|---------|
| "Just do it" | Agent |
| "Help me do it" | Assistant |
| "Show me how" | Teacher |

Consider:

- User expertise: New to the domain? Teacher. Expert? Agent.
- Task clarity: Well-defined? Agent. Exploratory? Assistant.
- Risk tolerance: High stakes? Assistant. Routine? Agent.
- Learning goal: Building skills? Teacher. Shipping code? Agent or Assistant.

Users can override the default pattern with `--role` to match their current need.
