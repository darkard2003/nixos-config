{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];

  services.openssh.enable = true;
  services.tailscale.enable = true;
  services.fstrim.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  programs.firefox.enable = true;
  programs.kdeconnect.enable = true;

  programs.thunar = {
    enable = true;

    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  programs.xfconf.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;
  services.avahi.enable = true;
  services.samba-wsdd.enable = true;

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      fontconfig
      freetype
      stdenv.cc.cc.lib
    ];
  };

  services.kanata = {
    enable = true;
    keyboards = {
      default = {
        extraDefCfg = ''
          process-unmapped-keys yes
          concurrent-tap-hold yes
        '';
        config = ''
          (defsrc
            caps  a   s   d   f   j   k   l   ;
          )

          (defvar
            tap-time 200
            hold-time 200
          )

          (defalias
            a (tap-hold-release $tap-time $hold-time a lalt)
            s (tap-hold-release $tap-time $hold-time s lsft)
            d (tap-hold-release $tap-time $hold-time d lctl)
            f (tap-hold-release $tap-time $hold-time f lmet)
            j (tap-hold-release $tap-time $hold-time j rmet)
            k (tap-hold-release $tap-time $hold-time k rctl)
            l (tap-hold-release $tap-time $hold-time l rsft)
            ; (tap-hold-release $tap-time $hold-time ; ralt)
          )

          (deflayer base
            esc @a  @s  @d  @f  @j  @k  @l  @;
          )
        '';
      };
    };
  };

  services.flatpak = {
    enable = true;
    remotes = [
      {
        name = "flathub";
        location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      }
    ];
    packages = [
    ];
  };
}
