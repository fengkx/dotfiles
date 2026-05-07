#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="${1:-$HOME/dotfiles}"

if ! command -v mise >/dev/null 2>&1; then
  echo "mise is not installed. Please install mise first."
  exit 1
fi

mise trust "$DOTFILES_DIR/mise/config.toml"
mise install
eval "$(mise activate bash)"

if command -v uv >/dev/null 2>&1; then
  uv python list >/dev/null
fi
