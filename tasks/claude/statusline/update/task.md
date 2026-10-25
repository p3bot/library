# Customise Claude Code Statusline

Interactively help the user customise their existing Claude Code statusline at `~/.claude/statusline.sh`.

## Prerequisites

The user must have:

- An existing `~/.claude/statusline.sh` (created earlier, for example via `tasks:claude/statusline/create`)
- `bash` and `jq` available
- A `~/.claude/settings.json` referencing the script under `statusLine`

If `~/.claude/statusline.sh` does not exist, stop and point the user at the `claude/statusline/create` task. Do not proceed.

## Process

Steps:

1. Confirm the script and settings exist
2. Read the current script and summarise it for the user
3. Offer customisation options
4. Apply the chosen changes
5. Verify and reload

## Step 1: Confirm Current State

Greet the user and confirm both files exist:

```bash
test -f "$HOME/.claude/statusline.sh" && echo "script: present"
jq -e '.statusLine.command' "$HOME/.claude/settings.json" >/dev/null 2>&1 && echo "settings: wired"
```

If either is missing, tell the user which one and recommend running `claude/statusline/create` first. Then stop.

Open with a short message such as:

> Hi — I can help you customise your Claude Code statusline. Let me read your current one and offer some options.

## Step 2: Read and Summarise the Current Script

Read `~/.claude/statusline.sh` in full and identify the active settings. Look for:

- The 200k orange/red thresholds (default `ORANGE_THRESHOLD=72`, `RED_THRESHOLD=88`)
- The 1M orange/red thresholds (default `90` / `100`)
- The 1M token budget the bar and `k left` are measured against (default `BUDGET=400000`)
- The 256-colour ANSI codes for `RED`, `ORANGE`, `WHITE` (defaults `196`, `208`, `231`)
- The headroom multiplier used for `k left` in 200k mode (default `* 88 / 100`)
- The `printf` format string at the bottom, which controls the layout

Tell the user, in one sentence per item, what the current statusline shows. Example:

> Right now it shows: directory in white, model with `(200k)` or `(1M)` tag, a 10-block bar plus percentage, and `Nk left`. Orange at 72%/red at 88% in 200k mode.

## Step 3: Offer Customisation Options

Present a short menu of common changes. Do not list every possible tweak — show these categories and ask which they want:

1. Colours — change the ANSI 256-colour codes for red, orange, or the directory white
2. Thresholds — change when the bar turns orange or red (200k mode, 1M mode, or both)
3. Capacity — change the `* 88 / 100` headroom multiplier in 200k mode, or the `BUDGET` in 1M mode
4. Layout — reorder, add, or remove segments in the `printf`
5. Add a segment — common asks include git branch, time, hostname, or a custom static label
6. Remove a segment — drop the directory, model tag, percentage, or `k left`
7. Something else — let the user describe it freely

Ask the user to pick one or more, then for each pick ask the specific follow-up (e.g., "What 256-colour code do you want for orange?" or "What percentage should trigger orange in 200k mode?").

For new segments, remind the user that the script receives a JSON object on stdin from Claude Code with at least:

- `.workspace.current_dir`
- `.model.display_name`
- `.context_window.used_percentage`
- `.context_window.context_window_size`

Any other field they want must be derivable from that input, from environment variables, or from a shell command they are willing to run on every render.

## Step 4: Apply the Changes

Make the smallest edit that achieves the user's request. Prefer targeted replacements over rewrites:

- Threshold or colour-code changes: edit the matching assignment line
- Layout changes: edit the final `printf` and its argument list together so they stay in sync
- New segments: add the data extraction near the existing `jq` block or as a new shell snippet, add a variable, then add a format specifier and argument to the `printf`

Before writing, show the user a diff or the new lines you intend to apply and get explicit confirmation. Then write the file.

Re-apply the executable bit afterwards:

```bash
chmod +x "$HOME/.claude/statusline.sh"
```

## Step 5: Verify and Reload

Run the script with a representative sample payload to confirm it still produces output and does not error:

```bash
echo '{"workspace":{"current_dir":"/tmp/demo"},"model":{"display_name":"Claude Opus 4.7"},"context_window":{"used_percentage":45,"context_window_size":200000}}' \
  | "$HOME/.claude/statusline.sh"
```

If the script errors or prints nothing, show the user the output and offer to revert. Keep a copy of the previous script in memory before editing so you can restore it on request.

Confirm `~/.claude/settings.json` still references the script — the path should not need to change, but check:

```bash
jq -e '.statusLine.command' "$HOME/.claude/settings.json"
```

Tell the user the change is in place and that they need to start a fresh Claude Code session (or run `/statusLine` if their version supports hot-reload) for the customised statusline to appear.

## Troubleshooting

- Script errors after edit: revert from the in-memory backup and ask the user what they actually wanted.
- New segment shows as empty: the data source returned nothing for that payload — try a real Claude Code session before assuming the edit is wrong.
- Colours look wrong: 256-colour codes range 0–255; check the user's terminal actually supports 256 colours (`tput colors` should report 256).
- User wants a full rewrite: it is fine to rewrite the whole script, but show it to them in full and get confirmation before writing.
