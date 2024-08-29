{config, lib, pkgs,inputs, ... }:

{
  programs.hyprland = {
  enable=true;
  package = inputs.hyprland.packages."${pkgs.system}".hyprland;
  xwayland.enable = true;
  };
  environment.sessionVariables = {
   WLR_NO_HARDWARE_CURSORS = "1";
   NIXOS_OZONE_WL = "1";
  };
  xdg.portal = {
   enable = true;
   extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };
}
