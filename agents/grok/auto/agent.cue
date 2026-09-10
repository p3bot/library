package auto

import "github.com/p3bot/library/schemas@v1"

agent: schemas.#Agent & {
	agentdex:    "grok"
	command:     "{{.bin}} --model {{.model}} --permission-mode auto --system-prompt-override {{.role}} {{.prompt}}"
	description: "Grok Build TUI with auto permission mode - fewer prompts with background safety checks"
	tags: ["xai", "grok", "coding", "agent", "auto"]
}
