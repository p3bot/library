package edit

import "github.com/p3bot/library/schemas@v1"

agent: schemas.#Agent & {
	agentdex:      "claude-code"
	command:       "{{.bin}} --model {{.model}} --permission-mode acceptEdits --system-prompt-file {{.role_file}} {{.prompt}}"
	description:   "Claude Code with auto-accepted file edits - for trusted editing sessions"
	default_model: "sonnet"
	models: {
		haiku:  "haiku"
		sonnet: "sonnet"
		opus:   "opus"
	}
	tags: ["claude-code", "anthropic", "claude", "coding", "agent", "trusted", "auto-edit"]
}
