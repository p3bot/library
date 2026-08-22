# Skills Writing Guide

This guide is for an agent authoring a `SKILL.md`. The skill is read only by agents. Optimise every token for agent comprehension. Discard anything written for human comfort.

A skill exists to give an agent a capability or knowledge it does not already have. If the agent already performs the task well without the skill, the skill adds cost and no value. Write the skill only for the gap.

This guide is kind-agnostic. CLI is one kind, not the default shape. Use the body patterns that fit; do not force a command catalogue onto a process or file-format skill.

## Fetch the specification

The format contract is the Agent Skills specification. Fetch it before writing anything. Do not fetch HTML. Do not fetch `llms-full.txt`. If this guide and the spec disagree on format, the spec wins.

```
curl -sL https://agentskills.io/specification.md
```

Discover other pages at `https://agentskills.io/llms.txt`. Each docs URL has a `.md` sibling; `curl` that. Load skill-creation pages only when that topic is in scope; see Official pages.

This guide owns token-efficient authoring on top of that contract: the description trigger recipe, artefact-not-narration, the CLI catalogue pattern, markdown, and editing. It does not restate frontmatter fields, directory layout, or the spec's three-tier load model.

Most skills need only `name` and `description`. Other frontmatter fields are as the spec defines them.

## Kinds

| Kind | Capability | Typical body shape |
| --- | --- | --- |
| CLI | Drive a product from a shell | Catalogue + workflows + invariants (see CLI skills) |
| File / format | Create or edit a file type | Structure, templates, validation loops |
| API / SDK | Call HTTP or language APIs | Auth, request shapes, error handling |
| Process | Review, design, multi-step method | Checklists, plan-validate-execute |

## Progressive disclosure

Design to the spec's three tiers. House deltas:

- Tier 1 is paid on every run for every installed skill. Keep the description trigger-only (see Writing the description)
- Tier 2 competes with the conversation. Keep only what every activation needs
- Push anything large, optional, or situational to tier 3 and name the exact trigger for loading it
- Content the agent rarely needs costs nothing in tiers 1 and 2 if it lives in tier 3 with a load trigger

## Writing the description

The description is the activation gate. At startup the agent sees only tier 1 (`name` + `description`) for every installed skill. From that alone it decides whether to load the body. If the description does not fire, the body never runs. Spend disproportionate care here.

### What the description is for

The deciding agent is not learning the skill yet. It is answering one question: does this user turn need this skill?

A good description makes the agent think it probably wants this skill. Optimise for triggering. Do not spend description tokens on stopping triggers.

| Belongs in the description | Belongs in the body |
| --- | --- |
| Domain identity (what kind of work this skill owns) | Procedures, workflows, step order |
| When to load (task shapes, intents, situations) | How tools, CLIs, or APIs work |
| Keywords and casual phrases users actually say | Command flags, schemas, templates |
| Soft intents (need is clear, domain name absent) | Gotchas, defaults, validation loops |
| | Prefer-over rules, anti-patterns, refusals |
| | Full capability catalogue |

Never put Do NOT, don't use, or not for … lists in the description. Negative gates fight activation. If the agent loads the skill on a near-miss, the body can redirect or no-op; if the skill never loads on a real hit, nothing can fix it. Prefer-over and refuse rules live in the body.

Hard rules:

- If a line only helps after the skill is already loaded, it does not belong in the description
- If you are unsure whether a line is teaching or triggering, cut it from the description
- If you are unsure whether a cue helps activation, keep the cue (bias to fire)

For the description, "what" means domain identity, not a manual. Domain identity is the product, format, or problem space in a few words the agent can match on. "When" is the larger half: intents, nouns, verbs, and phrasings that signal the domain.

### How to write one

Work the description before polishing the body. Trigger failure is total failure for the skill. Complete steps 1 and 2 in scratch before writing any YAML. Do not draft the paragraph first.

1. Write the should-trigger list (at least 8 items). Real user goals and exact phrasings this skill must catch. Mix formal and casual, short and long, with and without the product name. Example shapes: "mark it done", "add a profit column to the xlsx", "pick up the next task"
2. Write the soft-intent list (at least 5 items). Same need, product name absent or buried. These become the even if they only say "…" bag. If you cannot list five, the domain identity is probably too vague
3. Draft exactly these four parts, in order, as one paragraph:
   - Domain identity (one short clause or sentence: product/format + problem space)
   - Use when … (situations and intents from step 1)
   - Cue bag (names, file types, verbs users say — concrete tokens only)
   - Soft intents: even if they only say "…" (phrases from step 2)
