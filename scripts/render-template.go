package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"maps"
	"os"
	"os/exec"
	"os/user"
	"path/filepath"
	"runtime"
	"slices"
	"strings"
	"text/template"
	"text/template/parse"
	"time"
)

type module struct {
	Prompt  string `json:"prompt"`
	File    string `json:"file"`
	Command string `json:"command"`
}

func runCmd(name string, args ...string) string {
	out, err := exec.Command(name, args...).Output()
	if err != nil {
		return ""
	}
	return strings.TrimSpace(string(out))
}

func expandHome(path, home string) string {
	if strings.HasPrefix(path, "~/") {
		return home + path[1:]
	}
	return path
}

func osName() string {
	switch runtime.GOOS {
	case "darwin":
		return runCmd("sw_vers", "-productName")
	case "linux":
		data, err := os.ReadFile("/etc/os-release")
		if err != nil {
			return "Linux"
		}
		for _, line := range strings.Split(string(data), "\n") {
			if strings.HasPrefix(line, "NAME=") {
				return strings.Trim(strings.TrimPrefix(line, "NAME="), `"`)
			}
		}
	}
	return runtime.GOOS
}

func resolveFile(file, moduleDir, home string) string {
	if rest, ok := strings.CutPrefix(file, "@module/"); ok {
		return filepath.Join(moduleDir, rest)
	}
	return expandHome(file, home)
}

// templateSource returns the text start parses as a template: prompt, else file, else command output.
func templateSource(m module, filePath, commandOutput string, check bool) (string, error) {
	switch {
	case m.Prompt != "":
		return m.Prompt, nil
	case m.File != "":
		// A path outside the bundle resolves against the user's directory at runtime.
		if check && !strings.HasPrefix(m.File, "@module/") {
			return "", nil
		}
		b, err := os.ReadFile(filePath)
		return string(b), err
	case m.Command != "":
		return commandOutput, nil
	}
	return "", nil
}

// unknownFields lists the template's fields missing from known. start's missingkey=zero
// renders them as empty text, so parsing alone accepts them.
func unknownFields(tmpl *template.Template, known map[string]string) []string {
	unknown := map[string]bool{}
	var walk func(n parse.Node)
	branch := func(b parse.BranchNode) {
		walk(b.Pipe)
		walk(b.List)
		walk(b.ElseList)
	}
	walk = func(n parse.Node) {
		switch n := n.(type) {
		case *parse.ListNode:
			if n != nil {
				for _, c := range n.Nodes {
					walk(c)
				}
			}
		case *parse.ActionNode:
			walk(n.Pipe)
		case *parse.IfNode:
			branch(n.BranchNode)
		case *parse.RangeNode:
			branch(n.BranchNode)
		case *parse.WithNode:
			branch(n.BranchNode)
		case *parse.TemplateNode:
			walk(n.Pipe)
		case *parse.PipeNode:
			if n != nil {
				for _, c := range n.Cmds {
					walk(c)
				}
			}
		case *parse.CommandNode:
			for _, a := range n.Args {
				walk(a)
			}
		case *parse.ChainNode:
			walk(n.Node)
		case *parse.FieldNode:
			if _, ok := known[n.Ident[0]]; !ok {
				unknown[n.Ident[0]] = true
			}
		}
	}
	for _, t := range tmpl.Templates() {
		if t.Tree != nil {
			walk(t.Tree.Root)
		}
	}
	return slices.Sorted(maps.Keys(unknown))
}

func main() {
	check := flag.Bool("check", false, "parse the template without rendering it")
	flag.Parse()
	if flag.NArg() != 1 {
		fmt.Fprintf(os.Stderr, "Usage: %s [--check] <module-dir>\n", filepath.Base(os.Args[0]))
		os.Exit(1)
	}

	moduleDir := flag.Arg(0)

	// Find the CUE file
	var cueFile, moduleType string
	for _, t := range []string{"context", "task", "role", "agent"} {
		if _, err := os.Stat(filepath.Join(moduleDir, t+".cue")); err == nil {
			cueFile = t + ".cue"
			moduleType = t
			break
		}
	}
	if cueFile == "" {
		fmt.Fprintf(os.Stderr, "no recognised CUE file found in %s\n", moduleDir)
		os.Exit(1)
	}

	// Run cue export
	cmd := exec.Command("cue", "export", cueFile)
	cmd.Dir = moduleDir
	out, err := cmd.Output()
	if err != nil {
		fmt.Fprintf(os.Stderr, "cue export failed: %v\n", err)
		os.Exit(1)
	}

	// Parse export JSON
	var raw map[string]json.RawMessage
	if err := json.Unmarshal(out, &raw); err != nil {
		fmt.Fprintf(os.Stderr, "failed to parse export output: %v\n", err)
		os.Exit(1)
	}
	var m module
	if err := json.Unmarshal(raw[moduleType], &m); err != nil {
		fmt.Fprintf(os.Stderr, "failed to parse module fields: %v\n", err)
		os.Exit(1)
	}
	// An agent's command is a launch template for start, not a command to run here.
	if moduleType == "agent" {
		fmt.Println("(agent modules have no template)")
		return
	}

	// Gather system values
	u, _ := user.Current()
	home, username := "", ""
	if u != nil {
		home = u.HomeDir
		username = u.Username
	}
	filePath := resolveFile(m.File, moduleDir, home)

	commandOutput := ""
	if m.Command != "" && !*check {
		commandOutput = runCmd("sh", "-c", m.Command)
	}

	source, err := templateSource(m, filePath, commandOutput, *check)
	if err != nil {
		fmt.Fprintf(os.Stderr, "failed to read template: %v\n", err)
		os.Exit(1)
	}
	// Matches start's options, so a template this accepts also parses there.
	tmpl, err := template.New("prompt").Option("missingkey=zero").Parse(source)
	if err != nil {
		fmt.Fprintf(os.Stderr, "failed to parse template: %v\n", err)
		os.Exit(1)
	}

	hostname, _ := os.Hostname()
	cwd, _ := os.Getwd()

	fileContents := ""
	if filePath != "" {
		if b, err := os.ReadFile(filePath); err == nil {
			fileContents = string(b)
		}
	}

	data := map[string]string{
		"datetime":       time.Now().Format(time.RFC3339),
		"user":           username,
		"home":           home,
		"hostname":       hostname,
		"os":             runtime.GOOS,
		"os_name":        osName(),
		"shell":          filepath.Base(os.Getenv("SHELL")),
		"cwd":            cwd,
		"git_branch":     runCmd("git", "rev-parse", "--abbrev-ref", "HEAD"),
		"git_root":       runCmd("git", "rev-parse", "--show-toplevel"),
		"git_user":       runCmd("git", "config", "user.name"),
		"git_email":      runCmd("git", "config", "user.email"),
		"file":           filePath,
		"file_contents":  fileContents,
		"command":        m.Command,
		"command_output": commandOutput,
		"instructions":   "",
	}

	if *check {
		if unknown := unknownFields(tmpl, data); len(unknown) > 0 {
			fmt.Fprintf(os.Stderr, "unknown placeholders render as empty text: %s\n", strings.Join(unknown, ", "))
			os.Exit(1)
		}
		return
	}

	if err := tmpl.Execute(os.Stdout, data); err != nil {
		fmt.Fprintf(os.Stderr, "failed to render template: %v\n", err)
		os.Exit(1)
	}
	fmt.Println()
}
