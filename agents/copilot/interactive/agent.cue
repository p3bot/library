package interactive

import "github.com/p3bot/library/schemas@v1"

agent: schemas.#Agent & {
	agentdex:      "copilot"
	command:       "{{.bin}} --model {{.model}} --interactive {{.prompt}}"
	description:   "GitHub Copilot CLI - agentic coding assistant"
	default_model: "sonnet"
	tags: ["github", "copilot", "coding", "agent"]
}
