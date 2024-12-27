{ config, lib, pkgs, ... }:

{
  services = {

    gnome.gnome-keyring.enable = false;

    upower.enable = true;

    blueman.enable = true;

    dbus = {
      enable = true;
      packages = [ pkgs.dconf ];
    };

    openssh.enable = true;

    pipewire = {
     enable = true;
     alsa.enable = true;
     alsa.support32Bit = true;
     pulse.enable = true;
     jack.enable = true;
    };

  };
}
