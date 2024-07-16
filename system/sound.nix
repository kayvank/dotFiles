{ config, lib, pkgs, ... }:

{
  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  hardware.pulseaudio.enable = true;
}
