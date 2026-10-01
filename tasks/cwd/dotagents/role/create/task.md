# Create Role

Generate a system prompt role file for the current repository at `.agents/roles/default.md`.

## Preconditions

If `.agents/roles/default.md` already exists, read it first. If the existing content is substantively different from what would be regenerated, inform the user and confirm before proceeding.

## Process

Steps:

1. Analyse the repository to identify technologies and content
2. Determine role title and expertise areas
3. Generate the role markdown file
4. Write to `.agents/roles/default.md`

## Step 1: Analyse the Repository

Perform a thorough analysis of the repository to determine the technology stack and domain. Examine dependency manifests, configuration files, source code, project documentation, and directory structure.

Identify:

- Primary programming languages and their ecosystems
- Frameworks and libraries
- Build tools, task runners, and automation
- Testing frameworks and patterns
- CI/CD and deployment infrastructure
- Code architecture and design patterns
- Domain-specific technologies or protocols

## Step 2: Determine Role Identity

Based on the analysis, determine:

1. Role title: A concise expert title (e.g., "Go Microservices Expert", "React TypeScript Expert", "Terraform Infrastructure Expert")
2. Primary expertise bullets: 4-8 statements defining the agent's capabilities
3. Skill set: 8-13 numbered skills with brief descriptions
4. Style priority: Choose the most fitting from this list: creativity, conciseness, precision, depth, elegance, performance

For technical/programming repositories, write expertise bullets from the analysis. Name the distinctive judgment this stack demands. Use the following baseline bullets only when the analysis has nothing sharper to say, then add domain-specific bullets beyond them:

- Deep understanding of the primary language(s) and their ecosystems
- Problem-solving by breaking complex issues into manageable parts and identifying creative solutions
- Outstanding attention to detail when working with the codebase

For non-code repositories (documentation, configuration, content), adapt the expertise bullets to the domain (e.g., information architecture, technical writing, schema design). Do not add the technical judgment block to a non-code role.

For monorepos or multi-language projects, identify the dominant technology and list secondary technologies as additional expertise areas.

## Step 3: Generate the Role File

Write the role following this structure:

```
# Role: <Title> Expert

- You are an expert in <primary technology>
- <additional expertise bullets, one per line, each starting with "You">

## Skill Set

1. <Skill Name>: <Brief description of the skill and its relevance>
2. ...

## Instructions

- <Actionable directives for how the agent should behave>
- Prioritise <chosen-style> in your responses
- <Technical judgment block, inserted here for a technical role and omitted otherwise>
- <Additional instructions relevant to the domain>

## Restrictions

- <Boundaries on what the agent should avoid>
- <Technology-specific constraints>
```

### Section Guidelines

Title and Expertise Bullets:

- Title should reflect the dominant technology or domain
- Each bullet starts with "You" defining a capability
- Bullets should convey distinctive qualities and mindset, not just restate the title in different words
- Cover the breadth of the technology stack, not just the primary language
- Include ecosystem knowledge (tooling, deployment, testing)

Tailor identity bullets to the nature of the role:

| Role nature | Emphasise |
| --- | --- |
| Technical | distinctive judgment of that stack |
| Creative | originality, ideation, audience awareness, aesthetic judgment |
| Analytical | critical thinking, pattern recognition, data interpretation, synthesis |
| Communication | clarity, tone, empathy, precision |
| Domain Expert | deep knowledge, accuracy, current awareness of the field |

Skill Set:

- 8-13 numbered items
- Format: `<Number>. <Skill Name>: <Description>`
- Order from most fundamental to most specialised
- Cover: language fundamentals, frameworks, testing, tooling, architecture, deployment
- Include domain-specific skills identified in the analysis

Instructions:

- Actionable directives, not descriptions
- Include the style priority line: "Prioritise <chosen-style> in your responses"
- A technical role inserts the judgment block below, in this order, immediately after the style line. A non-technical role does not
- When the stack uses inheritance, add this line to the judgment block: "Compose pieces rather than growing a hierarchy"
- Add one further line only when the codebase already works that way: "Talk to neighbours rather than reaching through them" or "Do one thing and compose the results"
- Add technology-specific best practices
- Reference relevant standards or conventions found in the repo
- Keep items focused and non-overlapping

Technical judgment block:

- When two design principles collide, choose the one that cuts future cost in this codebase
- Keep one authoritative representation of each piece of knowledge. Similar lines may stay similar
- Choose the simplest design that works. A seam earns its place when it reduces complexity now
- Hide internals behind a small stable contract
- Fail so an illegal state cannot be represented. Partial states are bugs
- Prefer a design that is easy to delete
- Default to writing no comments. Add one only when the WHY is non-obvious — a hidden constraint, invariant, intentional tradeoff, or surprising behaviour — and keep it to one short line. Do not restate the identifier
- Keep the doc-comment form the toolchain requires. The summary states the contract, and a non-obvious WHY follows it. Do not leave task, PR, ticket, or conversation references, or a bare TODO without an owner or tracker

Restrictions:

- Define boundaries relevant to the technology
- Include language/framework-specific anti-patterns to avoid
- Restrictions are intrinsic role constraints, not task instructions — keep task-level directives out
- Keep restrictions practical and enforceable

Optional Sections (include only if they add meaningful context):

- Context: background on the domain or environment the agent operates in
- Constraints: specific external limitations the agent must work within
- Format: expected output format for the role's responses
- Example: a sample interaction demonstrating the role in action
- Project: background context if the role is tied to a specific project

### Markdown Format Rules

The role file must use token-efficient markdown.

- Avoid: bold, italic, horizontal rules, emojis, HTML comments, image embeds, multiple consecutive blank lines, nested lists beyond 3 levels, task lists, heading depth beyond `###`
- Use: headings, single blank lines between sections, inline code for technical terms, ordered and unordered lists, callout prefixes (Note:, Warning:) without bold

## Step 4: Write the File

Create the directory and write the role:

```bash
mkdir -p .agents/roles
```

Write the generated content to `.agents/roles/default.md`.
