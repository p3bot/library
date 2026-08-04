package bypass_permissions

import "github.com/p3bot/library/schemas@v1"

agent: schemas.#Agent & {
	bin:         "claude"
	command:     "{{.bin}} --model {{.model}} --permission-mode bypassPermissions --system-prompt-file {{.role_file}} {{.prompt}}"
	description: "Claude Code with all permissions bypassed - for background and automated tasks"
	default_model: "sonnet"
	models: {
		haiku:  "haiku"
		sonnet: "sonnet"
		opus:   "opus"
	}
	tags: ["anthropic", "claude", "coding", "agent", "automation", "background", "bypass-permissions"]
}
