{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # ThinkPad Power Management & Battery Thresholds
  services.tlp = {
    enable = true;
    settings = {
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 80;
      CPU_SCALING_GOVERNOR_ON_AC = "powersave";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
    };
  };

  # ThinkPad Bluetooth & Hardware Specifics
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  # 32-Bit Graphics Acceleration (Vulkan/OpenGL for 32-bit apps & Steam)
  hardware.graphics = {
    enable32Bit = true;
  };
}
