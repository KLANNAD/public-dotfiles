#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
CLAUDE_SETTINGS="$CLAUDE_DIR/settings.json"

mkdir -p "$CLAUDE_DIR"

echo "Installing $CLAUDE_SETTINGS..."

cp -f "$DOTFILES_DIR/claude/settings.json" "$CLAUDE_SETTINGS"

echo "Installing custom commands to $CLAUDE_DIR/commands/..."

mkdir -p "$CLAUDE_DIR/commands"
cp -f "$DOTFILES_DIR/claude/commands/"*.md "$CLAUDE_DIR/commands/"

echo "Installing emit-turn-end.sh to ~/.local/bin/..."

mkdir -p "$HOME/.local/bin"
cp -f "$DOTFILES_DIR/emit-turn-end.sh" "$HOME/.local/bin/emit-turn-end.sh"
chmod +x "$HOME/.local/bin/emit-turn-end.sh"

echo "Done."
