#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BREWFILE="$ROOT_DIR/Brewfile"

log()  { printf "\n\033[1;34m==> %s\033[0m\n" "$*"; }
warn() { printf "\n\033[33mWARN: %s\033[0m\n" "$*"; }
err()  { printf "\n\033[31mERROR: %s\033[0m\n" "$*"; }

# Ensure brew is available
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

command -v brew >/dev/null 2>&1 || { err "brew not found. Run scripts/10-homebrew.sh first."; exit 1; }

log "Homebrew config"
brew --version
brew config

log "Brewfile: $BREWFILE"
log "Brewfile contents"
sed 's/^/  /' "$BREWFILE"

# Make curl/download behavior more chatty & resilient
export HOMEBREW_VERBOSE=1
export HOMEBREW_CASK_VERBOSE=1
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_CURL_RETRIES=5
export HOMEBREW_CURL_CONNECT_TIMEOUT=30
export HOMEBREW_CURL_MAX_TIME=0

log "brew analytics off"
brew analytics off || true

log "brew update"
brew update

log "Installing packages from Brewfile (bundle --verbose)"
set +e
brew bundle --file "$BREWFILE" --verbose
BUNDLE_RC=$?
set -e

if [[ $BUNDLE_RC -ne 0 ]]; then
  warn "brew bundle returned non-zero ($BUNDLE_RC). We'll continue and report what is still missing."

  log "Checking what's still missing (brew bundle check)"
  set +e
  brew bundle check --file "$BREWFILE"
  CHECK_RC=$?
  set -e

  if [[ $CHECK_RC -ne 0 ]]; then
    warn "Some items are still missing. Common causes: cask CDN download failures, blocked URLs, or discontinued apps."
    warn "Next step: rerun the missing casks manually (see below)."
  fi
else
  log "brew bundle completed successfully ✅"
fi

log "brew cleanup"
brew cleanup || true

log "Homebrew step done ✅"
