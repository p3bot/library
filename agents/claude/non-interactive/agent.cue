package non_interactive

import "github.com/start-cli/library/schemas@v1"

agent: schemas.#Agent & {
	bin:         "claude"
	command:     "{{.bin}} --model {{.model}} --permission-mode default --system-prompt-file {{.role_file}} --print {{.prompt}}"
	description: "Claude Code in non-interactive mode - completes task and exits"
	default_model: "sonnet"
	models: {
		haiku:  "haiku"
		sonnet: "sonnet"
		opus:   "opus"
	}
	tags: ["anthropic", "claude", "coding", "agent", "non-interactive", "scripted"]
}
