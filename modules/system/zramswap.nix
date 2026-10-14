{ ... }: {
  zramSwap = {
    enable = true;
    memoryPercent = 100;
    priority = 999;
  };

  boot.kernel.sysctl = {
    "vm.swappiness" = 180;
  };
}
