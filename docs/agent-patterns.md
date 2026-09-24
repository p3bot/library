# Agent Patterns

Two layouts publish an AI CLI tool.

Claude Code, Copilot, Antigravity, and Grok are one module each. The index key is the agentdex id. The command places `{{.permission}}`, `{{.effort}}`, `{{.output}}`, `{{.resume}}`, and `{{.print}}`, and start fills each slot from that module's `flags` table. Claude, Antigravity, and Grok define all five. Copilot defines permission and print only, so start rejects effort, output, and resume. The command template does not contain `{{.prompt}}`. The print fragment carries the prompt word.

Gemini and AIChat stay `tool/variant` modules. Each variant is its own command, with `{{.prompt}}` in `command` and no `flags` table.

## Flag modules

| Address | agentdex | bin |
| --- | --- | --- |
| `agents:claude-code` | `claude-code` | `claude` |
| `agents:copilot` | `copilot` | `copilot` |
| `agents:agy` | `agy` | `agy` |
| `agents:grok` | `grok` | `grok` |

Command shape. Each flag fragment is empty or begins with a space, because start assembles it that way. `{{.role}}` here is the product's guarded role fragment, not a flags slot. Antigravity and Copilot omit it.

```
{{.bin}}{{if .model}} --model {{.model}}{{end}}{{.permission}}{{.role}}{{.effort}}{{.output}}{{.resume}}{{.print}}
```

Claude guards `--system-prompt-file {{.role_file}}`. Grok guards `--system-prompt-override {{.role}}`. Antigravity has no system-prompt CLI flag. Roles for Antigravity rely on workspace `AGENTS.md` / `GEMINI.md` discovery.

An empty word list accepts the value and inserts nothing. A missing key rejects the flag. Do not add a module that selects these flags for an old variant address.

### permission

| Value | Claude | Copilot | Antigravity | Grok |
| --- | --- | --- | --- | --- |
| `default` | empty | empty | empty | `--permission-mode default` |
| `edit` | `--permission-mode acceptEdits` | `--allow-tool=write` | `--mode accept-edits` | `--permission-mode acceptEdits` |
| `auto` | `--permission-mode auto` | — | — | `--permission-mode auto` |
| `bypass` | `--permission-mode bypassPermissions` | `--allow-all` | `--dangerously-skip-permissions` | `--permission-mode bypassPermissions` |
| `plan` | `--permission-mode plan` | — | `--mode plan` | `--permission-mode plan` |

Claude's `default` row does not send `--permission-mode default`. Claude, Copilot, and Antigravity accept `default` and insert nothing. Grok's `default` sends `--permission-mode default`.

`edit` accepts file edits and still prompts for other actions. `bypass` approves every action. `plan` is that CLI's plan mode. Claude, Antigravity, and Grok have the `plan` key. Copilot does not.

Grok's `auto` safety-checks routine local work and blocks or escalates the rest. Claude's `auto` sends `--permission-mode auto`. Copilot and Antigravity have no `auto` key.

### print

The prompt word appears only here. Off is an ongoing session. On runs the prompt and exits.

| | Claude | Copilot | Antigravity | Grok |
| --- | --- | --- | --- | --- |
| off | `{{.prompt}}` | `--interactive {{.prompt}}` | `--prompt-interactive {{.prompt}}` | `{{.prompt}}` |
| on | `--print {{.prompt}}` | `--prompt {{.prompt}}` | `--print {{.prompt}}` | `--single {{.prompt}}` |

Copilot's on fragment is `--prompt` and `{{.prompt}}` only. It does not include `--allow-all-tools`. Print together with bypass is the permission slot plus this on fragment.

### resume

A dash means the product has no `resume` key, so start rejects `--resume`.

| | Claude | Copilot | Antigravity | Grok |
| --- | --- | --- | --- | --- |
| latest | `--continue` | — | `--continue` | `--continue` |
| id | `--resume {{.resume}}` | — | `--conversation {{.resume}}` | `--resume {{.resume}}` |

### effort

The flag word is `--effort`. The value word is the same word the user passed. A dash means that value is not a key. Copilot has no `effort` key. Grok's per-model menu ids, such as `deep`, are not keys.

| Value | Claude | Antigravity | Grok | Copilot |
| --- | --- | --- | --- | --- |
| `none` | — | — | yes | — |
| `minimal` | — | — | yes | — |
| `low` | yes | yes | yes | — |
| `medium` | yes | yes | yes | — |
| `high` | yes | yes | yes | — |
| `xhigh` | yes | — | yes | — |
| `max` | yes | — | yes | — |

### output

The flag word is `--output-format`. Copilot has no `output` key. Claude and Antigravity map `text`, `json`, and `stream-json` to that same word. Grok maps `text` to `plain`, `json` to `json`, `stream-json` to `streaming-json`, and `streaming-messages-json` to that word.

## Variant modules

Gemini and AIChat keep one module per mode. Prefix the bare name with `agents:` for the full address.

| Agent | Interactivity | Permissions |
| --- | --- | --- |
| `gemini/interactive` | Interactive | Default |
| `gemini/edit` | Interactive | Auto-edit |
| `gemini/bypass-permissions` | Interactive | Bypass all |
| `gemini/non-interactive` | Non-interactive | Default |
| `gemini/unattended` | Non-interactive | Bypass all |
| `aichat/interactive` | Interactive | Default |

Gemini commands:

| Variant | Flags |
| --- | --- |
| `gemini/interactive` | `--approval-mode default --prompt-interactive` |
| `gemini/edit` | `--approval-mode auto_edit --prompt-interactive` |
| `gemini/bypass-permissions` | `--approval-mode yolo --prompt-interactive` |
| `gemini/non-interactive` | `--approval-mode default --prompt` |
| `gemini/unattended` | `--approval-mode yolo --prompt` |

AIChat publishes interactive only. Its command has no permission flag.

For a flag module, pass `--permission` and `--print` on `agents:claude-code`, `agents:copilot`, `agents:agy`, or `agents:grok`. For Gemini, select the variant whose row matches the session. `auto` exists only where that permission key exists.

## Non-TTY Default-Resolution Contract

If a bin appears in multiple agent index entries, at least one of those entries must end with `/interactive` or be a bare-name key (no slash). This is the non-TTY default-resolution contract: the start binary uses it as a tiebreaker when no human is present to choose a variant.

The contract is enforced by `library/scripts/validate-index`. Run it after any change to `index/index.cue` that adds, removes, or renames an agent entry.

In TTY mode the user always picks a variant from a list, so this contract has no effect on the interactive flow.
