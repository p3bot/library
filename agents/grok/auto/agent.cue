package auto

import "github.com/p3bot/library/schemas@v1"

agent: schemas.#Agent & {
	bin:           "grok"
	command:       "{{.bin}} --model {{.model}} --permission-mode auto --system-prompt-override {{.role}} {{.prompt}}"
	description:   "Grok Build TUI with auto permission mode - fewer prompts with background safety checks"
	default_model: "grok-4.6"
	models: {
		"grok-4.5": "grok-4.5"
		"grok-4.6": "grok-4.6"
		composer:   "grok-composer-2.5-fast"
	}
	tags: ["xai", "grok", "coding", "agent", "auto"]
}
