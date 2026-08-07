{ config, pkgs, antigravity-nix, awww, ... }:

{
  home.packages = with pkgs; [
    neovim
    zed-editor
    wofi
    ripgrep
    tmux
    grim
    slurp
    wl-clipboard
    libnotify
    (tesseract.override { enableLanguages = [ "eng" ]; })
    wtype
    xdg-user-dirs
    wl-mirror
    antigravity-nix.packages.${pkgs.system}.default
    antigravity-nix.packages.${pkgs.system}.google-antigravity-ide
    antigravity-nix.packages.${pkgs.system}.google-antigravity-cli
    awww.packages.${pkgs.system}.default
    wallust
    dex
    wob
    swaylock-effects
    playerctl
    brightnessctl
    pulseaudio
    thunar
    fastfetch
    pavucontrol

    # Utilities & Script dependencies
    bc
    jq
    imagemagick
    bluetui

    # Neovim & Mason runtime dependencies
    unzip
    gnutar
    gzip
    curl
    wget
    gcc
    gnumake
    cmake
    nodejs
    (python3.withPackages (ps: with ps; [
      pynvim
      pygobject3
      requests
    ]))
    tree-sitter
    fd
  ];
}
