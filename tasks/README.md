# Tasks

Task definitions providing specific instructions for AI agents to complete.

Each subdirectory contains a CUE package defining a task with objectives and steps.

## Structure

```
tasks/<domain>/<name>/
├── task.cue
├── task.md
└── cue.mod/module.cue
```

## Available Tasks

### confluence/

- [confluence/doc/read](confluence/doc/read/) - Read and summarise a Confluence document
- [confluence/doc/tree](confluence/doc/tree/) - Render a Confluence space as a tree

### cwd/ (current working directory)

- [cwd/agents-md/create](cwd/agents-md/create/) - Create `AGENTS.md`
- [cwd/agents-md/update](cwd/agents-md/update/) - Update `AGENTS.md`
- [cwd/dotagents/role/create](cwd/dotagents/role/create/) - Create a role file under `./.agents/`
- [cwd/project/begin](cwd/project/begin/) - Resume an in-progress project document
- [cwd/project/create](cwd/project/create/) - Create a project document
- [cwd/project/review](cwd/project/review/) - Review a project document
- [cwd/readme/create](cwd/readme/create/) - Create a `README.md`
- [cwd/readme/update](cwd/readme/update/) - Update a `README.md`

### design/

- [design/review](design/review/) - Review a design document

### git/

- [git/conflict/resolve](git/conflict/resolve/) - Resolve a git merge conflict
- [git/ignore/generate](git/ignore/generate/) - Generate a `.gitignore`

### github/

- [github/issue/triage](github/issue/triage/) - Triage GitHub issues

### gitlab/

- [gitlab/pipeline/review](gitlab/pipeline/review/) - Review a GitLab CI pipeline

### golang/

- [golang/debug](golang/debug/) - Debug a Go program
- [golang/refactor](golang/refactor/) - Refactor Go code
- [golang/release/github-homebrew](golang/release/github-homebrew/) - Release a Go project to GitHub and Homebrew

### jira/

- [jira/item/backlog/review](jira/item/backlog/review/) - Review backlog items
- [jira/item/blocked/review](jira/item/blocked/review/) - Review blocked items
- [jira/item/comment/git-commit](jira/item/comment/git-commit/) - Add git-commit references as Jira comments
- [jira/item/read](jira/item/read/) - Read and summarise a Jira item
- [jira/item/research](jira/item/research/) - Research a Jira item
- [jira/item/review](jira/item/review/) - Review a single Jira item

### review/

- [review/architecture](review/architecture/) - Architecture review
- [review/comments](review/comments/) - Code-comment review
- [review/concurrency](review/concurrency/) - Concurrency review
- [review/correctness](review/correctness/) - Correctness review
- [review/css](review/css/) - CSS review
- [review/dependency](review/dependency/) - Dependency review
- [review/documentation](review/documentation/) - Documentation review
- [review/duplication](review/duplication/) - Duplication review
- [review/error-handling](review/error-handling/) - Error-handling review
- [review/git-diff](review/git-diff/) - Review the current git diff
- [review/holistic](review/holistic/) - Holistic review
- [review/multi-agent/orchestrator](review/multi-agent/orchestrator/) - Orchestrate a multi-agent review
- [review/observability](review/observability/) - Observability review
- [review/performance](review/performance/) - Performance review
- [review/pre-commit](review/pre-commit/) - Pre-commit review
- [review/random-file](review/random-file/) - Review a random file
- [review/readability](review/readability/) - Readability review
- [review/security](review/security/) - Security review
- [review/standards](review/standards/) - Standards review
- [review/test-coverage](review/test-coverage/) - Test-coverage review
- [review/testing](review/testing/) - Testing review

### start/module/ (authoring modules in the start-cli library)

- [start/module/author](start/module/author/) - Create or update any agent, role, context, or task module
