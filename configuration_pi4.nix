{ config, lib, pkgs, ... }:

{
  imports = [
    ./profiles/raspberrypi4.nix
  ];

  nixpkgs = {
    localSystem.system = "x86_64-linux";
    crossSystem.system = "aarch64-linux";
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
        CONFIG_GPIO_SYSFS y
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

  # XXX: sadly broken with 4.19 rpi kernel
  #hardware.deviceTree.overlays = [
  #  { name = "pps"; dtsFile = ./dts/pps.dts; }
  #  { name = "spi"; dtsFile = ./dts/spi.dts; }
  #];

  users.users.root.openssh.authorizedKeys.keys =
    with import ./ssh-keys.nix; [ srk ];

  system.stateVersion = "20.09";
}
