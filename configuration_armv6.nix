{ config, lib, pkgs, ... }:

{
  imports = [
    ./profiles/raspberrypi_armv6l.nix
  ];

  nixpkgs = {
    localSystem.system = "x86_64-linux";
    crossSystem.system = "armv6l-linux";
  };

  time.timeZone = "Europe/Amsterdam";

  environment.systemPackages = with pkgs; [
    libgpiod
  ];

  services.openssh.enable = true;
  boot.kernelPatches = [
    {
      name = "gpio-sysfs-config";
      patch = null;
      extraConfig = ''
        GPIO_SYSFS y
      '';
    }
    {
      name = "dontwastemytime-config";
      patch = null;
      extraConfig = ''
        DRM n
        SOUND n
        VIRTUALIZATION n
      '';
    }
  ];

  hardware.deviceTree.filter = "bcm2708-rpi-zero*.dtb";
  hardware.deviceTree.overlays = [
    { name = "pps"; dtsFile = ./dts/pps.dts; }
    { name = "spi"; dtsFile = ./dts/spi.dts; }
    {
      name = "hifiberry-dac";
      dtboFile = "${pkgs.device-tree_rpi.overlays}/hifiberry-dac.dtbo";
    }
  ];


  users.users.root.openssh.authorizedKeys.keys =
    with import ./ssh-keys.nix; [ srk ];

  system.stateVersion = "20.09";


}
