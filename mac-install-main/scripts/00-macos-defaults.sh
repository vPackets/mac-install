#!/usr/bin/env bash
set -euo pipefail

###############################################################################
# macOS Defaults
#
# Applies system, Finder, Dock, keyboard, and UX preferences.
# Every defaults write is documented.
# Safari writes are best-effort to avoid sandbox errors on modern macOS.
###############################################################################

###############################################################################
# Toggles (edit as needed)
###############################################################################

# Disable Gatekeeper quarantine prompts for downloaded apps
# SECURITY TRADE-OFF: reduces warnings for untrusted apps
DISABLE_QUARANTINE_POPUP=true

# Prevent .DS_Store files on network shares
DISABLE_DSSTORE_ON_NETWORK=true

# Make Dock autohide appear instantly
DOCK_INSTANT_AUTOHIDE=true

# Speed up key repeat for terminal / editors
FAST_KEY_REPEAT=true

# Disable “natural” scrolling (set false to keep macOS default)
DISABLE_NATURAL_SCROLLING=false

# Reduce Spotlight indexing on external volumes
DISABLE_SPOTLIGHT_EXTERNAL_VOLUMES=true

# Finder search defaults to current folder instead of “This Mac”
FINDER_SEARCH_CURRENT_FOLDER=true

###############################################################################
# Helpers
###############################################################################

log() {
  printf "\n\033[1m%s\033[0m\n" "$*"
}

# Best-effort defaults write (used for sandboxed apps like Safari)
try_defaults_write() {
  local domain="$1"; shift
  if defaults write "$domain" "$@" 2>/dev/null; then
    return 0
  else
    echo "WARN: defaults write failed for '$domain' (sandbox/permissions). Skipping."
    return 0
  fi
}

###############################################################################
# Dock
###############################################################################
log "Dock"

# Dock: position Dock on the right side of the screen
defaults write com.apple.dock orientation -string "center"

# Dock: set icon size in pixels
defaults write com.apple.dock tilesize -int 36

# Dock: hide “Recent Applications”
defaults write com.apple.dock show-recents -bool false

# Dock: use “scale” effect when minimizing windows
defaults write com.apple.dock mineffect -string "scale"

# Dock: disable app launch animation
defaults write com.apple.dock launchanim -bool false

# Dock: enable spring loading for all items
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true

if [[ "$DOCK_INSTANT_AUTOHIDE" == "true" ]]; then
  # Dock: remove autohide delay
  defaults write com.apple.dock autohide-delay -float 0

  # Dock: speed up autohide animation
  defaults write com.apple.dock autohide-time-modifier -float 0
fi

###############################################################################
# Mission Control / Spaces
###############################################################################
log "Mission Control / Spaces"

# Prevent Spaces from reordering automatically
defaults write com.apple.dock mru-spaces -bool false

# Speed up Mission Control animation
defaults write com.apple.dock expose-animation-duration -float 0.1

###############################################################################
# Finder
###############################################################################
log "Finder"

# Add “Quit Finder” option to Finder menu
defaults write com.apple.finder QuitMenuItem -bool true

# Always show file extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show hidden files in Finder
defaults write com.apple.finder AppleShowAllFiles -bool true

# Disable warning when changing file extensions
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Save new documents locally instead of iCloud
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Remove toolbar title hover delay
defaults write NSGlobalDomain NSToolbarTitleViewRolloverDelay -float 0

# Disable Finder animations (including Info panel)
defaults write com.apple.finder DisableAllAnimations -bool true

# Show full POSIX path in Finder title bar