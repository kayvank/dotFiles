{ config, lib, pkgs, ... }:

{
  services = {
    displayManager.defaultSession = "none+xmonad";
    xserver = {
      enable = true;
      displayManager = {
        lightdm.enable = true;
      };
      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
      };
    };
  };
}
