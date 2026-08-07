{ config, pkgs, antigravity-nix, awww, ... }:

{
  home.packages = with pkgs; [
    kitty
    neovim
    zed-editor
    waybar
    wofi
    swaynotificationcenter
    btop
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
    wlsunset
    cliphist
    wob
    swaylock-effects
    kanshi
    playerctl
    brightnessctl
    pulseaudio
    thunar
    silicon
    fontconfig
    zoxide
    fastfetch

    # Utilities & Script dependencies
    bat
    bat-extras.batman
    bc
    jq
    imagemagick
    vimix-cursors

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
    python3
    python3Packages.pynvim
    tree-sitter
    fd
  ];
}
