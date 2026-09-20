# NixOS Configuration Flake

Personal NixOS and Home Manager configuration managed via Nix Flakes for two laptops
running **SwayFX** on Wayland, with dynamic Wallust-based theming.

See [`AGENTS.md`](./AGENTS.md) for a quick file map and conventions.

---

## 🖥 System Summary

| Hostname | Role / Machine | Graphics / Power | Window Manager |
| :--- | :--- | :--- | :--- |
| **`dark-think`** | ThinkPad Laptop | AMD, TLP (75/80 charge), Bluetooth, 32-bit graphics | SwayFX (Wayland) |
| **`dark-nix`** | Intel Desktop | Intel GPU (GUC), `thermald`, VA-API drivers | SwayFX (Wayland) |

---

## 🚀 Quick Start

Requires a Nix installation with **flakes enabled**.

```bash
git clone <repo-url> ~/nixos-config
cd ~/nixos-config
sudo nixos-rebuild switch --flake .#dark-think   # or .#dark-nix
```

Known flake hosts: `dark-think`, `dark-nix` (the hostname must match the attribute).

---

## 📁 Repository Structure

```text
.
├── flake.nix                  # Flake entry point (NixOS + Home Manager)
├── flake.lock                 # Locked input dependencies (pinned — see note below)
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
│   ├── system/                # boot, desktop, packages, services, virt, zswap
│   └── home/                  # desktop, packages, programs, services, shell, sway
├── dotfiles/                  # User app configs (out-of-store symlinks — edit live)
│   ├── kitty/                 # Kitty terminal config
│   ├── nvim/                  # Neovim config (lua/config, lua/plugins)
│   ├── sway/                  # Modular SwayFX config
│   ├── swaylock/              # Screen locker configuration
│   ├── swaync/                # Sway Notification Center configuration
│   ├── wallust/               # Dynamic color generator + templates/
│   ├── waybar/                # Status bar config, styles, & scripts
│   ├── wob/                   # Overlay volume/brightness bar config
│   └── wofi/                  # Application launcher config
├── scripts/                   # calc.sh, ko, mirror, note, screenshot, wallpaper,
│                              # wob-runner, wofi, wofi-emoji, wofi_wal
└── wallpapers/                # Wallpaper collection (~35 images)
```

---

## 🛠 Features & Installed Software

* **Desktop Environment**: SwayFX with modular configuration split across keybindings,
  decoration, rules, variables, and display settings.
* **Theming**: Dynamic color extraction and multi-app theming via Wallust.
* **Audio**: PipeWire with PulseAudio compatibility.
* **Power Management**: TLP power profiles & battery charge thresholds on the ThinkPad;
  `thermald` and VA-API drivers on the Intel host.
* **Security / Boot**: Secure Boot via lanzaboote, `zswap` compression.
* **Virtualization**: `libvirtd`.
* **Services**: Syncthing, printing (CUPS), Avahi, OpenSSH.
* **Fonts**: Font Awesome and JetBrains Mono Nerd Font.
* **User Tools**: `btop`, `ripgrep`, `tmux`, `git`, `kitty`, `grim`, `slurp`,
  `wl-clipboard`, `neovim`, `nixd`, `nil`, `yazi`, `starship`, `zoxide`, `fzf`,
  `mako`, `swayidle`, `playerctld`, and Zen Browser.

---

## 🎨 Theming

Wallpaper → `wallust` → templates (`dotfiles/wallust/templates/`) → kitty, sway,
waybar, swaylock, tmux, wob.

To change colors across apps, edit the **templates** — not each app's config.

Dotfiles are wired with `mkOutOfStoreSymlink`, so editing `dotfiles/<app>/` takes
effect immediately after restarting the app — **no rebuild required**.

---

## 🚀 Management & Commands

### Rebuild Configuration
```bash
sudo nixos-rebuild switch --flake ~/nixos-config#$(hostname)
```

### Dry Run (Test Build)
```bash
nix build ~/nixos-config#nixosConfigurations.$(hostname).config.system.build.toplevel --dry-run
```

### Validate Flake Syntax
```bash
nix flake check --no-build
```

### Update Flake Inputs
```bash
nix flake update
```

> ⚠️ `flake.lock` is committed and intentionally pinned. Avoid `nix flake update`
> unless you actually intend to bump inputs.

---

## 📄 License

No license has been specified for this repository. It is personal configuration
provided as-is; add a license if you intend to reuse it.
