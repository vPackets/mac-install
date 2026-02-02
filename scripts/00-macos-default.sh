#!/usr/bin/env bash
set -euo pipefail

###############################################################################
# Toggle options (edit these)
###############################################################################

# SECURITY TRADE-OFF: Disables “App downloaded from Internet” quarantine prompts.
# This reduces protection against untrusted apps.
DISABLE_QUARANTINE_POPUP=true

# Disable writing .DS_Store files on network shares (SMB/NFS).
DISABLE_DSSTORE_ON_NETWORK=true

# Dock: instant autohide (only matters if autohide is enabled)
DOCK_INSTANT_AUTOHIDE=false

# Typing: faster key repeat (great for terminal/editor)
FAST_KEY_REPEAT=true

# Scrolling: disable “natural” scrolling
DISABLE_NATURAL_SCROLLING=false

# Spotlight: reduce indexing on external volumes
DISABLE_SPOTLIGHT_EXTERNAL_VOLUMES=true

# Finder: default search scope to current folder
FINDER_SEARCH_CURRENT_FOLDER=true

# Locale/Timezone block from your original script (Europe/Amsterdam + metric/EUR)
# Recommend leaving false unless you really want to force those.
APPLY_LOCALE_TIMEZONE=false

###############################################################################
# Helpers
###############################################################################
log() { printf "\n\033[1m%s\033[0m\n" "$*"; }

sudo_keepalive() {
  if ! sudo -n true >/dev/null 2>&1; then
    log "Some settings need admin privileges. Prompting for sudo..."
  fi
  sudo -v
  ( while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done ) 2>/dev/null &
}

###############################################################################
# Dock
###############################################################################
log "Dock"

# Dock: move Dock to the right side of the screen.
# defaults write com.apple.dock orientation -string "right"

# Dock: set Dock icon size (pixels).
defaults write com.apple.dock tilesize -int 36

# Dock: hide "Recent Applications" section.
defaults write com.apple.dock show-recents -bool false

# Dock: use the "scale" minimize effect (instead of genie).
defaults write com.apple.dock mineffect -string "scale"

# Dock: disable the application launch animation.
defaults write com.apple.dock launchanim -bool false

# Dock: enable spring-loading actions for all Dock items (open-on-hover while dragging).
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true

if [[ "$DOCK_INSTANT_AUTOHIDE" == "true" ]]; then
  # Dock: remove delay before Dock appears when auto-hide is enabled.
  defaults write com.apple.dock autohide-delay -float 0

  # Dock: make Dock auto-hide animation effectively instant.
  defaults write com.apple.dock autohide-time-modifier -float 0
fi

###############################################################################
# Mission Control / Spaces
###############################################################################
log "Mission Control / Spaces"

# Mission Control: prevent Spaces from automatically reordering based on most recent use.
defaults write com.apple.dock mru-spaces -bool false

# Mission Control: speed up the Mission Control animation duration.
defaults write com.apple.dock expose-animation-duration -float 0.1

###############################################################################
# Finder
###############################################################################
log "Finder"

# Finder: show a "Quit Finder" menu item in Finder's menu bar.
defaults write com.apple.finder QuitMenuItem -bool true

# Global: always show file extensions (e.g., .txt, .yaml) in Finder and elsewhere.
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show hidden files (dotfiles) in Finder.
defaults write com.apple.finder AppleShowAllFiles -bool true

# Finder: disable warning prompt when changing a file extension.
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Global: save new documents to local disk by default (not iCloud).
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Global: remove hover delay when mousing over window title / toolbar title area.
defaults write NSGlobalDomain NSToolbarTitleViewRolloverDelay -float 0

# Finder: disable various Finder animations (including info panel animations).
defaults write com.apple.finder DisableAllAnimations -bool true

# Finder: show full POSIX path (e.g., /Users/nico/...) in the Finder title bar.
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Finder: keep folders on top when sorting by name.
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Finder: set default Finder view to List view.
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

if [[ "$FINDER_SEARCH_CURRENT_FOLDER" == "true" ]]; then
  # Finder: default search scope = current folder (instead of "This Mac").
  defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
fi

###############################################################################
# Menu bar clock
###############################################################################
log "Menu bar clock"

# Clock: set menu bar date/time format (example: "23 Jan 14:05").
defaults write com.apple.menuextra.clock DateFormat -string "\"d MMM HH:mm\""

###############################################################################
# Feedback Assistant
###############################################################################
log "Feedback Assistant"

# Feedback Assistant: disable auto-gathering large files when submitting feedback.
defaults write com.apple.appleseed.FeedbackAssistant Autogather -bool false

