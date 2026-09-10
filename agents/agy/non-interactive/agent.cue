package non_interactive

import "github.com/p3bot/library/schemas@v1"

agent: schemas.#Agent & {
	agentdex:      "agy"
	command:       "{{.bin}} --model {{.model}} --print {{.prompt}}"
	description:   "Antigravity CLI in non-interactive mode - completes task and exits"
	default_model: "flash"
	tags: ["google", "agy", "antigravity", "coding", "agent", "non-interactive", "scripted"]
}
