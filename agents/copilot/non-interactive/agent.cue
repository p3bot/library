package non_interactive

import "github.com/p3bot/library/schemas@v1"

agent: schemas.#Agent & {
	agentdex:      "copilot"
	command:       "{{.bin}} --model {{.model}} --allow-all-tools --prompt {{.prompt}}"
	description:   "GitHub Copilot CLI in non-interactive mode - completes task and exits"
	default_model: "sonnet"
	tags: ["github", "copilot", "coding", "agent", "non-interactive", "scripted"]
}
