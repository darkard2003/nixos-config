# NixOS Configuration Flake

Personal NixOS and Home Manager configuration managed via Nix Flakes for multi-host desktop environments running **Sway WM**.

---

## 🖥 System Summary

| Hostname | Role / Machine | Graphics / Hardware | Window Manager |
| :--- | :--- | :--- | :--- |
| **`dark-think`** | ThinkPad Laptop | AMD / TLP Battery Profiles | SwayFX (Wayland) |
| **`dark-nix`** | Intel Machine | Intel GPU / Media Driver | SwayFX (Wayland) |

---

## 📁 Repository Structure

```text
.
├── flake.nix                  # Flake entry point (NixOS + Home Manager)
├── flake.lock                 # Locked input dependencies
├── configuration.nix          # Shared system-level NixOS coordinator
├── home.nix                   # Shared Home Manager user coordinator
├── hosts/                     # Per-host modular configurations
│   ├── dark-think/            # ThinkPad host config & hardware scan
│   │   ├── default.nix
│   │   └── hardware-configuration.nix
│   └── dark-nix/              # Intel host config & hardware scan
│       ├── default.nix
│       └── hardware-configuration.nix
├── modules/
│   ├── system/                # System-level modules (boot, desktop, packages, services, virt, zswap)
│   └── home/                  # Home Manager modules (desktop, packages, programs, services, shell, sway)
├── dotfiles/                  # User application configurations (managed via out-of-store symlinks)
│   ├── kitty/                 # Kitty terminal config
│   ├── nvim/                  # Neovim lua config
│   ├── sway/                  # Modular Sway WM configuration
│   ├── swaylock/              # Swaylock screen locker configuration
│   ├── swaync/                # Sway Notification Center configuration
│   ├── wallust/               # Dynamic color palette generator & templates
│   ├── waybar/                # Waybar status bar config, styles, & scripts
│   ├── wob/                   # Overlay volume/brightness bar config
│   └── wofi/                  # Wofi application launcher config
├── scripts/                   # Desktop workflow scripts (wallpaper, screenshot, notes, wofi-emoji, wob-runner)
└── wallpapers/                # Wallpaper collection
```

---

## 🛠 Features & Installed Software

* **Desktop Environment**: SwayFX with modular configuration split across keybindings, decoration, rules, variables, and display settings.
* **Theming**: Dynamic color extraction and multi-app theming via Wallust.
* **Audio**: PipeWire with PulseAudio compatibility.
* **Power Management**: TLP power profiles & battery charge thresholds on ThinkPad.
* **Fonts**: Font Awesome and JetBrains Mono Nerd Font.
* **User Tools**: `btop`, `ripgrep`, `tmux`, `git`, `kitty`, `grim`, `slurp`, `wl-clipboard`, `neovim`, `nixd`, `nil`.

---

## 🚀 Management & Commands

### Rebuild Configuration
To apply and build system changes using this flake on your active machine:
```bash
sudo nixos-rebuild switch --flake ~/nixos-config#$(hostname)
```

### Dry Run (Test Build)
To test for build or syntax errors without applying changes:
```bash
nix build ~/nixos-config#nixosConfigurations.$(hostname).config.system.build.toplevel --dry-run
```

### Update Flake Inputs
To update `nixpkgs` and other flake inputs:
```bash
nix flake update
```

### Validate Flake Syntax
```bash
nix flake check --no-build
```
