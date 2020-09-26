{ config, pkgs, lib, modulesPath, ... }:
{
  imports = [
    ./arm-headless.nix
    <nixpkgs/nixos/modules/installer/cd-dvd/sd-image.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];

  #boot.loader.timeout = -1;
  boot.loader.grub.enable = false;
  boot.loader.raspberryPi.enable = true;
  boot.loader.raspberryPi.version = 4;
  #boot.loader.generic-extlinux-compatible.enable = true;
  #boot.loader.generic-extlinux-compatible.configurationLimit = 4;

  boot.consoleLogLevel = lib.mkDefault 7;
  # mainline won't boot yet (tested with 5.7 and 5.8)
  #boot.kernelPackages = pkgs.linuxPackages_latest;
  # BRR
  boot.kernelPackages = pkgs.linuxPackages_rpi4;
  boot.kernelParams = [
    "modprobe.blacklist=pps_ldisc"
    "console=ttyAMA0,115200n8"
  ];

  services.journald = {
    extraConfig = ''
      Storage=volatile
    '';
  };

  sdImage =
  let
    raspberrypi-conf-builder =
      import (modulesPath + "/system/boot/loader/raspberrypi/raspberrypi-builder.nix") {
        pkgs = pkgs.buildPackages;
        firmware = pkgs.raspberrypifw;
        configTxt = pkgs.writeText "config.txt" #(''
        ''
          kernel=kernel.img
          initramfs initrd followkernel
          arm_64bit=1
          enable_uart=1
        ''; # + config.boot.loader.raspberryPi.firmwareConfig);
      };
  in
  {
    compressImage = false;

    firmwareSize = 128;
    firmwarePartitionName = "NIXOS_BOOT";
    populateFirmwareCommands = ''
      ${raspberrypi-conf-builder} -c ${config.system.build.toplevel} -d ./firmware
    '';
    populateRootCommands = "";
  };

  fileSystems."/boot/firmware" = {
    # This effectively "renames" the attrsOf entry set in sd-image.nix
    mountPoint = "/boot";
    neededForBoot = true;
  };
}
