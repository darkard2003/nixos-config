# AGENTS.md — Quick Reference

## Overview
Personal NixOS + Home Manager flake for user **`dark`** (arch: `x86_64-linux`). Two laptops running SwayFX under Wayland. Wallust-based dynamic theming, dotfiles as out-of-store symlinks (edit → immediate effect).

> **Agent rule:** Do **not** run any `nix` commands (`nix build`, `nix eval`, `nix flake check`, `nix develop`, `nixos-rebuild`, etc.) unless the user explicitly asks for that specific command. Editing files is fine; leave verification to the user unless requested.

## Hosts

| Host | Machine | Notes |
|------|---------|-------|
| `dark-think` | ThinkPad (AMD) | TLP (75/80 charge), bluetooth, 32-bit graphics |
| `dark-nix` | Intel desktop | Intel GPU (GUC), `thermald`, VA-API drivers |

Defined in `flake.nix`, built via `mkHost` which injects `{self, username, hostname, inputs, zen-browser}` as `specialArgs`.

## File Map

```
flake.nix                  # entry: nixosConfigurations, mkHost helper
configuration.nix          # shared NixOS → modules/system/*
home.nix                   # shared HM → modules/home/*

hosts/<host>/default.nix   # host-specific: TLP, Intel GPU, bluetooth, etc.
hosts/<host>/hardware-configuration.nix  # auto-generated, do not hand-edit

modules/system/
  boot.nix                 # bootloader, kernel params, lanzaboote, Secure Boot
  desktop.nix              # SwayFX system-wide (seatd, greetd, polkit, fontconfig)
  packages.nix             # system packages
  services.nix             # printing, avahi, syncthing, openssh, pipewire
  virt.nix                 # libvirtd
  zswap.nix                # zswap compression

modules/home/
  desktop.nix              # DM, theming, fonts, dotfile symlinks (xdg.configFile)
  sway.nix                 # SwayFX as home-manager module (configFile paths)
  packages.nix             # user packages
  programs.nix             # git, firefox, mpv, yazi, pipes
  services.nix             # swayidle, mako, playerctld, syncthing
  shell.nix                # zsh, starship, fzf, zoxide, utilities

dotfiles/                  # wired via mkOutOfStoreSymlink — edit live
  sway/                    #   autostart.conf, keybinds.conf, rules.conf, theme.conf
  waybar/                  #   config.jsonc, shared_modules.jsonc, style.css
  wallust/                 #   wallust.toml + templates/ (colors-kitty, -sway, -waybar.css, swaylock, tmux, wob)
  nvim/                    #   lua/plugins/*, lua/config/*
  kitty/ wofi/ wob/ swaylock/ swaync/

scripts/                   # ko, mirror, wallpaper, note, screenshot, wofi*, wob-runner
wallpapers/                # ~40 wallpapers (.jpg)
```

## Key Conventions

### Theme pipeline
Wallpaper → `wallust` reads → templates in `dotfiles/wallust/templates/` → kitty / sway / waybar / swaylock / tmux / wob. **Change wallust templates, not per-app configs.**

### Dotfiles
All major app configs are out-of-store symlinks. Edit `dotfiles/<app>/` directly and **restart the app** — no rebuild needed.

### Nix style
Formatting is handled by `nix fmt` (Alejandra-style, `.editorconfig`). `lib` imports follow standard patterns. Quote function args, use `...` for unused params.

### Pinning
`flake.lock` is committed and pinned. **Do not** run `nix flake update` without explicit instruction.

## Verification (dry-run only)

```bash
# Syntax / integrity
nix flake check --no-build

# Parser validation (no eval, no network)
nix-instantiate --eval --strict flake.nix -A nixosConfigurations.dark-think.config.system.build.toplevel.drvPath 2>/dev/null || true

# Dry build
nix build .#nixosConfigurations.dark-think.config.system.build.toplevel --dry-run
```

**Do not** run any `nix` command (including `nixos-rebuild switch`, `nix flake update`, `nix build`, `nix eval`, `nix flake check`) unless explicitly told to.

## Common Changes

| Task | Where |
|------|-------|
| Add system package | `modules/system/packages.nix` |
| Add user package | `modules/home/packages.nix` |
| Sway keybind | `dotfiles/sway/keybinds.conf` |
| Sway autostart / rule | `dotfiles/sway/autostart.conf` / `rules.conf` |
| Waybar modules / style | `dotfiles/waybar/config.jsonc` / `style.css` |
| Neovim plugin | `dotfiles/nvim/lua/plugins/` |
| Neovim config | `dotfiles/nvim/lua/config/` |
| Wallust template | `dotfiles/wallust/templates/` |
| Wallust palette map | `dotfiles/wallust/wallust.toml` |
| Host hardware | `hosts/<host>/default.nix` |
| New host | add entry in `flake.nix` + dir under `hosts/` |