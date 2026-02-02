#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$ROOT_DIR/scripts"

echo "==> mac-setup: starting"
echo "Root: $ROOT_DIR"

chmod +x "$SCRIPTS_DIR"/*.sh || true

# Order:
# 1) macOS defaults
# 2) Homebrew install/init
# 3) Brew bundle (CLI + GUI apps)
# 4) Python venv + pip requirements (latest)
# 5) Restart services (Dock/Finder/SystemUIServer)

bash "$SCRIPTS_DIR/00-macos-default.sh"
bash "$SCRIPTS_DIR/10-homebrew.sh"
bash "$SCRIPTS_DIR/20-brew-bundle.sh"
bash "$SCRIPTS_DIR/30-python-env.sh"
bash "$SCRIPTS_DIR/40-ohmyzsh.sh"
bash "$SCRIPTS_DIR/41-zsh-config.sh"
bash "$SCRIPTS_DIR/99-restart-services.sh"

echo "==> mac-setup: done ✅"
echo "Tip: some settings may require logout/restart to fully take effect."
