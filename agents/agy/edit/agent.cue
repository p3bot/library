package edit

import "github.com/p3bot/library/schemas@v1"

agent: schemas.#Agent & {
	bin:           "agy"
	command:       "{{.bin}} --model {{.model}} --mode accept-edits --prompt-interactive {{.prompt}}"
	description:   "Antigravity CLI with auto-accepted file edits - for trusted editing sessions"
	default_model: "flash"
	models: {
		flash:            "Gemini 3.5 Flash (Medium)"
		"flash-high":     "Gemini 3.5 Flash (High)"
		"flash-low":      "Gemini 3.5 Flash (Low)"
		pro:              "Gemini 3.1 Pro (High)"
		"pro-low":        "Gemini 3.1 Pro (Low)"
		"gemini-3-flash": "Gemini 3 Flash"
	}
	tags: ["google", "agy", "antigravity", "coding", "agent", "trusted", "auto-edit"]
}
