{ config, lib, pkgs, ... }:

{
  virtualisation = {
    docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
    libvirtd.enable = true;
  };
}
