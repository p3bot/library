package schemas

// #Skill defines the schema for skill modules.
// Skills are Agent Skills (agentskills.io): a SKILL.md plus optional
// resources, published for start to materialise onto disk.
//
// Unlike roles, contexts, and tasks, skills do not embed #UTD.
// There is no prompt to render; start distributes the file bundle.
//
// Note: Skills are identified by their map key (e.g., skills["finding/one-by-one"]).
// There is no 'name' field - the key IS the name.
#Skill: {
	#Base

	// Standard entry pointer. Not a user-config default.
	file: string | *"@module/SKILL.md"
}
