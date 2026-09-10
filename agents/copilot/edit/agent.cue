package edit

import "github.com/p3bot/library/schemas@v1"

agent: schemas.#Agent & {
	agentdex:      "copilot"
	command:       "{{.bin}} --model {{.model}} --allow-tool=write --interactive {{.prompt}}"
	description:   "GitHub Copilot CLI with auto-accepted file edits - for trusted editing sessions"
	default_model: "sonnet"
	tags: ["github", "copilot", "coding", "agent", "trusted", "auto-edit"]
}
