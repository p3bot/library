package interactive

import "github.com/p3bot/library/schemas@v1"

agent: schemas.#Agent & {
	agentdex:      "claude-code"
	command:       "{{.bin}} --model {{.model}} --permission-mode default --system-prompt-file {{.role_file}} {{.prompt}}"
	description:   "Claude Code by Anthropic - agentic coding assistant"
	default_model: "sonnet"
	models: {
		haiku:  "haiku"
		sonnet: "sonnet"
		opus:   "opus"
	}
	tags: ["claude-code", "anthropic", "claude", "coding", "agent"]
}
