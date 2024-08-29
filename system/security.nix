{ config, lib, pkgs, ... }:

{
  security.polkit.enable = true;
  security.rtkit.enable = true;
  security.tpm2.enable = true;
  security.pam.services.swaylock = {};
 security.pam.services.hyprlock = {};
}
