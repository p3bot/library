# Library Publishing Guide

This guide is the single source for publishing a module to the CUE Central Registry from the p3bot library repository. Follow it whenever you create or update an agent, role, context, task, or skill. It assumes the module content is already written. Schema-only publishes follow the Schema-only publish section; schemas are not an index category.

Publishing is irreversible at the tag level: the registry treats every tag as immutable. A tag pushed by mistake cannot be moved or reused. The steps below are ordered to make that safe, and to make the two most common mistakes — forgetting the index, and reusing a tag — impossible to commit by accident.

## Inputs

Identify these before starting:

- Category: one of agents, roles, contexts, tasks, skills. The category is also the top-level directory.
- Noun: the singular form (agent, role, context, task, skill), used in commit descriptions.
- Definition file: agent.cue, role.cue, context.cue, task.cue, or skill.cue.
- Module paths: the path under the category for each module being published. One module in most cases; a role publishes one to three (agent, assistant, teacher).
- Operation: create (a new module, first publication) or update (an existing module).

## Procedure

This procedure is for the five indexed categories (agents, roles, contexts, tasks, skills). Schemas use Schema-only publish instead. Steps, in order. Do not skip or reorder.

### 1. Validate

Confirm the module passes validation from its directory:

```bash
cd <category>/<path>
cue mod tidy
cue vet <module>.cue
cue export <module>.cue
```

Do not proceed if validation fails.

### 2. Determine versions from the remote

The remote is the only source of truth for what is already published. Never read local tags for this.

Find the latest published tag for each module:

```bash
git ls-remote --tags origin "refs/tags/<category>/<path>/*" | sed 's|.*/||' | sort -V | tail -1
```

Find the latest index tag:

```bash
git ls-remote --tags origin "refs/tags/index/*" | sed 's|.*/||' | sort -V | tail -1
```

Compute the next version:

- create: the module has no tag yet; start at v1.0.0.
- update: bump the latest tag per the Versioning policy below.
- index: bump the latest index tag per the Versioning policy; almost always minor.

### 3. Tag-collision preflight

Before writing anything, confirm every tag you are about to create is free on the remote. For each module tag and the index tag:

```bash
git ls-remote --tags origin "refs/tags/<category>/<path>/<version>"
git ls-remote --tags origin "refs/tags/index/<index-version>"
```

Empty output means the tag is free. If any command returns a line, stop: someone has published since you read the remote. Return to step 2 and re-derive. Never force, move, or reuse a tag.

### 4. Update the index

This step is mandatory for agents, roles, contexts, tasks, and skills. It does not apply to schemas. Forgetting it is the most common publishing error.

Edit index/index.cue:

- create: add an entry per module. Copy an existing entry in the same category as a template rather than writing one from memory. Agent entries include a bin field; a role adds one entry per mode; a skill entry has no bin.
- update: set the version field of each affected entry to the new module version.

The version in each index entry must equal the module tag pushed in step 6.

### 5. Commit module and index together

Stage the module directory or directories and index/index.cue, and commit them as one change. Never split the index into a separate commit; the index must never be able to drift from the tag. Refuse to proceed if index/index.cue is not staged.

Use a Scoped Commit. Scope is the module path or area; list multiple scopes comma-separated; no feat or fix prefix:

```
<path>, index: <description>
```

For example:

```
start/library/publishing, index: add publishing workflow context
```

Use an add-style description for create, an update-style description for update.

### 6. Tag and push

Create one tag per module and one for the index:

```bash
git tag "<category>/<path>/<version>"   # repeat per module
git tag "index/<index-version>"
```

Push the branch, then push each tag explicitly. Never use git push --tags, which would push unrelated local tags:

```bash
git push origin main
git push origin "<category>/<path>/<version>"   # repeat per module
git push origin "index/<index-version>"
```

### 7. Publish to the registry

Publish each module, then the index:

```bash
cd <category>/<path>
cue mod publish <version>          # repeat per module from its directory

cd <repo-root>/index
cue mod publish <index-version>
```

