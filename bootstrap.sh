#!/usr/bin/env bash
# Bootstrap your Claude Code config onto a machine.
#
# After clicking "Use this template" on GitHub you have your OWN copy of this repo.
# Run this to install it as ~/.claude. Pass your repo URL as the first argument,
# or set CLAUDE_CONFIG_REPO:
#
#   bash bootstrap.sh https://github.com/YOU/your-claude-config.git
#
# Idempotent and non-destructive: existing ~/.claude content is backed up, never
# deleted. Safe to re-run to pull updates.
set -euo pipefail

REPO="${1:-${CLAUDE_CONFIG_REPO:-}}"
CLAUDE_DIR="$HOME/.claude"
STAMP="$(date +%Y%m%d-%H%M%S)"

say()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33mWARN\033[0m %s\n' "$*"; }

if [ -z "$REPO" ]; then
  warn "No repo URL given. Usage: bash bootstrap.sh https://github.com/YOU/your-claude-config.git"
  warn "(or export CLAUDE_CONFIG_REPO first)."
  exit 1
fi

# --- 1. Prerequisites -------------------------------------------------------
say "Checking prerequisites"
missing=0
for bin in git jq node; do
  command -v "$bin" >/dev/null 2>&1 || { warn "$bin is not installed — required."; missing=1; }
done
command -v gh >/dev/null 2>&1 || warn "gh (GitHub CLI) not found — only needed if your repo is private."
if [ "$missing" -eq 1 ]; then
  warn "Install the missing tools above, then re-run. (macOS: 'brew install git jq node')"
  exit 1
fi

# --- 2. Clone or update ~/.claude -------------------------------------------
if [ -d "$CLAUDE_DIR/.git" ]; then
  say "\$HOME/.claude is already a git repo — pulling latest"
  git -C "$CLAUDE_DIR" pull --ff-only
elif [ -d "$CLAUDE_DIR" ]; then
  say "Found existing \$HOME/.claude (from Claude Code) — adopting it into the repo"
  cd "$CLAUDE_DIR"
  git init -b main --quiet
  git remote add origin "$REPO"
  git fetch origin --quiet
  mkdir -p "$CLAUDE_DIR/backups/bootstrap-$STAMP"
  while IFS= read -r f; do
    if [ -e "$f" ]; then
      mkdir -p "$CLAUDE_DIR/backups/bootstrap-$STAMP/$(dirname "$f")"
      cp -R "$f" "$CLAUDE_DIR/backups/bootstrap-$STAMP/$f"
    fi
  done < <(git ls-tree -r origin/main --name-only)
  git checkout -f origin/main -- .
  git branch --set-upstream-to=origin/main main --quiet 2>/dev/null || true
  git reset --soft origin/main --quiet 2>/dev/null || true
  say "Pre-existing files backed up to backups/bootstrap-$STAMP/"
else
  say "Cloning fresh into \$HOME/.claude"
  git clone "$REPO" "$CLAUDE_DIR"
fi

# --- 3. Cross-tool skill sharing (optional) ---------------------------------
if [ -d "$CLAUDE_DIR/skills" ]; then
  say "Linking \$HOME/.agents/skills -> \$HOME/.claude/skills"
  mkdir -p "$HOME/.agents/skills"
  linked=0
  for d in "$CLAUDE_DIR"/skills/*/; do
    [ -d "$d" ] || continue
    name="$(basename "$d")"
    [ -e "$HOME/.agents/skills/$name" ] || { ln -s "$CLAUDE_DIR/skills/$name" "$HOME/.agents/skills/$name"; linked=$((linked + 1)); }
  done
  say "Linked $linked new skill(s)"
fi

# --- 4. Next steps ----------------------------------------------------------
echo ""
say "Done. Next:"
warn "Edit \$HOME/.claude/AGENTS.md and replace every {{PLACEHOLDER}} with your details."
warn "Hooks in settings.json need 'jq' (checked) and use 'prettier' when present — harmless if absent."
warn "If you enable the CI review workflow, add a CLAUDE_CODE_OAUTH_TOKEN or ANTHROPIC_API_KEY secret to each repo (see README)."
say "Start a new Claude Code session to pick everything up."
