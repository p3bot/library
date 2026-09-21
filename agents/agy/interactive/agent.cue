package interactive

import "github.com/p3bot/library/schemas@v1"

agent: schemas.#Agent & {
	agentdex:      "agy"
	command:       "{{.bin}}{{if .model}} --model {{.model}}{{end}} --prompt-interactive {{.prompt}}"
	description:   "Antigravity CLI by Google - agentic coding assistant"
	default_model: "flash"
	tags: ["google", "agy", "antigravity", "coding", "agent"]
}
