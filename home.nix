{ config, pkgs, username, ... }:

{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "26.05";

  imports = [
    ./modules/home/packages.nix
    ./modules/home/shell.nix
    ./modules/home/desktop.nix
    ./modules/home/programs.nix
  ];
}
