{
  config,
  lib,
  pkgs,
  hostname,
  username,
  inputs,
  ...
}:

{
  imports = [
    ./modules/system/boot.nix
    ./modules/system/desktop.nix
    ./modules/system/packages.nix
    ./modules/system/services.nix
    ./modules/system/virt.nix
  ];

  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Kolkata";

  programs.zsh.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "input"
      "uinput"
      "libvirtd"
      "kvm"
    ];
    packages = with pkgs; [
      tree
    ];
  };

  system.stateVersion = "26.05";
}
