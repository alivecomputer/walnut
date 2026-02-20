#!/bin/bash
# Walnut 1.0 — Statusline
# Shows: squirrel:ID | Model | ctx% | $cost | [Walnut name + health] | [catches] | [inputs]

input=$(cat)

BOLD="\033[1m"
DIM="\033[2m"
RESET="\033[0m"
AMBER="\033[38;5;208m"
GREEN="\033[32m"
YELLOW="\033[33m"
RED="\033[31m"
CYAN="\033[36m"

session_id=$(echo "$input" | jq -r '.session_id // ""')
model=$(echo "$input" | jq -r '.model.display_name // "Claude"')
dir=$(echo "$input" | jq -r '.workspace.current_dir // ""')
cost=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
context_size=$(echo "$input" | jq -r '.context_window.context_window_size // 200000')
usage=$(echo "$input" | jq -r '.context_window.current_usage // null')

model_short=$(echo "$model" | sed 's/Claude //' | sed 's/ (new)//')
squirrel_id=$(echo "$session_id" | cut -c1-8)

components=()

# 1. Squirrel ID
if [ -n "$squirrel_id" ]; then
  components+=("${AMBER}🐿${RESET}${DIM}:${RESET}${squirrel_id}")
fi

# 2. Model
components+=("${BOLD}${model_short}${RESET}")

# 3. Context %
if [ "$usage" != "null" ]; then
  input_tokens=$(echo "$usage" | jq -r '.input_tokens // 0')
  cache_creation=$(echo "$usage" | jq -r '.cache_creation_input_tokens // 0')
  cache_read=$(echo "$usage" | jq -r '.cache_read_input_tokens // 0')
  total_tokens=$((input_tokens + cache_creation + cache_read))
  percent=$((total_tokens * 100 / context_size))
  if [ "$percent" -ge 80 ]; then color="$RED"
  elif [ "$percent" -ge 60 ]; then color="$AMBER"
  elif [ "$percent" -ge 40 ]; then color="$YELLOW"
  else color="$GREEN"; fi
  components+=("${color}${percent}%${RESET}")
fi

# 4. Cost
if [ "$(echo "$cost > 0" | bc -l 2>/dev/null)" = "1" ]; then
  components+=("${DIM}\$$(printf '%.2f' "$cost")${RESET}")
fi

# --- ALIVE-specific ---

ALIVE_ROOT="${ALIVE_ROOT:-}"
if [ -z "$ALIVE_ROOT" ]; then
  if [ -d "$HOME/Desktop/alive" ]; then ALIVE_ROOT="$HOME/Desktop/alive"
  elif [ -d "$HOME/icloud/alive" ]; then ALIVE_ROOT="$HOME/icloud/alive"
  elif [ -d "$HOME/Library/Mobile Documents/com~apple~CloudDocs/alive" ]; then ALIVE_ROOT="$HOME/Library/Mobile Documents/com~apple~CloudDocs/alive"
  elif [ -d "$HOME/alive" ]; then ALIVE_ROOT="$HOME/alive"
  fi
fi

# 5. Current Walnut (detect by finding nearest now.md going up from cwd)
walnut_name=""
walnut_health=""
check_dir="$dir"
while [ "$check_dir" != "/" ] && [ "$check_dir" != "$HOME" ]; do
  if [ -f "$check_dir/now.md" ] && [ -f "$check_dir/log.md" ]; then
    walnut_name=$(basename "$check_dir")
    # Read health from now.md frontmatter
    walnut_health=$(grep "^health:" "$check_dir/now.md" 2>/dev/null | sed 's/health: *//')
    break
  fi
  check_dir=$(dirname "$check_dir")
done

if [ -n "$walnut_name" ]; then
  health_signal=""
  case "$walnut_health" in
    quiet) health_signal=" ${YELLOW}?${RESET}" ;;
    dormant) health_signal=" ${RED}~${RESET}" ;;
  esac
  components+=("${CYAN}${walnut_name}${RESET}${health_signal}")
elif [ -n "$ALIVE_ROOT" ] && [[ "$dir" == "$ALIVE_ROOT"* ]]; then
  components+=("${AMBER}ALIVE${RESET}")
fi

# 6. Catch count (unsigned squirrel files in current walnut)
if [ -n "$walnut_name" ] && [ -d "$check_dir/_squirrels" ]; then
  catch_count=$(grep -l "signed: false" "$check_dir"/_squirrels/squirrel:*.md 2>/dev/null | wc -l | tr -d ' ')
  if [ "$catch_count" -gt 0 ]; then
    components+=("${YELLOW}${catch_count}✱${RESET}")
  fi
fi

# 7. Inputs pending
if [ -n "$ALIVE_ROOT" ] && [ -d "$ALIVE_ROOT/03_Inputs" ]; then
  inputs_count=$(find "$ALIVE_ROOT/03_Inputs" -maxdepth 1 -type f -not -name ".*" -not -name "Icon*" 2>/dev/null | wc -l | tr -d ' ')
  if [ "$inputs_count" -gt 0 ]; then
    components+=("${DIM}${inputs_count}in${RESET}")
  fi
fi

# Join
output=""
for i in "${!components[@]}"; do
  if [ $i -eq 0 ]; then output="${components[$i]}"
  else output="${output} ${DIM}·${RESET} ${components[$i]}"; fi
done

printf "%b" "$output"
