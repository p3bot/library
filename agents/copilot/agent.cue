package copilot

import "github.com/p3bot/library/schemas@v1"

agent: schemas.#Agent & {
	agentdex:      "copilot"
	command:       "{{.bin}}{{if .model}} --model {{.model}}{{end}}{{.permission}}{{.effort}}{{.output}}{{.resume}}{{.print}}"
	description:   "GitHub Copilot CLI - agentic coding assistant"
	default_model: "sonnet"
	flags: {
		permission: {
			default: []
			edit: ["--allow-tool=write"]
			bypass: ["--allow-all"]
		}
		print: {
			off: ["--interactive", "{{.prompt}}"]
			on: ["--prompt", "{{.prompt}}"]
		}
	}
	tags: ["github", "copilot", "coding", "agent"]
}
