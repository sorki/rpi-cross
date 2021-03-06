{ config, lib, pkgs, ... }:

{
  imports = [
    ./profiles/raspberrypi_aarch.nix
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

  hardware.deviceTree.overlays = [
    { name = "pps"; dtsFile = ./dts/pps.dts; }
    { name = "spi"; dtsFile = ./dts/spi.dts; }
  ];


  users.users.root.openssh.authorizedKeys.keys =
    with import ./ssh-keys.nix; [ srk ];

  system.stateVersion = "20.09";
}
