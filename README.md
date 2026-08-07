# NixOS Configuration Flake

Personal NixOS and Home Manager configuration managed via Nix Flakes for desktop environment setup running **Sway WM**.

---

## 🖥 System Summary

| Parameter | Value |
| --- | --- |
| **Hostname** | `dark-nix` |
| **User** | `dark` |
| **Architecture** | `x86_64-linux` |
| **NixOS Release** | `26.05` |
| **Window Manager** | Sway (Wayland) |
| **Display Manager** | Ly |
| **Terminal** | Kitty |
| **Bar / Launcher** | Waybar & Wofi |

---

## 📁 Repository Structure

```text
.
├── flake.nix                  # Flake entry point (NixOS + Home Manager)
├── flake.lock                 # Locked input dependencies
├── configuration.nix          # System-level NixOS configuration
├── hardware-configuration.nix # Hardware & filesystem specification
├── home.nix                   # Home Manager user configuration
├── kitty/                     # Kitty terminal configuration
├── scripts/                   # Custom shell scripts (wallpaper, screenshot, notes, wofi-emoji)
├── sway/                      # Modular Sway window manager configuration
├── swaylock/                  # Swaylock screen locker configuration
├── swaync/                    # Sway Notification Center configuration
├── wallpapers/                # Wallpaper collection
├── waybar/                    # Waybar status bar config, styles, & scripts
├── wofi/                      # Wofi launcher configuration
└── zshconfig/                 # Zsh shell configuration files
```

---

## 🛠 Features & Installed Software

* **Desktop Environment**: Sway with modular configuration split across keybindings, decoration, rules, variables, and display settings.
* **Audio**: PipeWire with PulseAudio compatibility.
* **Fonts**: Font Awesome and JetBrains Mono Nerd Font.
* **User Tools**: `btop`, `ripgrep`, `tmux`, `git`, `kitty`, `grim`, `slurp`, `wl-clipboard`, `neovim`, `nixd`, `nil`.

---

## 🚀 Management & Commands

### Rebuild Configuration
To apply and build system changes using this flake:
```bash
sudo nixos-rebuild switch --flake .#dark-nix
```

### Dry Run (Test Build)
To test for build or syntax errors without applying changes:
```bash
nixos-rebuild dry-build --flake .#dark-nix
```

### Update Flake Inputs
To update `nixpkgs` and `home-manager` flake lock dependencies:
```bash
nix flake update
```

### Validate Flake Syntax
```bash
nix flake check
```
