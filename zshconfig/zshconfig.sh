#!/bin/bash

# --- 1. INSTALL REQUIRED PACKAGES (Arch Linux Specific) ---
echo "Checking for required packages on Arch Linux..."
packages_to_install=""
# Added zoxide to the list of packages to check
for pkg in zsh git curl zoxide; do
  # Use pacman's query command '-Q' to check if a package is installed
  if ! pacman -Q "$pkg" > /dev/null 2>&1; then
    packages_to_install+="$pkg "
  fi
done

if [ -n "$packages_to_install" ]; then
  echo "Installing missing packages: $packages_to_install"
  # Use pacman to install all missing packages at once
  sudo pacman -S --noconfirm $packages_to_install
else
  echo "Core packages are already installed."
fi


# --- 2. INSTALL ZSH PLUGINS ---
echo "Checking for Zsh plugins..."
PLUGINS_DIR="$HOME/.zsh/plugins"
mkdir -p "$PLUGINS_DIR" # Ensure the plugin directory exists

declare -A plugins=(
  ["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions"
  ["fast-syntax-highlighting"]="https://github.com/zdharma-continuum/fast-syntax-highlighting"
  ["zsh-autocomplete"]="https://github.com/marlonrichert/zsh-autocomplete.git"
)

# The "${!plugins[@]}" syntax correctly creates a list of the keys from the map (the plugin names).
# This is the standard way to iterate over an associative array in Bash.
for plugin in "${!plugins[@]}"; do
  if [ ! -d "$PLUGINS_DIR/$plugin" ]; then
    echo "Installing $plugin..."
    # The URL is retrieved using the key: "${plugins[$plugin]}"
    git clone --depth=1 "${plugins[$plugin]}" "$PLUGINS_DIR/$plugin"
  else
    echo "$plugin is already installed."
  fi
done


# --- 3. CONFIGURE ZSHRC ---
# This part assumes a file named '.zshrc' is in the same directory as this script
ZSHRC_SOURCE="./.zshrc"

if [ ! -f "$ZSHRC_SOURCE" ]; then
    echo "ERROR: The source .zshrc file was not found at $ZSHRC_SOURCE."
    echo "Please run this script from the same directory as your dotfiles."
    exit 1
fi

if [ -f "$HOME/.zshrc" ]; then
  echo "Backing up existing .zshrc..."
  mv "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
fi

echo "Copying new .zshrc configuration..."
cp "$ZSHRC_SOURCE" "$HOME/.zshrc"

echo ""
echo "Setup completed successfully!"
echo "Please restart your terminal or run 'source ~/.zshrc' to see the changes."

