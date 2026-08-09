{
  config,
  pkgs,
  antigravity-nix,
  awww,
  ...
}:

let
  system = pkgs.stdenv.hostPlatform.system;
in
{
  home.packages = with pkgs; [
    sequoia-chameleon-gnupg
    zed-editor
    wofi
    ripgrep
    grim
    slurp
    wl-clipboard
    libnotify
    (tesseract.override { enableLanguages = [ "eng" ]; })
    wtype
    xdg-user-dirs
    wl-mirror
    antigravity-nix.packages.${system}.default
    antigravity-nix.packages.${system}.google-antigravity-ide
    antigravity-nix.packages.${system}.google-antigravity-cli
    awww.packages.${system}.default
    wallust
    dex
    wob
    swaylock-effects
    playerctl
    brightnessctl
    pulseaudio
    fastfetch
    pavucontrol
    remmina
    dbeaver-bin
    rustdesk-flutter
    cifs-utils

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
    cargo
    rustc
    nodejs
    (python3.withPackages (
      ps: with ps; [
        pynvim
        pygobject3
        requests
      ]
    ))
    tree-sitter
    fd
  ];
}
