# Roles

Role definitions providing system prompts and behavioural instructions for AI agents.

Each subdirectory contains a CUE package defining a role with prompts, instructions, and optional restrictions. Most domains follow an agent / assistant / teacher pattern where:

- agent — autonomous task execution
- assistant — interactive collaborator
- teacher — educational walk-throughs

Not every domain provides all three styles.

The cwd/ and home/ roles carry a `priority`, so start selects the first one whose file exists when no role is named. Lower numbers are tried first: `cwd/dotagents/default` (10), `cwd/role-md` (20), `home/dotagents/default` (50). Every other role is used only when named with `--role` or by a task.

## Structure

```
roles/<domain>/<style>/
├── role.cue
├── role.md
└── cue.mod/module.cue
```

## Available Roles

### cwd/ (current working directory)

- [cwd/dotagents/default](cwd/dotagents/default/) - Default role derived from `./.agents/` workspace settings
- [cwd/role-md](cwd/role-md/) - Role loaded from a local `role.md` file

### git/

- [git/agent](git/agent/) - Git operations agent
- [git/assistant](git/assistant/) - Git assistant
- [git/teacher](git/teacher/) - Git teacher

### gitlab/pipeline/

- [gitlab/pipeline/agent](gitlab/pipeline/agent/) - GitLab CI pipeline agent
- [gitlab/pipeline/assistant](gitlab/pipeline/assistant/) - GitLab CI pipeline assistant
- [gitlab/pipeline/teacher](gitlab/pipeline/teacher/) - GitLab CI pipeline teacher

### golang/

- [golang/agent](golang/agent/) - Go programming agent
- [golang/assistant](golang/assistant/) - Go programming assistant
- [golang/teacher](golang/teacher/) - Go programming teacher

### home/ (user-home configuration)

- [home/dotagents/default](home/dotagents/default/) - Default role derived from `~/.agents/` global settings

### linux/endeavouros/

- [linux/endeavouros/agent](linux/endeavouros/agent/) - EndeavourOS / Arch Linux agent
- [linux/endeavouros/assistant](linux/endeavouros/assistant/) - EndeavourOS / Arch Linux assistant
- [linux/endeavouros/teacher](linux/endeavouros/teacher/) - EndeavourOS / Arch Linux teacher

### markdown/low-token/

- [markdown/low-token/agent](markdown/low-token/agent/) - Token-efficient Markdown agent
- [markdown/low-token/assistant](markdown/low-token/assistant/) - Token-efficient Markdown assistant
- [markdown/low-token/teacher](markdown/low-token/teacher/) - Token-efficient Markdown teacher

### role/design/

- [role/design/agent](role/design/agent/) - Role-design agent (writes new roles)
- [role/design/assistant](role/design/assistant/) - Role-design assistant
- [role/design/teacher](role/design/teacher/) - Role-design teacher
