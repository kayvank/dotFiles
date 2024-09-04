{ config, lib, pkgs, ... }:

{
  # hardware.graphics = {
  hardware.graphics= {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      (vaapiIntel.override { enableHybridCodec = true; })
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
}