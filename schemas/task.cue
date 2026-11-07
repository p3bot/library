package schemas

// #Task defines the schema for task workflows.
// Tasks are reusable workflows that combine roles, agents, and dynamic content.
//
// Note: Tasks are identified by their map key (e.g., tasks["code-review"]).
// There is no 'name' field - the key IS the name.
#Task: {
	// Embed common fields (description, tags, origin)
	#Base

	// Embed UTD pattern (file, command, prompt, shell, timeout)
	#UTD

	// References (not inline definitions)
	// role can be a string (runtime resolution) or #Role (CUE dependency)
	role?:  string | #Role
	agent?: string // Must exist in agents (validated at runtime)

	// Smallest roster the task needs. Absent means 1. start stores and
	// prints it and does not read it at launch.
	min_members?: int & >=1
}
