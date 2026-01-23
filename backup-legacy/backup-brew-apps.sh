#!/usr/bin/env bash
# mac-inventory.sh
# Collect Homebrew formulae/casks, MAS apps, and Applications folder apps.
# Output filenames include hostname + timestamp.

set -euo pipefail

# ---- SETTINGS ----
HOSTNAME="$(scutil --get ComputerName | tr ' ' '_' | tr -cd '[:alnum:]_')"  # e.g. "Nicos_MacBookPro"
TIMESTAMP="$(date -u +%Y-%m-%dT%H%M%SZ)"
OUT_DIR="${OUT_DIR:-inventory}"
DO_GIT_COMMIT="${DO_GIT_COMMIT:-1}"    # 1=git add/commit, 0=skip

mkdir -p "$OUT_DIR"

# ---- REQUIREMENTS ----
if ! command -v brew >/dev/null 2>&1; then
  echo "Error: Homebrew not found. Install from https://brew.sh and re-run." >&2
  exit 1
fi

HAS_MAS=0
if command -v mas >/dev/null 2>&1; then
  HAS_MAS=1
fi

# ---- HOMEBREW LISTS ----
echo "Collecting Homebrew packages…"
brew update >/dev/null || true

brew list --formula --versions | sort -f \
  > "${OUT_DIR}/brew-formulae_${HOSTNAME}_${TIMESTAMP}.txt"

brew list --cask --versions | sort -f \
  > "${OUT_DIR}/brew-casks_${HOSTNAME}_${TIMESTAMP}.txt"

brew bundle dump --all --describe --force \
  --file "${OUT_DIR}/Brewfile_${HOSTNAME}_${TIMESTAMP}"

# ---- MAS ----
if (( HAS_MAS )); then
  mas list | sort -k2,2 -f \
    > "${OUT_DIR}/mas-apps_${HOSTNAME}_${TIMESTAMP}.txt"
else
  echo "Skipping MAS list (mas not installed)."
fi

# ---- Applications ----
APPS_CSV="${OUT_DIR}/applications_${HOSTNAME}_${TIMESTAMP}.csv"
echo "name,version,path" > "$APPS_CSV"

list_apps_dir() {
  local dir="$1"
  [ -d "$dir" ] || return 0
  shopt -s nullglob
  for app in "$dir"/*.app; do
    ver="$(mdls -name kMDItemVersion -raw "$app" 2>/dev/null || true)"
    if [[ -z "${ver:-}" || "$ver" == "(null)" ]]; then
      ver="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' \
            "$app/Contents/Info.plist" 2>/dev/null || true)"
    fi
    name="$(basename "$app" .app)"
    esc_name="${name//\"/\"\"}"
    esc_ver="${ver//\"/\"\"}"
    esc_path="${app//\"/\"\"}"
    echo "\"$esc_name\",\"$esc_ver\",\"$esc_path\"" >> "$APPS_CSV"
  done
}

list_apps_dir "/Applications"
list_apps_dir "$HOME/Applications"

# ---- GIT COMMIT ----
if (( DO_GIT_COMMIT )); then
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    git add "$OUT_DIR"
    git commit -m "Inventory snapshot ${HOSTNAME} ${TIMESTAMP}"
  else
    echo "Not in a git repo; skipping commit."
  fi
fi

echo "Done. Files written to: $OUT_DIR/"
ls -1 "$OUT_DIR"