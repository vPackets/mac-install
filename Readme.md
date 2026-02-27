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






# Network Automation Python Toolbelt

This repo uses a "batteries included" Python stack for network automation:
- Connect to devices (SSH/NETCONF/SNMP/gNMI)
- Parse and structure outputs
- Orchestrate at scale (parallel runs, inventory)
- Integrate with Source of Truth (NetBox/Nautobot)
- Keep code quality high (format/lint/test/type-check)

> Tip: keep this as a toolbox. Not every project needs every dependency.
> You can later split into profiles (core / telemetry / netbox / cisco / lab).

---

## Dev workflow / quality

- **black**: opinionated code formatter.
- **ruff**: fast linter (catches common bugs + style issues).
- **pre-commit**: runs checks automatically before commits (format/lint/tests).
- **pytest**: unit/integration testing framework.
- **pytest-cov**: test coverage reporting for pytest.
- **mypy**: static type checking (helps build reliable automation systems).

Why it matters: you want to trust your automation before running it on real networks.

---

## Core utilities (data, UX, config)

- **requests**: simple HTTP client (lots of network vendors use REST APIs).
- **httpx**: modern HTTP client (sync + async; great for high concurrency).
- **rich**: beautiful terminal output, tables, progress bars, logs.
- **pyyaml**: parse/write YAML (inventory/configs).
- **ruamel.yaml**: YAML that can preserve formatting/comments (useful for config-style YAML files).
- **ujson**: faster JSON encode/decode (handy when parsing lots of telemetry/API payloads).
- **xmltodict**: quick XML -> dict conversion (NETCONF-ish situations).
- **python-dotenv**: load `.env` files for local dev (don’t hardcode creds/URLs).
- **pydantic**: validate and model data (turn messy device/API data into safe typed objects).
- **jmespath**: query/filter JSON-like objects (great for vendor API payloads).
- **tenacity**: retries with backoff/jitter (essential for flaky networks/APIs).
- **psutil**: system stats (CPU/mem, process control; useful in lab automation and diagnostics).

---

## CLI tooling

- **typer**: build clean CLIs quickly (commands, options, help output).
  Great for turning scripts into real tools: `netops audit`, `netops backup`, `netops deploy`.

---

## SSH / CLI automation & parsing

- **paramiko**: SSH library in Python (lower-level building block).
- **scp**: SCP support (copy files to/from devices/servers).
- **netmiko**: SSH automation tuned for network devices (vendors, prompts, config modes).
- **scrapli**: modern screen-scraping SSH library (fast, structured, pairs well with Nornir).
- **textfsm**: template-based parsing (CLI output -> structured data).
- **ntc-templates**: community-maintained TextFSM templates for many platforms.
- **ciscoconfparse**: parse and analyze network config files (especially Cisco-like configs).

Typical flow:
1) Collect CLI output with Netmiko/Scrapli
2) Parse to structured data with TextFSM/NTC templates (or your own)
3) Validate using Pydantic models
4) Compare desired vs current state and act

---

## Orchestration at scale

- **nornir**: run tasks across many devices in parallel (inventory-driven automation).
- **nornir-netmiko**: Nornir plugin to run Netmiko tasks.
- **nornir-scrapli**: Nornir plugin to run Scrapli tasks.
- **nornir-napalm**: Nornir plugin to run NAPALM tasks.

Why it matters: 1 device is a script; 100 devices is orchestration.

---

## Multi-vendor abstraction layer

- **napalm**: vendor-agnostic getters and config operations (where supported).
  Great for pulling facts, interfaces, BGP sessions, etc. across vendors.

---

## Source of Truth (SoT) / Inventory

- **pynetbox**: Python API client for NetBox.
- **nautobot**: Nautobot client/server ecosystem (SoT platform).
- **nornir-nautobot**: Nornir inventory plugin using Nautobot as SoT.

Why it matters: a SoT helps you answer "what should exist" vs "what exists now".

---

## NETCONF / YANG / models

- **ncclient**: NETCONF client library.
- **pyang**: YANG model tooling (validate, explore models, generate tree output).

Use when you want model-driven config/telemetry rather than CLI scraping.

---

## SNMP

- **pysnmp**: SNMP library.
Useful for legacy monitoring, quick checks, or environments where SNMP is still primary.

---

## gNMI / gRPC (modern telemetry & config)

- **grpcio**: core gRPC runtime.
- **protobuf**: protocol buffer support (data structures used by gRPC).
- **pygnmi**: gNMI client (OpenConfig telemetry/config pipelines).

This matters for streaming telemetry, OpenConfig, and modern network stacks.

---

## Cisco pyATS / Genie (Cisco ecosystem)

- **pyats**: Cisco test automation framework.
- **genie**: parsers/models built around pyATS (very powerful parsing and testing).

Best when you’re deeply in Cisco workflows or building robust test suites.

---

## Container / lab automation helpers

- **docker**: Docker SDK for Python.
Useful for lab orchestration, CI pipelines, container lifecycle automation.

---

## Packets and traffic tools

- **scapy**: craft packets, sniff, build simple test traffic, validate behaviors.
Helpful for troubleshooting and verification tests.

---

## BGP test speaker / route injection

- **exabgp**: BGP speaker in Python for route injection and testing.
Keep it only if you do BGP labs/testing pipelines.

---

# Suggested “profiles” (optional)
If you later want to slim down installs, you can split into:
- core (requests/httpx/rich/tenacity/pydantic)
- ssh (netmiko/scrapli/textfsm/ntc-templates)
- orchestration (nornir + plugins)
- sot (pynetbox/nautobot)
- model-driven (ncclient/pyang/pygnmi/grpcio/protobuf)
- cisco (pyats/genie)
- lab (docker/scapy/exabgp)

---

# Quick sanity install
```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -U pip
pip install -r requirements.txt

