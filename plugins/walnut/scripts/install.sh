#!/bin/bash
# Walnut 1.0 — One-Command Installer
# curl -sSL https://alivecomputer.com/install | bash
#
# This is the last time you use the terminal like this.
# After this, your terminal becomes an alive computer.

set -euo pipefail

# ── Colors ───────────────────────────────────────────────
AMBER='\033[38;5;208m'
BOLD='\033[1m'
DIM='\033[2m'
GREEN='\033[32m'
RED='\033[31m'
RESET='\033[0m'

print_step() { printf "\n${AMBER}▸${RESET} ${BOLD}$1${RESET}\n"; }
print_ok() { printf "  ${GREEN}✓${RESET} $1\n"; }
print_skip() { printf "  ${DIM}· $1 (already installed)${RESET}\n"; }
print_fail() { printf "  ${RED}✗${RESET} $1\n"; }

# ── Welcome ──────────────────────────────────────────────
clear
printf "\n"
printf "  ${AMBER}${BOLD}ALIVE${RESET}\n"
printf "  ${DIM}Build Your World.${RESET}\n"
printf "\n"
printf "  This installs everything you need.\n"
printf "  Takes about 2 minutes. One time only.\n"
printf "\n"
printf "  After this, you never have to see this screen again.\n"
printf "  Your terminal becomes something else entirely.\n"
printf "\n"

read -p "  Ready? [enter] " -r

# ── Step 1: Homebrew (macOS only) ────────────────────────
if [[ "$OSTYPE" == "darwin"* ]]; then
  print_step "Checking Homebrew"
  if command -v brew &>/dev/null; then
    print_skip "Homebrew"
  else
    printf "  Installing Homebrew (package manager for macOS)...\n"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    print_ok "Homebrew installed"
  fi
fi

# ── Step 2: Node.js ─────────────────────────────────────
print_step "Checking Node.js"
if command -v node &>/dev/null; then
  NODE_VERSION=$(node -v)
  print_skip "Node.js $NODE_VERSION"
else
  printf "  Installing Node.js...\n"
  if command -v brew &>/dev/null; then
    brew install node
  elif command -v apt-get &>/dev/null; then
    sudo apt-get update && sudo apt-get install -y nodejs npm
  else
    print_fail "Can't install Node.js automatically. Install it from https://nodejs.org"
    exit 1
  fi
  print_ok "Node.js installed"
fi

# ── Step 3: Claude Code ─────────────────────────────────
print_step "Checking Claude Code"
if command -v claude &>/dev/null; then
  print_skip "Claude Code"
else
  printf "  Installing Claude Code...\n"
  npm install -g @anthropic-ai/claude-code
  print_ok "Claude Code installed"
fi

# ── Step 4: ALIVE Plugin ────────────────────────────────
print_step "Installing ALIVE"
if claude plugin list 2>/dev/null | grep -q "alive"; then
  print_skip "ALIVE plugin"
else
  claude plugin install alivecomputer/alive 2>/dev/null || {
    printf "  Installing from GitHub...\n"
    claude plugin install alivecomputer/alive
  }
  print_ok "ALIVE plugin installed"
fi

# ── Step 5: Create ALIVE Folder ─────────────────────────
print_step "Setting up your World"

# Default locations
if [[ "$OSTYPE" == "darwin"* ]]; then
  ICLOUD="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
  if [ -d "$ICLOUD" ]; then
    DEFAULT_PATH="$ICLOUD/alive"
    printf "  iCloud detected. Your World will sync across devices.\n"
  else
    DEFAULT_PATH="$HOME/alive"
  fi
else
  DEFAULT_PATH="$HOME/alive"
fi

printf "\n"
printf "  Where should your World live?\n"
printf "  ${DIM}Default: $DEFAULT_PATH${RESET}\n"
printf "\n"
read -p "  Path (or enter for default): " -r ALIVE_PATH
ALIVE_PATH="${ALIVE_PATH:-$DEFAULT_PATH}"

# Expand ~ if used
ALIVE_PATH="${ALIVE_PATH/#\~/$HOME}"

if [ -d "$ALIVE_PATH" ] && [ -f "$ALIVE_PATH/02_Life/now.md" -o -d "$ALIVE_PATH/02_Life" ]; then
  print_ok "World already exists at $ALIVE_PATH"
else
  mkdir -p "$ALIVE_PATH"
  print_ok "Created $ALIVE_PATH"
fi

# Create iCloud symlink if applicable
if [[ "$OSTYPE" == "darwin"* ]] && [[ "$ALIVE_PATH" == *"Mobile Documents"* ]]; then
  if [ ! -L "$HOME/icloud" ]; then
    ln -s "$HOME/Library/Mobile Documents/com~apple~CloudDocs" "$HOME/icloud"
    print_ok "Created ~/icloud shortcut"
  fi
fi

# ── Step 6: Statusline ──────────────────────────────────
print_step "Configuring statusline"

STATUSLINE_SRC="$(claude plugin list --json 2>/dev/null | jq -r '.[] | select(.name=="alive") | .path' 2>/dev/null)/scripts/statusline.sh"

if [ -f "$STATUSLINE_SRC" ]; then
  cp "$STATUSLINE_SRC" "$HOME/.claude/statusline-command.sh"
  chmod +x "$HOME/.claude/statusline-command.sh"
  print_ok "Statusline configured"
else
  print_skip "Statusline (configure manually after restart)"
fi

# ── Done ─────────────────────────────────────────────────
printf "\n"
printf "  ${AMBER}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"
printf "\n"
printf "  ${GREEN}${BOLD}Done.${RESET}\n"
printf "\n"
printf "  Your terminal just became an alive computer.\n"
printf "\n"
printf "  Launching your alive computer...\n"
printf "\n"

# Auto-launch Claude Code in the ALIVE folder
cd "$ALIVE_PATH"
if command -v claude &>/dev/null; then
  exec claude --prompt "/alive:home"
else
  # Fallback if claude isn't in PATH yet (fresh install, shell not reloaded)
  printf "  ${BOLD}Almost there. Run these two commands:${RESET}\n"
  printf "\n"
  printf "    ${DIM}cd $ALIVE_PATH && claude${RESET}\n"
  printf "    ${DIM}then type:${RESET} ${AMBER}/alive:home${RESET}\n"
  printf "\n"
  printf "  Your terminal just became an alive computer.\n"
  printf "  Welcome to your World.\n"
fi
printf "\n"
printf "  ${AMBER}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"
printf "\n"
