{ config, pkgs, lib, ... }:
{
  imports = [
    ./arm-headless.nix
    <nixpkgs/nixos/modules/installer/cd-dvd/sd-image.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];

  boot.loader.timeout = 3;
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;
  boot.loader.generic-extlinux-compatible.configurationLimit = 4;

  boot.consoleLogLevel = lib.mkDefault 7;
  boot.kernelPackages = pkgs.linuxPackages_latest;
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
    extlinux-conf-builder =
      import <nixpkgs/nixos/modules/system/boot/loader/generic-extlinux-compatible/extlinux-conf-builder.nix> {
        pkgs = pkgs.buildPackages;
      };
  in
  {
    # causes bzip2 compression of image already compressed by zstd
    compressImage = false;


    populateFirmwareCommands = let
      configTxt = pkgs.writeText "config.txt" ''
        # Prevent the firmware from smashing the framebuffer setup done by the mainline kernel
        # when attempting to show low-voltage or overtemperature warnings.
        avoid_warnings=1

        [pi0]
        kernel=u-boot-rpi0.bin

        [pi1]
        kernel=u-boot-rpi1.bin
      '';
      in ''
        (cd ${pkgs.raspberrypifw}/share/raspberrypi/boot && cp bootcode.bin fixup*.dat start*.elf $NIX_BUILD_TOP/firmware/)
        cp ${pkgs.ubootRaspberryPiZero}/u-boot.bin firmware/u-boot-rpi0.bin
        cp ${pkgs.ubootRaspberryPi}/u-boot.bin firmware/u-boot-rpi1.bin
        cp ${configTxt} firmware/config.txt
      '';

    populateRootCommands = ''
        mkdir -p ./files/boot
        ${config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${config.system.build.toplevel} -d ./files/boot
      '';
  };
}
