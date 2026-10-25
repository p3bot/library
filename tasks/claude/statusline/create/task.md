# Install Claude Code Statusline

Install a custom statusline script for Claude Code at `~/.claude/statusline.sh` and wire it into `~/.claude/settings.json`.

## Prerequisites

The user must have:

- Claude Code installed (with a `~/.claude/` directory)
- `bash`, `jq`, and a terminal that supports 256-colour ANSI escape sequences

## Process

Steps:

1. Verify prerequisites
2. Write the statusline script
3. Make the script executable
4. Wire the script into `~/.claude/settings.json`
5. Verify the configuration
6. Describe the statusline to the user

## Step 1: Verify Prerequisites

Check that `~/.claude/` exists. If it does not, ask the user to start Claude Code at least once before running this task, then stop.

Check that `jq` is on `PATH`. If not, ask the user to install `jq` (it is required at runtime by the script and again in step 4 to edit settings.json), then stop.

```bash
test -d "$HOME/.claude" || echo "Missing ~/.claude — start Claude Code first."
command -v jq >/dev/null || echo "Missing jq — install jq."
```

## Step 2: Write the Statusline Script

Write the following content verbatim to `~/.claude/statusline.sh`. Overwrite any existing file at that path; if one exists, mention the overwrite to the user first and proceed unless they object.

```bash
#!/usr/bin/env bash
input=$(cat)

IFS=$'\t' read -r DIR MODEL PCT WIN USED <<<"$(jq -r '
  (.context_window.used_percentage // 0) as $p |
  (.context_window.context_window_size // 200000) as $w |
  [
    (.workspace.current_dir // "?" | split("/") | .[-1]),
    (.model.display_name // "?"),
    ($p | floor),
    $w,
    ($p * $w / 100 | floor)
  ] | @tsv' <<<"$input")"

if (( WIN >= 1000000 )); then
  BUDGET=400000
  BAR_PCT=$(( USED * 100 / BUDGET ))
  (( BAR_PCT > 100 )) && BAR_PCT=100
  LEFT=$(( BUDGET - USED ))
  (( LEFT < 0 )) && LEFT=0
  ORANGE_THRESHOLD=90
  RED_THRESHOLD=100
  MODEL="${MODEL} (1M)"
else
  BAR_PCT=$PCT
  LEFT=$(( 200000 * 88 / 100 - USED ))
  ORANGE_THRESHOLD=72
  RED_THRESHOLD=88
  MODEL="${MODEL} (200k)"
fi

if   (( BAR_PCT >= 100 )); then FILLED=10
elif (( BAR_PCT < 0 ));   then FILLED=0
else                            FILLED=$(( BAR_PCT / 10 ))
fi
EMPTY=$((10 - FILLED))
BAR=""
for ((i=0; i<FILLED; i++)); do BAR+="█"; done
for ((i=0; i<EMPTY;  i++)); do BAR+="░"; done

RED=$'\033[38;5;196m'
ORANGE=$'\033[38;5;208m'
WHITE=$'\033[38;5;231m'
RESET=$'\033[0m'

if   (( BAR_PCT >= RED_THRESHOLD ));    then BAR_COLOR="$RED"
elif (( BAR_PCT >= ORANGE_THRESHOLD )); then BAR_COLOR="$ORANGE"
else                                         BAR_COLOR=""
fi

LEFT_K=$(( LEFT / 1000 ))

printf '%s%s%s | %s | %s%s %s%%%s | %s%sk left%s' \
  "${WHITE}" "${DIR}" "${RESET}" \
  "${MODEL}" \
  "${BAR_COLOR}" "${BAR}" "${BAR_PCT}" "${RESET}" \
  "${BAR_COLOR}" "${LEFT_K}" "${RESET}"
```

Use a heredoc so the contents are written exactly as shown, including the Unicode block characters:

```bash
cat > "$HOME/.claude/statusline.sh" <<'STATUSLINE_EOF'
<paste the script above, verbatim, between these markers>
STATUSLINE_EOF
```

## Step 3: Make the Script Executable

```bash
chmod +x "$HOME/.claude/statusline.sh"
```

## Step 4: Wire the Script into settings.json

Update `~/.claude/settings.json` so Claude Code runs the script. The settings object needs a top-level `statusLine` key:

```json
{
  "statusLine": {
    "type": "command",
    "command": "$HOME/.claude/statusline.sh"
  }
}
```

Use `jq` to merge this in without clobbering any other keys the user already has. If the file does not exist, create it with `{}` first.

```bash
SETTINGS="$HOME/.claude/settings.json"
[ -f "$SETTINGS" ] || echo '{}' > "$SETTINGS"
tmp=$(mktemp)
jq '.statusLine = {type: "command", command: "$HOME/.claude/statusline.sh"}' "$SETTINGS" > "$tmp" && mv "$tmp" "$SETTINGS"
```

Note: the `$HOME` in the command value is a literal string in the JSON; Claude Code expands it at runtime.

## Step 5: Verify the Configuration

Confirm the script is executable, the settings file parses, and `statusLine.command` points at the script:

```bash
test -x "$HOME/.claude/statusline.sh" && echo "script: ok"
jq -e '.statusLine.command' "$HOME/.claude/settings.json" >/dev/null && echo "settings: ok"
```

Both lines should print `ok`. If either fails, stop and report the error to the user.

## Step 6: Describe the Statusline

Tell the user what the new statusline shows and how to read it. Use this structure:

The statusline renders four segments separated by ` | `:

1. Current directory (basename only), in bright white
2. Model display name, suffixed with `(200k)` or `(1M)` to indicate which mode applies
3. A 10-cell block bar plus the used-context percentage
4. Remaining capacity in thousands of tokens, formatted as `Nk left`

Colour thresholds (`k left` shares the bar colour in both modes):

- 200k mode: bar turns orange at 72%, red at 88% of the context window
- 1M mode: bar turns orange at 90% (360k), red at 100% (400k) of a 400,000-token budget

In 1M mode the bar and `k left` are measured against the 400,000-token budget, not the full 1M window, and stop at 100% and 0k. In 200k mode `k left` is computed against 88% of 200,000 to leave headroom before auto-compaction.

Finish by reminding the user to start a fresh Claude Code session (or run `/statusLine` if their version supports hot-reload) so the new statusline takes effect.

## Troubleshooting

- The statusline does not appear: confirm `~/.claude/settings.json` has the `statusLine` block and restart Claude Code.
- Garbled characters: the terminal must support UTF-8 and 256-colour ANSI. Try a different terminal or set `LANG=en_US.UTF-8`.
- `jq: error`: install `jq` (`sudo pacman -S jq`, `brew install jq`, `apt install jq`).
- Bar always grey: the input JSON did not include `context_window.used_percentage`; this is normal at session start and resolves once the conversation has any tokens.
