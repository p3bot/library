package claude

import "github.com/p3bot/library/schemas@v1"

agent: schemas.#Agent & {
	agentdex:      "claude-code"
	command:       "{{.bin}}{{if .model}} --model {{.model}}{{end}}{{.permission}}{{if .role_file}} --system-prompt-file {{.role_file}}{{end}}{{.effort}}{{.output}}{{.resume}}{{.print}}"
	description:   "Hotseat member launch of Claude Code"
	default_model: "sonnet"
	models: {
		haiku:  "haiku"
		sonnet: "sonnet"
		opus:   "opus"
	}
	flags: {
		permission: {
			default: []
			edit: ["--permission-mode", "acceptEdits"]
			auto: ["--permission-mode", "auto"]
			bypass: ["--permission-mode", "bypassPermissions"]
			plan: ["--permission-mode", "plan"]
		}
		effort: {
			low: ["--effort", "low"]
			medium: ["--effort", "medium"]
			high: ["--effort", "high"]
			xhigh: ["--effort", "xhigh"]
			max: ["--effort", "max"]
		}
		output: {
			text: ["--output-format", "text"]
			json: ["--output-format", "json"]
			"stream-json": ["--output-format", "stream-json"]
		}
		print: {
			off: ["{{.prompt}}"]
			on: ["--print", "{{.prompt}}"]
		}
		resume: {
			latest: ["--continue"]
			id: ["--resume", "{{.resume}}"]
		}
	}
	session_locator: ["session_id"]
	tags: ["hotseat", "claude", "claude-code", "anthropic", "coding", "agent", "member"]
}
