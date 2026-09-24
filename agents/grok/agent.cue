package grok

import "github.com/p3bot/library/schemas@v1"

agent: schemas.#Agent & {
	agentdex:    "grok"
	command:     "{{.bin}}{{if .model}} --model {{.model}}{{end}}{{.permission}}{{if .role}} --system-prompt-override {{.role}}{{end}}{{.effort}}{{.output}}{{.resume}}{{.print}}"
	description: "Grok Build TUI by xAI - agentic coding assistant"
	flags: {
		permission: {
			default: ["--permission-mode", "default"]
			edit: ["--permission-mode", "acceptEdits"]
			auto: ["--permission-mode", "auto"]
			bypass: ["--permission-mode", "bypassPermissions"]
			plan: ["--permission-mode", "plan"]
		}
		effort: {
			none: ["--effort", "none"]
			minimal: ["--effort", "minimal"]
			low: ["--effort", "low"]
			medium: ["--effort", "medium"]
			high: ["--effort", "high"]
			xhigh: ["--effort", "xhigh"]
			max: ["--effort", "max"]
		}
		output: {
			text: ["--output-format", "plain"]
			json: ["--output-format", "json"]
			"stream-json": ["--output-format", "streaming-json"]
			"streaming-messages-json": ["--output-format", "streaming-messages-json"]
		}
		print: {
			off: ["{{.prompt}}"]
			on: ["--single", "{{.prompt}}"]
		}
		resume: {
			latest: ["--continue"]
			id: ["--resume", "{{.resume}}"]
		}
	}
	tags: ["xai", "grok", "coding", "agent"]
}
