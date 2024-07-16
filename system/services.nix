{ config, lib, pkgs, ... }:

{
  services = {
      libinput = {
        enable = true;
        touchpad = {
          disableWhileTyping = true;
          tapping = true;
          buttonMapping = "lmr";
        };
      };

    gnome.gnome-keyring.enable = true;

    upower.enable = true;

    blueman.enable = true;

    dbus = {
      enable = true;
      packages = [ pkgs.dconf ];
    };

    openssh.enable = true;

  };
}
