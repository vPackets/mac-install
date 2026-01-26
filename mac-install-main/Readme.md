mac-setup
A complete macOS bootstrap and workstation setup for power users, developers, and network /
infrastructure engineers.
Overview
This setup configures macOS system defaults, installs Homebrew tooling, prepares a Python
virtual environment, and configures Oh My Zsh with productivity plugins and theme.
What This Setup Does
• Applies documented macOS defaults for Dock, Finder, keyboard, trackpad, screenshots, and
UX.
• Installs CLI tools and GUI apps via Homebrew and Brewfile.
• Creates an isolated Python virtual environment with latest dependencies.
• Configures Oh My Zsh with Maran theme and curated plugins.
Repository Structure
install.sh – main entry point
Brewfile – all brew and cask dependencies
requirements.txt – Python dependencies (latest releases)
scripts/ – modular setup scripts
Quick Start
chmod +x install.sh scripts/*.sh
./install.sh
Restart terminal or run: exec zsh -l
Install Order
1. macOS defaults
2. Homebrew installation
3. Brewfile packages
4. Python virtual environment
5. Oh My Zsh installation
6. Zsh configuration
7. Restart system services
macOS Defaults
All macOS defaults are located in scripts/00-macos-defaults.sh and are fully documented inline.
Optional toggles include Dock behavior, key repeat speed, quarantine prompts, and locale
settings.
Homebrew & Brewfile
All CLI tools and GUI applications are declared in Brewfile and installed using brew bundle.
The process is idempotent and safe to rerun.
Python Environment
A Python virtual environment is created in .venv/.
Dependencies are installed from requirements.txt without version pinning.
Activate using: source .venv/bin/activate
Zsh Configuration
Oh My Zsh is installed with the Maran theme.
Enabled plugins: git, zsh-autosuggestions, fast-syntax-highlighting, zsh-autocomplete.
The generated ~/.zshrc is backed up if it already exists.
Security Notes
Disabling Gatekeeper quarantine prompts reduces friction but also reduces protection. Use
consciously.
Troubleshooting
If Homebrew is not found, open a new terminal or re-evaluate brew shellenv.
If Python packages fail to build, install Xcode Command Line Tools and common libraries.
Philosophy
This setup favors explicit configuration, reproducibility, documentation, and minimal surprises.
It is meant to be read, audited, and extended — not blindly executed.