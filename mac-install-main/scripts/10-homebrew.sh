#!/usr/bin/env bash
set -euo pipefail

log() { printf "\n\033[1m%s\033[0m\n" "$*"; }
warn() { printf "\n\033[33m%s\033[0m\n" "$*"; }

have_cmd() { command -v "$1" >/dev/null 2>&1; }

install_homebrew() {
  if have_cmd brew; then
    log "Homebrew already installed."
    return 0
  fi

  log "Installing Homebrew (official script)..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Initialize brew for this process
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  else
    warn "brew installed but not found in expected paths. Open a new shell and retry."
  fi

  # Persist brew shellenv (zsh default)
  local zprofile="$HOME/.zprofile"
  if [[ -x /opt/homebrew/bin/brew ]]; then
    grep -q 'eval "\(/opt/homebrew/bin/brew shellenv\)"' "$zprofile" 2>/dev/null || \
      echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$zprofile"
  elif [[ -x /usr/local/bin/brew ]]; then
    grep -q 'eval "\(/usr/local/bin/brew shellenv\)"' "$zprofile" 2>/dev/null || \
      echo 'eval "$(/usr/local/bin/brew shellenv)"' >> "$zprofile"
  fi
}

log "Homebrew"
install_homebrew

if have_cmd brew; then
  log "brew analytics off"
  brew analytics off >/dev/null 2>&1 || true

  log "brew update"
  brew update
fi

log "Homebrew step done ✅"