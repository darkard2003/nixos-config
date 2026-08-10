{ ... }: {
  zramSwap = {
    enable = true;
    memoryPercent = 100; # Use 100% of RAM as the max compressed pool capacity
    priority = 999; # Guarantee ZRAM is filled before disk swap
  };

  boot.kernel.sysctl = {
    "vm.swappiness" = 180; # Proactively compress idle memory
  };
}
