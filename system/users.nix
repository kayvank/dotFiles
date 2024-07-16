{ config, lib, pkgs, ... }:

{
  users.users.kayvan = {
    isNormalUser = true;
    initialPassword = "123password";
    extraGroups = [
      "wheel"
      "audio"
      "bluetooth"
      "docker"
      "networkmanager"
      "scanner"
      "lp"
      "video"
      "vboxusers"
      # "nixbld"
      "libvirtd"
      "qemu-libvirtd"
    ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    packages = with pkgs; [ brave ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs = {
    light.enable = true;
    mtr.enable = true;
    dconf.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    zsh.enable = true;
  };

    nix.settings = {
      trusted-users = [ "root" "kayvan" "@wheel" ];
      auto-optimise-store = true;
    };
}
