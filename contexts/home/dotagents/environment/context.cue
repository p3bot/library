package environment

import "github.com/p3bot/library/schemas@v1"

context: schemas.#Context & {
	required:    true
	default:     true
	description: "Local environment information including user, system, and tool context"
	tags: ["dotagents", "home", "environment", "system", "user"]
	file:   "~/.agents/environment.md"
	prompt: """
		Environment:

		{{if .datetime}}- DateTime: {{.datetime}}
		{{end -}}
		{{- if .user}}- User: {{.user}}
		{{end -}}
		{{- if .hostname}}- Hostname: {{.hostname}}
		{{end -}}
		{{- if .os_name}}- OS: {{.os_name}}
		{{end -}}
		{{- if .shell}}- Shell: {{.shell}}
		{{end -}}
		{{- if .cwd}}- CWD: {{.cwd}}
		{{end -}}
		{{- if .git_branch}}- Git Branch: {{.git_branch}}
		{{end -}}
		{{- if .git_root}}- Git Root: {{.git_root}}
		{{end}}
		Read the {{.file}} file for additional local environment context.
		"""
}
