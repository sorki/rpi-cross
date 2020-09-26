{ config, lib, pkgs, ... }:
{
  imports = [
    ./arm.nix
  ];

  environment.noXlibs = true;
  services.xserver.enable = false;
  services.xserver.desktopManager.xterm.enable = lib.mkForce false;
}