Warning: if cue mod publish fails after the tag is already pushed, the tag is spent — do not reuse it. Return to step 2, bump to the next version, and start over.

### 8. Verify

For agents, roles, contexts, and tasks, refresh and validate the whole library, then fix anything reported:

```bash
start update
start doctor validate --force
```

start update pulls any newly published modules. start doctor validate --force pulls the latest index and every module and runs full consistency checks, including that each module's uses references resolve. Resolve any issue it reports before considering the publish complete.

For skills, follow Skills verify below. Still run `start doctor validate --force` as a regression check on the other four categories.

### 9. Close the issue

If a GitHub issue tracks this work, close it:

```bash
gh issue close <issue-number> --repo p3bot/library --comment "Published <module>@<version>"
```

## Schema-only publish

Schemas is not an index category. Do not edit index/index.cue. Do not follow the mandatory index step above.

### 1. Validate

Validate from schemas/:

```bash
cue vet ./...
cue vet *.cue ../docs/examples/<affected>_example.cue
```

Vet every example the schema change touches. Also confirm any unification change (for example a new `uses` category) with a throwaway value against the changed definition. Do not proceed if validation fails.

### 2. Determine the next schemas version from the remote only

```bash
git ls-remote --tags origin "refs/tags/schemas/*" | sed 's|.*/||' | sort -V | tail -1
```

Bump per the Versioning policy. Never read local tags for this.

### 3. Tag-collision preflight

```bash
git ls-remote --tags origin "refs/tags/schemas/<version>"
```

Empty output means the tag is free. If a line returns, stop, re-read the remote, and re-derive. Never force, move, or reuse a tag.

### 4. Commit the schemas module

Commit the schemas module and any new schema examples together. Do not stage index/index.cue. Scoped commit, for example `schemas: add #Skill and skills index map`.

### 5. Tag and push

```bash
git tag "schemas/<version>"
git push origin main
git push origin "schemas/<version>"
```

Never `git push --tags`.

### 6. Publish from schemas/

```bash
cue mod publish <version>
```

If publish fails after the tag is on origin, the tag is spent. Return to step 2, bump, and start over.

### 7. Verify

All of the following must hold:

- `git ls-remote --tags origin "refs/tags/schemas/<version>"` returns the tag
- A throwaway CUE module that depends on `github.com/p3bot/library/schemas@v1` pinned to `<version>` can unify a value against the changed schema
- Exporting that value includes any new schema default that the change introduced

Do not use `start update` or `start doctor validate --force` as proof the schema landed.

## Skills verify

Until start recognises the skills category:

- `start get skills:…` and `start library skills` return unknown-category. That is expected and is not a publish failure
- `start doctor validate --force` is silent about the skill. It never loads it. Treat doctor as a regression check on the other four categories only

Proof the skill landed is registry resolution and the git tag:

- The skill git tag is on origin
- A throwaway CUE module can fetch `github.com/p3bot/library/skills/<path>@v1` at the published version
- The fetched index contains `skills["<path>"]` with `version` equal to the skill tag

## Versioning policy

Choose the bump from the nature of the change, following SemVer:

- minor: additive or behavioural content changes — new guidance, new index entries, a new optional field. This is the default for most updates.
- patch: trivial fixes only — a typo or formatting change with no behavioural effect.
- major: breaking the contract — removing or renaming a field consumers rely on, or changing prompt semantics.

The index bump follows the same rule and is almost always minor, because it usually rides along with an additive module change.

## Roles publish all affected modes

A role is three modules (agent, assistant, teacher). Creating a role publishes all three; updating a role publishes only the affected modes. Apply steps 2, 3, 6, and 7 once per affected mode, and add or bump one index entry per mode. Everything else — the single commit, the index, the preflight — is unchanged.

## Parameter summary

| Aspect | create | update |
| --- | --- | --- |
| Module version | v1.0.0 | bump latest per policy |
| Index entry | add | bump version field |
| Commit description | add-style | update-style |
| Module count | all three modes for a role; one otherwise | only affected modes or module |
