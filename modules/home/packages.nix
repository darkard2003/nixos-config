{
  pkgs,
  antigravity-nix,
  ...
}:

let
  system = pkgs.stdenv.hostPlatform.system;
in
{
  home.packages = with pkgs; [
    rofi
    qutebrowser
    keepassxc
    sequoia-chameleon-gnupg
    zed-editor
    wofi
    cheese
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
    kdePackages.breeze
    kdePackages.breeze-icons
    kdePackages.qqc2-desktop-style
    kdePackages.plasma-integration
    kdePackages.kcolorscheme

    # Utilities & Script dependencies
    bc
    jq
    imagemagick
    bluetui
    handlr

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
