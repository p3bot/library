package non_interactive

import "github.com/p3bot/library/schemas@v1"

agent: schemas.#Agent & {
	bin:         "gemini"
	command:     "{{if .role_file}}GEMINI_SYSTEM_MD={{.role_file}} {{end}}{{.bin}}{{if .model}} --model {{.model}}{{end}} --approval-mode default --prompt {{.prompt}}"
	description: "Gemini CLI in non-interactive mode - completes task and exits"
	default_model: "pro"
	models: {
		flash: "gemini-3-flash-preview"
		lite:  "gemini-3.1-flash-lite-preview"
		pro:   "gemini-3.1-pro-preview"
	}
	tags: ["google", "gemini", "coding", "agent", "non-interactive", "scripted"]
}
