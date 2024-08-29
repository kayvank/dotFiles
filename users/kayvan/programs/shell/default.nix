{ config, lib, pkgs, ... }:
{

  imports = [
    ./tmux.nix
    # ./bash.nix
    ./zsh.nix
  ];
}
