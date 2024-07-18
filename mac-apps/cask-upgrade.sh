#!/bin/bash


brew update

brew upgrade

# List all installed casks
installed_casks=$(brew list --cask)

# Loop through each cask
for cask in $installed_casks; do
    # Check if the cask is "Royal-TSX" or "Wireshark"
    if [[ "$cask" != "Royal-TSX" && "$cask" != "Wireshark" ]]; then
        # Upgrade the cask
        brew upgrade --cask "$cask"
    else
        echo "Skipping upgrade for $cask"
    fi
done
