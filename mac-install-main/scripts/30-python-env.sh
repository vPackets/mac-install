#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REQ_FILE="$ROOT_DIR/requirements.txt"
VENV_DIR="$ROOT_DIR/.venv"

log() { printf "\n\033[1m%s\033[0m\n" "$*"; }

# Prefer brew python if available, otherwise fall back to system python3
if [[ -x /opt/homebrew/bin/python3 ]]; then
  PY="/opt/homebrew/bin/python3"
elif [[ -x /usr/local/bin/python3 ]]; then
  PY="/usr/local/bin/python3"
else
  PY="$(command -v python3 || true)"
fi

if [[ -z "${PY:-}" ]]; then
  echo "python3 not found. Install Python (brew install python@3.12) then rerun."
  exit 1
fi

if [[ ! -f "$REQ_FILE" ]]; then
  echo "requirements.txt not found at: $REQ_FILE"
  exit 1
fi

log "Python venv"
echo "Using python: $PY"
"$PY" -m venv "$VENV_DIR"

# shellcheck disable=SC1091
source "$VENV_DIR/bin/activate"

log "Upgrading pip tooling"
python -m pip install --upgrade pip setuptools wheel

log "Installing Python requirements (latest available versions)"
pip install -r "$REQ_FILE"

log "Python environment ready ✅"
echo "To activate later:"
echo "  source \"$VENV_DIR/bin/activate\""