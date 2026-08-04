package non_interactive

import "github.com/p3bot/library/schemas@v1"

agent: schemas.#Agent & {
	bin:           "copilot"
	command:       "{{.bin}} --model {{.model}} --allow-all-tools --prompt {{.prompt}}"
	description:   "GitHub Copilot CLI in non-interactive mode - completes task and exits"
	default_model: "sonnet"
	models: {
		sonnet:     "claude-sonnet-4.6"
		haiku:      "claude-haiku-4.5"
		opus:       "claude-opus-4.6"
		"gpt-4.1":  "gpt-4.1"
		"gpt-5.4":  "gpt-5.4"
		"gpt-mini": "gpt-5-mini"
	}
	tags: ["github", "copilot", "coding", "agent", "non-interactive", "scripted"]
}
