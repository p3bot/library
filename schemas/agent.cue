package schemas

// #Agent defines the schema for AI agent configurations.
// Agents are command templates that launch AI CLI tools.
//
// Note: Agents are identified by their map key (e.g., agents["claude-code"]).
// There is no 'name' field - the key IS the name.
//
// Unlike other schemas, agents do NOT use UTD.
// They define command templates with placeholders for runtime substitution.
#Agent: {
	// Embed common fields (description, tags, origin)
	#Base

	// Command template (required, must not be empty).
	// Placeholders: {{.bin}}, {{.model}}, {{.prompt}}, {{.role}}, {{.role_file}},
	// {{.permission}}, {{.effort}}, {{.output}}, {{.resume}}, {{.print}}.
	// {{.model}} may be empty; optional --model flags use {{if .model}} (space inside the if).
	// {{.role}} / {{.role_file}} may be empty (--role none); optional role flags use {{if .role}} / {{if .role_file}}.
	// flags.print carries the prompt, and command then omits {{.prompt}}.
	// With no print fragment, command carries {{.prompt}}.
	command: string & !=""

	// Binary name for auto-detection and {{.bin}} placeholder
	bin?: string & !=""

	// Agentdex catalog id of the product this recipe launches.
	// Omit for custom or uncatalogued agents. When set, start resolves
	// bin and live models from agentdex at launch.
	agentdex?: string & =~"^[a-z0-9]+(-[a-z0-9]+)*$"

	// Model configuration
	default_model?: string
	models?: [string]: string & !=""

	// Optional flag table. start inserts each fragment with a leading space.
	// An empty word list accepts the value and inserts nothing. A missing key rejects the flag.
	// A word is a literal, or a whole word {{.prompt}} or {{.resume}}.
	flags?: {
		permission?: [string]: [...string]
		effort?: [string]: [...string]
		output?: [string]: [...string]
		print?: {
			off: [...string]
			on: [...string]
		}
		resume?: {
			latest: [...string]
			id: [...string]
		}
	}
}
