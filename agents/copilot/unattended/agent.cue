package unattended

import "github.com/p3bot/library/schemas@v1"

agent: schemas.#Agent & {
	agentdex:      "copilot"
	command:       "{{.bin}} --model {{.model}} --allow-all --prompt {{.prompt}}"
	description:   "GitHub Copilot CLI in unattended mode - non-interactive with all permissions bypassed"
	default_model: "sonnet"
	tags: ["github", "copilot", "coding", "agent", "unattended", "non-interactive", "bypass-permissions", "automation"]
}
