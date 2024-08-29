{ config, lib, pkgs, ... }:

{
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

}
