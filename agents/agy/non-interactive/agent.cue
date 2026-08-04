package non_interactive

import "github.com/p3bot/library/schemas@v1"

agent: schemas.#Agent & {
	bin:           "agy"
	command:       "{{.bin}} --model {{.model}} --print {{.prompt}}"
	description:   "Antigravity CLI in non-interactive mode - completes task and exits"
	default_model: "flash"
	models: {
		flash:            "Gemini 3.5 Flash (Medium)"
		"flash-high":     "Gemini 3.5 Flash (High)"
		"flash-low":      "Gemini 3.5 Flash (Low)"
		pro:              "Gemini 3.1 Pro (High)"
		"pro-low":        "Gemini 3.1 Pro (Low)"
		"gemini-3-flash": "Gemini 3 Flash"
	}
	tags: ["google", "agy", "antigravity", "coding", "agent", "non-interactive", "scripted"]
}
