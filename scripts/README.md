# library Scripts

Scripts in `./scripts/` for managing CUE modules in the p3bot/library repository.
All scripts are designed to be run from the repository root.
Scripts automatically locate the repository root via their own path.

## validate-module

Validate a CUE module by running cue vet and cue export.
The module type file (role.cue, task.cue, context.cue, agent.cue, skill.cue, index.cue)
is detected automatically.

Usage: validate-module <module-dir>

Arguments:

  module-dir    Path to the module directory relative to the repository root

Examples:

  validate-module roles/git/agent
  validate-module tasks/golang/debug
  validate-module index

Notes:

- Does not run cue mod tidy - run that manually when first creating a module
- Exits non-zero on any validation failure

## validate-index

Validate the index module by running cue vet and asserting the non-TTY
default-resolution contract: every bin appearing in two or more agent index
entries must have at least one entry whose key ends `/interactive` or has no
slash. The contract check is computed in pure CUE so the script has no
dependencies beyond the CUE CLI.

Usage: validate-index [<index-dir>]

Arguments:

  index-dir    Path to the index module (default: index/)

Examples:

  validate-index
  validate-index path/to/fixture-index

Notes:

- Exits non-zero on cue vet failure or any contract violation
- Violations print as JSON listing each offending bin and the keys involved
- See docs/agent-patterns.md for the contract rationale

## publish-module

Create a git tag and publish a single CUE module to the CUE registry.
Does not push to the git remote - use git-push after publishing all modules.

Usage: publish-module <module-path> <version>

Arguments:

  module-path    Path to the module directory relative to the repository root
  version        Semantic version to publish (e.g., v1.0.0, v1.2.3)

Examples:

  publish-module roles/git/agent v1.0.0
  publish-module tasks/golang/debug v1.0.0
  publish-module roles/golang/assistant v1.0.0

Notes:

- Validates version format (must match vX.Y.Z)
- Checks that the git tag does not already exist locally before tagging
- Does not validate the module - run validate-module first if needed
- Does not push to origin - run git-push after all modules are published
- Order is tag locally then publish, matching the AGENTS.md publish-ordering
  rule. Push is deferred to git-push so a failed publish requires only a local
  `git tag --delete`, with no remote cleanup.

## publish-index

Detect the next index patch version, create a git tag, publish the index
module to the CUE registry, then push main and the index tag to origin.

Assumes index/index.cue has already been committed before running.

Usage: publish-index

Arguments: none

Example:

  publish-index

Notes:

- On first publish (no remote `index/*` tag), seeds `v1.0.0`
- On subsequent runs, reads the latest remote index tag via git ls-remote and
  bumps the patch version
- Warns if index/index.cue has uncommitted changes and exits without publishing
- Order is tag locally → publish to registry → push main and the index tag,
  matching the AGENTS.md publish-ordering rule
- Does not push module tags - those are pushed separately via git-push

## git-push

Push the main branch and all local tags to origin.

Usage: git-push

Arguments: none

Example:

  git-push

Notes:

- Run after publish-module to push module git tags to origin
- Safe to run multiple times (git push is idempotent for existing refs)
- Does not publish to the CUE registry - use publish-module or publish-index

## render-template

Render a context, task, role, or agent prompt template with real system values.
Accepts a module directory path, runs cue export to extract the prompt, and
executes the Go template with live environment data populated.

Usage: go run scripts/render-template.go <module-dir>

Arguments:

  module-dir    Path to the module directory relative to the repository root

Examples:

  go run scripts/render-template.go contexts/home/dotagents/environment
  go run scripts/render-template.go tasks/golang/debug
  go run scripts/render-template.go roles/git/agent

Notes:

- Requires Go to be installed (stdlib only, no go.mod needed)
- Populates all standard template variables from the live system
- file_contents is read eagerly if a file field is set
- command_output is executed eagerly if a command field is set
- instructions is always empty (not applicable outside the CLI)

## Common Workflows

### Creating a new role, task, context, agent, or skill

1. Create module directories and files
2. Run cue mod tidy in each module directory to download dependencies
3. validate-module <path>  (repeat for each module)
4. git add <files> && git commit -m "feat(...): ..."
5. publish-module <path> <version>  (repeat for each module)
6. git-push
7. Update index/index.cue with new entries
8. git add index/index.cue && git commit -m "feat(index): ..."
9. publish-index

### Updating an existing module

1. Edit module files
2. validate-module <path>
3. git add <files> && git commit -m "..."
4. publish-module <path> <new-version>
5. git-push
6. Update the version field in index/index.cue
7. git add index/index.cue && git commit -m "feat(index): ..."
8. publish-index

### Index version scheme

The first index publish seeds `v1.0.0`. Subsequent publishes auto-bump the
patch (`v1.0.0 → v1.0.1 → ...`). publish-index reads the latest remote tag
automatically - never guess the next version manually.
