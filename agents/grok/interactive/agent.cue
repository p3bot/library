package interactive

import "github.com/p3bot/library/schemas@v1"

agent: schemas.#Agent & {
	agentdex:    "grok"
	command:     "{{.bin}} --model {{.model}} --permission-mode default --system-prompt-override {{.role}} {{.prompt}}"
	description: "Grok Build TUI by xAI - agentic coding assistant"
	tags: ["xai", "grok", "coding", "agent"]
}
