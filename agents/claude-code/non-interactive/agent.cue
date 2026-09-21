package non_interactive

import "github.com/p3bot/library/schemas@v1"

agent: schemas.#Agent & {
	agentdex:      "claude-code"
	command:       "{{.bin}}{{if .model}} --model {{.model}}{{end}} --permission-mode default{{if .role_file}} --system-prompt-file {{.role_file}}{{end}} --print {{.prompt}}"
	description:   "Claude Code in non-interactive mode - completes task and exits"
	default_model: "sonnet"
	models: {
		haiku:  "haiku"
		sonnet: "sonnet"
		opus:   "opus"
	}
	tags: ["claude-code", "anthropic", "claude", "coding", "agent", "non-interactive", "scripted"]
}
