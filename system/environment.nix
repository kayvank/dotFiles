{ config, lib, pkgs, ... }:

{

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    brave
    cachix
    dict
    dunst
    git
    grim # screenshot functionality
    home-manager
    kitty
    libnotify
    libvirt
    mako # notification system developed by swaywm maintainer
    pciutils
    qemu
    rofi-wayland
    slurp # screenshot functionality
    swww # wallpaper
    udiskie
    virt-manager
    # waybar
    wget
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    wofi
    xorg.xbacklight
  ];
}
