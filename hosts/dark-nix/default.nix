{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Intel CPU & Graphics Specifics
  boot.kernelParams = [ "i915.enable_guc=2" ];
  services.thermald.enable = true;

  hardware.bluetooth.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vpl-gpu-rt
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };
}
