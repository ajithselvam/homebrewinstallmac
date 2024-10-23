#!/bin/bash

# Install Xcode Command Line Tools silently
xcode-select --install 2>/dev/null

# Wait for the installation to complete
until xcode-select --print-path &>/dev/null; do
    sleep 5
done

# Install Homebrew using CI mode
CI=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Check if the system is Apple Silicon (ARM) or Intel
ARCH=$(uname -m)

if [ "$ARCH" = "arm64" ]; then
    # For Apple Silicon
    /opt/homebrew/bin/brew shellenv >> ~/.zprofile
    source ~/.zprofile
elif [ "$ARCH" = "x86_64" ]; then
    # For Intel
    /usr/local/bin/brew shellenv >> ~/.zprofile
    source ~/.zprofile
fi

# Verify Homebrew installation
if command -v brew &>/dev/null; then
    echo "Homebrew installation successful."
else
    echo "Homebrew installation failed."
    exit 1
fi
