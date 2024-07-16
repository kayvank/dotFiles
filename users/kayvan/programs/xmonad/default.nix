{ pkgs, ...}:

let
  startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
    xmobar &
    blueman-applet &
    nm_applet &
    pa-applet &
    dunst &
'';

    # feh -Zx ~/.config/wallpapers/saturn.jpg
  extra = ''
    ${startupScript}/bin/start
    ${pkgs.util-linux}bin/setterm -blank 0 -powersave off -powerdown 0
    ${pkgs.xorg.xset}/bin/xset s off
    ${pkgs.xcape}/bin/xcape -e "Hyper_L=Tab;Hyper_R=backslash"
    ${pkgs.xorg.xrandr}/bin/xrandr --auto
    ${pkgs.xorg.xrandr}/bin/xrandr  --setprovideroutputsource 1 0
    ${pkgs.xorg.xrandr}/bin/xrandr -- dpi 145
  '';

in
{
  xresources.properties = {
    # "Xft.dpi" = 141.21;
    "Xft.autohint" = 0;
    "Xft.hintstyle" = "hintfull";
    "Xft.hinting" = 1;
    "Xft.antialias" = 1;
    "Xft.rgba" = "rgb";
    "Xcursor*theme" = "Vanilla-DMZ-AA";
    "Xcursor*size" = 20;
  };
  xsession = {
    enable = true;
 preferStatusNotifierItems = true;
    initExtra = extra;


    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = hp: [
        hp.dbus
        hp.monad-logger
      ];
      config = ./xmonad.hs;
    };
  };
}
