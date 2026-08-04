package unattended

import "github.com/p3bot/library/schemas@v1"

agent: schemas.#Agent & {
	bin:         "gemini"
	command:     "GEMINI_SYSTEM_MD={{.role_file}} {{.bin}} --model {{.model}} --approval-mode yolo --prompt {{.prompt}}"
	description: "Gemini CLI in unattended mode - non-interactive with all approvals bypassed"
	default_model: "pro"
	models: {
		flash: "gemini-3-flash-preview"
		lite:  "gemini-3.1-flash-lite-preview"
		pro:   "gemini-3.1-pro-preview"
	}
	tags: ["google", "gemini", "coding", "agent", "unattended", "non-interactive", "bypass-permissions", "automation"]
}
