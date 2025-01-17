# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, inputs, ... }:

let
  nixpkgs.config.allowUnfree = true;
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
in {

  time.timeZone = "America/Los_Angeles";
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allow-import-from-derivation = true;
  nix = {
    gc = { # Automate garbage collection
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs          = true
      keep-derivations      = true
    '';
  };

  imports = [
    ./hardware-configuration.nix
    ./cache.nix
    ./boot.nix
    ./network.nix
    ./xserver.nix
    ./printing.nix
    ./sound.nix
    ./virtualisation.nix
    ./users.nix
    ./environment.nix
    ./services.nix
    ./zsa-keyboard.nix
  ];



  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}
