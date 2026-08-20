package schemas

// #SkillInstall is one start skills.cue inventory entry.
// Distinct from #Skill, the published library module type.
// Dest paths are not recorded; disk plus agentdex is where files live.
#SkillInstall: {
	// CUE module path of the installed skill.
	origin: string & !=""

	// Published version of the installed skill.
	version: string & !=""
}
