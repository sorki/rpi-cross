{ config, lib, pkgs, ... }:
{
  imports = [
    <nixpkgs/nixos/modules/profiles/base.nix>
  ];

  # this pulls too much graphical stuff
  services.udisks2.enable = lib.mkForce false;
  # this pulls spidermonkey and firefox
  security.polkit.enable = false;

  # mailutils won't cross
  nixpkgs = {
    overlays = [(self: super: {
      smartmontools = super.smartmontools.override { mailutils = null; };
    })];
  };

  boot.supportedFilesystems = lib.mkForce [ "vfat" ];
  i18n.supportedLocales = lib.mkForce [ (config.i18n.defaultLocale + "/UTF-8") ];

  documentation.enable = false;
  documentation.nixos.enable = false;
}
