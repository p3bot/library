package schemas

// #Role defines the schema for AI agent roles (system prompts).
// Roles define what the AI agent is and how it should behave.
//
// Note: Roles are identified by their map key (e.g., roles["code-reviewer"]).
// There is no 'name' field - the key IS the name.
//
// Roles use the UTD pattern to build the system prompt from
// static files, dynamic command output, and template text.
#Role: {
	// Embed common fields (description, tags, origin)
	#Base

	// Embed UTD pattern (file, command, prompt, shell, timeout)
	#UTD

	// Rank for automatic selection when no role is named by --role or a task.
	// A role with priority is a candidate, tried lowest number first, with ties
	// in config order; the first whose file exists is used. A role without
	// priority is never selected automatically. No candidate means no role.
	priority?: int & >=1
}
