{ config, lib, pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    cachix
    dict
    dunst
    git
    home-manager
    konsole
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    pciutils
    qemu_kvm
    wget
    xorg.xbacklight
  ];
}
