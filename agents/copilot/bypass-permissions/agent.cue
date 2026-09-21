package bypass_permissions

import "github.com/p3bot/library/schemas@v1"

agent: schemas.#Agent & {
	agentdex:      "copilot"
	command:       "{{.bin}}{{if .model}} --model {{.model}}{{end}} --allow-all --interactive {{.prompt}}"
	description:   "GitHub Copilot CLI with all permissions bypassed - for background and automated tasks"
	default_model: "sonnet"
	tags: ["github", "copilot", "coding", "agent", "automation", "background", "bypass-permissions"]
}
