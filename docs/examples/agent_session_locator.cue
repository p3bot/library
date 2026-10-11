package schemas

// "0" is a key whose spelling is a digit, not an array index.
_locatorOK: #Agent & {
	command:         "echo {{.prompt}}"
	session_locator: ["session_id", "0"]
}
