{ config, lib, pkgs, ... }:

{
  programs.sway = {
    enable = true;
    wrapperFeatures= {
      gtk = true;
      base = true;
    };
    extraPackages = with pkgs; [
      grim #sway dep
      gsimplecal #i3status-rust dep
      light #sway dep
      pavucontrol #i3status-rust dep
      playerctl #sway dep
      pulseaudio #i3status-rust dep
      slack
      slurp #sway dep
      swayidle #sway dep
      swaylock #sway dep
      tofi #sway dep
      wf-recorder #sway
      wl-clipboard #sway dep
    ];
  };
}
