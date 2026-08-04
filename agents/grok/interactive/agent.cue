package interactive

import "github.com/p3bot/library/schemas@v1"

agent: schemas.#Agent & {
	bin:           "grok"
	command:       "{{.bin}} --model {{.model}} --permission-mode default --system-prompt-override {{.role}} {{.prompt}}"
	description:   "Grok Build TUI by xAI - agentic coding assistant"
	default_model: "grok-4.5"
	models: {
		"grok-4.5": "grok-4.5"
		composer:   "grok-composer-2.5-fast"
	}
	tags: ["xai", "grok", "coding", "agent"]
}
