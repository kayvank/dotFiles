{ config, lib, pkgs, ... }:

{
  hardware.keyboard.zsa.enable = true; ##  Ergodox EZ and Moonlander Mark I
  environment.systemPackages = with pkgs; [ wally-cli keymapp ];
}
