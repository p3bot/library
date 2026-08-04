package edit

import "github.com/p3bot/library/schemas@v1"

agent: schemas.#Agent & {
	bin:           "copilot"
	command:       "{{.bin}} --model {{.model}} --allow-tool=write --interactive {{.prompt}}"
	description:   "GitHub Copilot CLI with auto-accepted file edits - for trusted editing sessions"
	default_model: "sonnet"
	models: {
		sonnet:     "claude-sonnet-4.6"
		haiku:      "claude-haiku-4.5"
		opus:       "claude-opus-4.6"
		"gpt-4.1":  "gpt-4.1"
		"gpt-5.4":  "gpt-5.4"
		"gpt-mini": "gpt-5-mini"
	}
	tags: ["github", "copilot", "coding", "agent", "trusted", "auto-edit"]
}
