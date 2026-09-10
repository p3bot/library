package unattended

import "github.com/p3bot/library/schemas@v1"

agent: schemas.#Agent & {
	agentdex:      "agy"
	command:       "{{.bin}} --model {{.model}} --dangerously-skip-permissions --print {{.prompt}}"
	description:   "Antigravity CLI in unattended mode - non-interactive with all permissions bypassed"
	default_model: "flash"
	tags: ["google", "agy", "antigravity", "coding", "agent", "unattended", "non-interactive", "bypass-permissions", "automation"]
}
