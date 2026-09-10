package edit

import "github.com/p3bot/library/schemas@v1"

agent: schemas.#Agent & {
	agentdex:      "agy"
	command:       "{{.bin}} --model {{.model}} --mode accept-edits --prompt-interactive {{.prompt}}"
	description:   "Antigravity CLI with auto-accepted file edits - for trusted editing sessions"
	default_model: "flash"
	tags: ["google", "agy", "antigravity", "coding", "agent", "trusted", "auto-edit"]
}