4. Strip teaching. Delete every line that explains how to do the work, any Do NOT / don't use / not for wording, any prefer-over procedure, any flag or schema detail. Keep only what changes the load decision
5. Self-check (all must pass before you ship the frontmatter):
   - Opens with domain identity, then Use when or equivalent imperative
   - Contains concrete cues (file types, product names, or user verbs), not only abstract categories
   - Contains at least two soft-intent quoted phrases or clear paraphrase cues
   - Zero teaching lines (no how-to, no path recipes, no output formats)
   - Zero negative gates (no Do NOT / don't use / not for)
   - One paragraph; well under 1024 characters. If over ~600 characters, drop the weakest cues, not the soft intents
6. Optional later: run the triggering loop. On should-trigger misses, add cues or soft intents. On unwanted loads, sharpen domain identity and the Use when clause with more specific positive signals — never by adding Do NOT to the description

### Phrasing rules

- Imperative, aimed at the deciding agent: "Use when…" or "Use this skill when…", not "This skill does…"
- User intent and task shape, not internal mechanics
- Pushy: cover soft intents. Err toward loading when relevance is plausible
- Concrete keywords beat abstract categories. Prefer "pj", ".pptx", "mark it done" over "project tooling" alone
- Command or subcommand names may appear as trigger keywords when users say them; do not explain what those commands do
- One tight paragraph (YAML `>-` fold is fine). No recipe lists. No negative gate lists

### Good and bad

Bad (vague; no when; no cues):

```
Helps with project management.
```

Bad (teaches the workflow; burns tier-1 tokens on post-load content):

```
Project management via the pj CLI. Path hand-off, not a web board: create or
resolve work with pj, edit the printed document path, change status and order
through the CLI. Prefer pj over ad-hoc TODO files or inventing filenames.
```

Bad (negative gates; optimises for not firing):

```
Use for pj project files. Do NOT use for Jira, Linear, GitHub Issues, or
ordinary markdown unrelated to a scope.
```

Good (domain + when + cues + soft intents; teaching left for the body):

```
Project management with the pj CLI: plain markdown project, plan, or spec
files in a scope. Use when the user is doing feature or ticket work in a
pj-managed repo, or mentions pj, scope, the board, next, claim, mark,
depends, tickets, or project files — even if they only say "pick up the next
task", "what's on the board", "mark it done", or "create a project".
```

Good (same pattern, different domain — file-type skill):

```
Spreadsheet work on .xlsx, .xlsm, .csv, or .tsv files. Use when the user
wants to open, edit, create, clean, chart, or convert a spreadsheet, or
mentions an xlsx/csv path — even if they only say "add a column to this
sheet", "fix the totals", or "the spreadsheet in Downloads".
```

Both good examples stop at activation. Path hand-off, formulas, libraries, and refusals are body content.

### Nuances

- Agents often skip skills for trivial one-step tasks they can already do. Word the description toward work that genuinely needs the skill's knowledge or procedure
- Tier 1 is paid on every run for every installed skill. Prefer a sharp positive trigger over an exhaustive essay
- Do not compensate for a vague description by repeating it in the first body heading. Fix the description; keep the body for how
- False loads are cheaper than missed loads. The body handles a wrong activation; silence cannot

## Writing the body

The body teaches how to perform the task once the description has already fired. Do not restate the description's trigger logic.

- Add what the agent lacks; omit what it knows. For each line ask: would the agent get this wrong without it? If no, cut it
- Design a coherent unit. Too narrow forces several skills to co-load; too broad makes activation imprecise and bloats the body
- Aim for moderate detail. Concise stepwise guidance with one working example beats exhaustive documentation. Leave the long tail to judgement and to `--help` or API docs
- Calibrate control to fragility. Be prescriptive where operations are fragile, order matters, or consistency is required. Give freedom where many approaches are valid
- Provide a default, not a menu. When several tools could work, pick one; mention an alternative only as a brief escape hatch for a named case
- Teach procedures, not declarations. Give the reusable method that generalises across instances, not the answer to one specific instance

Fetch `https://agentskills.io/skill-creation/best-practices.md` if you need more calibration detail than this section.

### H1 and the opening paragraph

- H1 is domain identity in plain language (for example `# Spreadsheet work on xlsx`). It is not a second product badge that only repeats frontmatter `name:`
- The first body paragraph is operating invariants only: hand-off outputs, ownership, stream contracts, safety bounds. It is not a restatement of the description
- Hard rule: if a sentence would still make sense as description (domain identity, when to load, cue bag), delete it from the body

### Ground in real behaviour

Author from the running product, not from design prose or memory.

- CLI: walk `--help` (and subcommand help), exit codes, and tests or source when help is ambiguous
- API: OpenAPI or live responses, not aspirational docs
- File / format: a real file, the library or validator you will call, not a remembered schema
- When skill text and the product disagree, change the skill. Never invent flags, fields, side effects, or recovery steps the product does not implement

### Artefact, not narration

Show the artefact the agent will copy. Do not narrate it. If the artefact already says it, omit the comment.

| Kind | Artefact in a fence or table | Prose around it |
| --- | --- | --- |
| CLI | One catalogue of invocations | Invariants the names cannot carry |
| File / format | Structure, template, validation loop | Why a field exists, what must not be invented |
| API / SDK | Request/response shapes, auth, error tokens | Ownership and side effects |
| Process | Checklist or plan-validate-execute skeleton | Gates and stop conditions |

Prose carries rules a comment or a line in the artefact cannot. Invariants that apply to many items live once, not restated per item.

### Skill versus help

| Put in the skill | Leave to `--help`, man, OpenAPI, or error text |
| --- | --- |
| Multi-step sequences and goal-shaped workflows | Full flag encyclopaedias |
| Tool-owned fields and verb ownership | Every status code or key definition |
| Hand-off outputs and stdout/stderr contracts | Verbose restatement of Long help |
| Side-effect boundaries | Rare edge matrices |
| Agent-hostile commands (omit or one-line refuse) | Interactive TTY flows the agent will not run |
| Gotchas that cause wrong actions | Token or error catalogues that already name the fix |

### Refusals

Prefer embedding a refuse next to the command, template, or workflow it bounds. A standalone Don't dump is a last resort when scatter fails. Never put refusals in the description.

## CLI skills

Use this chapter when the skill's capability is driving a command-line tool. Skip it for file, API, and process skills.

### Recipe

1. Inventory the command tree: root help, every subcommand `--help`
2. Filter for agents: drop interactive, TTY-only, `$EDITOR`, and GUI-only commands. Keep scriptable verbs
3. `## Commands`: one fence, the entire kept surface, usage-shaped lines. Not a table of descriptions. Not many small fences. Not a paste of full Long help
4. Optional domain-model section when the CLI manages durable objects (file shape, resource ids, ownership tables)
5. `## Workflows`: user goals as compact `cmd -> cmd` / `cmd | cmd` lines. A fenced sequence only when a pipeline cannot carry the branch
6. Short invariants (intro and/or mid-body) covering the concepts below, in the product's words
7. Cold-agent re-read (see Authoring review), then leave the long tail to `--help`

### Skeleton

Rename headings to fit the product; keep the roles: catalogue, then sequences, with invariants where they prevent wrong actions.

~~~~
# <Domain identity with tool name>

<3-8 lines of invariants only — no description echo>

## Commands

```
prog verb <args> [flags]    # only if the line is not self-describing
prog other <args>
```

## <Domain model if needed>

## Workflows

goal: `prog a` -> `prog b` | `prog c`
~~~~

### House rules

- The line is the invocation the agent may run. Treat the block as an allowlist; do not invent verbs that are not in it
- Prefer self-describing names so the `#` comment is optional. If the verb already says it, omit the comment. If it does not, one fragment, not a sentence of instruction
- For a CLI you own, fix the verb rather than writing a comment. For a CLI you do not own, the comment is the patch
- Do not wrap each command in prose. If a rule applies to many verbs, it is an invariant bullet, not N comments
- Group related verbs with blank lines inside the one fence
- Do not copy another skill's vocabulary, heading set, or product invariants. State this product's rules in this product's words

### Concepts to instantiate

Use product language in the skill. These are kinds of fact, not required headings.

| Concept | What to teach |
| --- | --- |
| Ambient context | How cwd, env vars, and flags select the target |
| Hand-off outputs | Paths, ids, URLs, or names printed on stdout that the agent must use as-is — never invent |
| Stream contract | Structured data on stdout; diagnostics / stable tokens on stderr — parse both |
| Verb ownership | Which state only mutates through the CLI |
| Tool-owned state | Fields or files the agent must not rewrite as a side effect of other edits |
| Mint via CLI | Create resources with the tool; do not fabricate ids or filenames |
| Side-effect boundaries | What auto-commits or auto-applies locally vs what needs an explicit publish / sync / apply step |
| Agent-hostile commands | Interactive or editor-only verbs: omit from Commands or mark hard-refuse |
| Concurrency | Locks, claim steps, or one-writer norms when parallel agents share state |

## Markdown

The spec allows CommonMark. For agent-facing `SKILL.md` in this house, apply these token-efficient rules anyway. The reader is an agent.

Do not use:

- Bold or italic formatting
- Horizontal rules
- Emojis
- HTML comments
- Image embeds (use regular links instead)
- Multiple consecutive blank lines
- Nested lists beyond 3 levels
- Task lists
- Heading depth beyond `###`
- Directory structures beyond depth 3

Keep:

- Headings for structure
- Single blank lines between sections
- Inline code and code blocks
- Tables for structured data
- Lists (ordered and unordered)
- Callout prefixes without bold

Prefer imperative, declarative phrasing. State negative constraints before the actions they bound. Use `If condition -> action` form for conditional logic. Use tables for anything with more than one variable per row. Strip filler: no "please", no "you should try to", no restated context.

## Editing

Apply these when writing from scratch and when editing an existing skill. Re-check the diff against them mechanically, not from memory. Do not drive-by-refactor a skill the user did not ask to change; finish the requested edit, then mention the redundancy.

- One home per fact. Keep each rule, value, or list in a single authoritative place. If this guide and the spec both could hold a format fact, the spec holds it. If two files in the skill would say the same thing, keep one and point
- Avoid no-op statements. If a statement is not required for the skill to function, remove it
- Avoid no-op guardrails. A new "do Y" already replaces "do X". Do not keep both unless the old action remains a live footgun
- Fix the class of problem, not the instance. Generalise along a real dimension; do not mint a one-off exception. Be precise. Do not overgeneralise

## Authoring review

Before or alongside harness tests, review the draft as a cold agent that has only the skill (no design docs, no tribal memory).

1. List the three to five most common user goals this skill must enable
2. For each goal, write the command sequence or procedure you would run using only the skill text
3. List residual fuzzy points (terms undefined, missing branches, unclear ownership)
4. For each fuzzy point, add the smallest line that prevents a wrong action — prefer a comment in an existing artefact or a clause in the intro over a new section
5. Re-read once. Stop when the hot path is solid and residuals are help-level (flag detail, rare edges)

Optional for high-stakes product contracts: co-author unit-by-unit with a human (one section or workflow at a time; no silent bulk rewrite of the whole skill).

## Official pages

Always:

```
curl -sL https://agentskills.io/specification.md
```

When that work is in scope:

| Topic | URL |
| --- | --- |
| Catalog of pages | `https://agentskills.io/llms.txt` |
| Body calibration | `https://agentskills.io/skill-creation/best-practices.md` |
| Description eval harness | `https://agentskills.io/skill-creation/optimizing-descriptions.md` |
| Output quality evals | `https://agentskills.io/skill-creation/evaluating-skills.md` |
| Bundled scripts | `https://agentskills.io/skill-creation/using-scripts.md` |

Skip overview, clients, client-implementation, HTML, and `llms-full.txt`. Ignore residual MDX chrome (`<Card>`, `theme={null}`).

House testing bias, if you run evals: a should-trigger miss means add positive cues and soft intents; a false trigger means sharpen domain identity and Use when with more specific positive signals. Never fix false triggers by adding Do NOT to the description. If pass rate plateaus while rules pile up, remove instructions and see if results hold.

If you bundle scripts: non-interactive, documented by `--help`, data on stdout, diagnostics on stderr, meaningful exit codes. Details on the using-scripts page.

## Pre-ship checklist

- `name` matches the folder, as the spec constrains it
- `description` is trigger-only: domain identity + Use when + cues + soft intents; no procedures; no Do NOT / don't use gates; imperative; under 1024 chars; scratch lists and self-check done before ship
- H1 is domain language, not only a repeat of `name:`; opening paragraph has zero description echo
- Body stays within the spec's size guidance; larger material moved to tier 3 with explicit load triggers
- Every line in the body would change agent behaviour; no general knowledge, no filler
- Body matches real product behaviour — no invented flags, fields, or recovery
- Kind-appropriate artefact is shown, not narrated. CLI skills: one Commands fence, workflows as pipelines, invariants in product language
- Refusals co-located with the bound command or workflow; no description negatives
- Defaults given instead of menus; control calibrated to fragility
- Markdown follows the token-efficient rules above
- Cold-agent re-read done; hot path runnable from the skill alone
- Triggering and output tested when a harness is available; the delta justifies the skill's cost
