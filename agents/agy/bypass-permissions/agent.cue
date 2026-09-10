package bypass_permissions

import "github.com/p3bot/library/schemas@v1"

agent: schemas.#Agent & {
	agentdex:      "agy"
	command:       "{{.bin}} --model {{.model}} --dangerously-skip-permissions --prompt-interactive {{.prompt}}"
	description:   "Antigravity CLI with all permissions bypassed - for background and automated tasks"
	default_model: "flash"
	tags: ["google", "agy", "antigravity", "coding", "agent", "automation", "background", "bypass-permissions"]
}
