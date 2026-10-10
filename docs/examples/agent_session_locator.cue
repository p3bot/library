package schemas

// Unified against #Agent so cue vet rejects a locator the schema does not allow.
_locatorOK: #Agent & {
	command:         "echo {{.prompt}}"
	session_locator: ["session_id", "0"]
}
