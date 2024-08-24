{ config, lib, pkgs, ... }: {
  programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;

      extraConfig = ''
        font_family Mono Book
        font_size 12
        enable_audio_bell = false;
'';
  };
}
