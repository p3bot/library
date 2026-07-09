package unattended

import "github.com/start-cli/library/schemas@v1"

agent: schemas.#Agent & {
	bin:         "claude"
	command:     "{{.bin}} --model {{.model}} --permission-mode bypassPermissions --system-prompt-file {{.role_file}} --print {{.prompt}}"
	description: "Claude Code in unattended mode - non-interactive with all permissions bypassed"
	default_model: "sonnet"
	models: {
		haiku:  "haiku"
		sonnet: "sonnet"
		opus:   "opus"
	}
	tags: ["anthropic", "claude", "coding", "agent", "unattended", "non-interactive", "bypass-permissions", "automation"]
}