###############################################################################
# Gatekeeper / quarantine prompt (optional, trade-off)
###############################################################################
log "Security prompt behavior"

if [[ "$DISABLE_QUARANTINE_POPUP" == "true" ]]; then
  # LaunchServices: disable quarantine prompts for apps downloaded from the Internet.
  # SECURITY TRADE-OFF: reduces warnings for untrusted apps.
  defaults write com.apple.LaunchServices LSQuarantine -bool false
fi

###############################################################################
# Save/Print panels expanded by default
###############################################################################
log "Save/Print dialogs expanded"

# Global: expand the Save dialog by default (legacy key).
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

# Global: expand the Save dialog by default (newer key).
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Global: expand the Print dialog by default (legacy key).
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

# Global: expand the Print dialog by default (newer key).
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

###############################################################################
# Typing / Keyboard
###############################################################################
log "Typing / Keyboard"

# Global: enable press-and-hold to show accent menu (instead of always repeating keys).
defaults write -g ApplePressAndHoldEnabled -bool true

if [[ "$FAST_KEY_REPEAT" == "true" ]]; then
  # Global: reduce delay before key repeat starts.
  defaults write NSGlobalDomain InitialKeyRepeat -int 15

  # Global: speed up key repeat rate.
  defaults write NSGlobalDomain KeyRepeat -int 1
fi

# Global: enable full keyboard navigation (Tab can focus dialogs, buttons, etc.).
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Global: disable automatic capitalization.
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Global: disable smart dashes substitution.
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Global: disable automatic period substitution (double-space -> period).
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Global: disable smart quotes substitution.
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Global: disable automatic spelling correction.
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

###############################################################################
# Window management
###############################################################################
log "Window management"

# Global: allow dragging windows from anywhere by holding Ctrl+Cmd and dragging.
defaults write -g NSWindowShouldDragOnGesture -bool true

# Global: speed up Cocoa window resize animations.
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

###############################################################################
# Scrollbars
###############################################################################
log "Scrollbars"

# Global: always show scrollbars (instead of automatic/when scrolling).
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"


###############################################################################
# Printing
###############################################################################
log "Printing"

# Printing: automatically quit the printer app when the queue finishes.
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

###############################################################################
# Trackpad
###############################################################################
log "Trackpad"

# Trackpad: enable tap-to-click (Bluetooth multitouch trackpad).
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

# Trackpad: enable tap-to-click for current host (per-machine setting).
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Trackpad: enable tap-to-click globally for the user.
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

if [[ "$DISABLE_NATURAL_SCROLLING" == "true" ]]; then
  # Global: disable natural scrolling (makes scroll direction more like Windows/Linux).
  defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false
fi

###############################################################################
# Screenshots
###############################################################################
log "Screenshots"

# Screenshots: set screenshot file format (png).
defaults write com.apple.screencapture type -string "png"

# Screenshots: disable drop shadow around window screenshots.
defaults write com.apple.screencapture disable-shadow -bool true

###############################################################################
# .DS_Store on network shares (optional)
###############################################################################
log "Network share cleanliness"

if [[ "$DISABLE_DSSTORE_ON_NETWORK" == "true" ]]; then
  # DesktopServices: prevent creating .DS_Store files on network shares.
  defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
fi

###############################################################################
# Spotlight (optional)
###############################################################################
log "Spotlight"

if [[ "$DISABLE_SPOTLIGHT_EXTERNAL_VOLUMES" == "true" ]]; then
  # Spotlight: reduce indexing on external volumes.
  defaults write com.apple.Spotlight ExternalVolumes -bool true
fi

###############################################################################
# Locale / timezone (optional)
###############################################################################
if [[ "$APPLY_LOCALE_TIMEZONE" == "true" ]]; then
  log "Locale / Timezone (sudo required)"
  sudo_keepalive

  # Login window: show host info (hostname/IP/etc.) when clicking the clock at login screen.
  sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

  # Login window: show or hide input menu on login screen (false hides it).
  sudo defaults write /Library/Preferences/com.apple.loginwindow showInputMenu -bool false

  # Global: use centimeters for measurements.
  defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"

  # Global: enable metric units.
  defaults write NSGlobalDomain AppleMetricUnits -bool true

fi

###############################################################################
# Safari developer menu
###############################################################################
log "Safari developer menu"

# Safari: enable Develop menu in menu bar.
defaults write com.apple.Safari IncludeDevelopMenu -bool true

# Safari: enable WebKit developer extras.
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true

# Safari: enable WebKit2 developer extras for content pages.
defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true

log "macOS defaults applied ✅"