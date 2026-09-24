package agy

import "github.com/p3bot/library/schemas@v1"

agent: schemas.#Agent & {
	agentdex:      "agy"
	command:       "{{.bin}}{{if .model}} --model {{.model}}{{end}}{{.permission}}{{.effort}}{{.output}}{{.resume}}{{.print}}"
	description:   "Antigravity CLI by Google - agentic coding assistant"
	default_model: "flash"
	flags: {
		permission: {
			default: []
			edit: ["--mode", "accept-edits"]
			bypass: ["--dangerously-skip-permissions"]
			plan: ["--mode", "plan"]
		}
		effort: {
			low: ["--effort", "low"]
			medium: ["--effort", "medium"]
			high: ["--effort", "high"]
		}
		output: {
			text: ["--output-format", "text"]
			json: ["--output-format", "json"]
			"stream-json": ["--output-format", "stream-json"]
		}
		print: {
			off: ["--prompt-interactive", "{{.prompt}}"]
			on: ["--print", "{{.prompt}}"]
		}
		resume: {
			latest: ["--continue"]
			id: ["--conversation", "{{.resume}}"]
		}
	}
	tags: ["google", "agy", "antigravity", "coding", "agent"]
}
