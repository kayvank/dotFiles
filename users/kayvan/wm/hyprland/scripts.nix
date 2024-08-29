{ pkgs }:

let
  intMonitor = "eDP-1";
  extMonitor = "DP-3";

  monitorsConf = "$XDG_CONFIG_HOME/hypr/monitors.conf";

  monitorAdded = pkgs.writeShellScriptBin "monitor-added" ''
    ${pkgs.hyprctl}/bin/hyprctl  --batch "\
      dispatch moveworkspacetomonitor 1 ${extMonitor};\
      dispatch moveworkspacetomonitor 2 ${extMonitor};\
      dispatch moveworkspacetomonitor 3 ${extMonitor};\
      dispatch moveworkspacetomonitor 4 ${extMonitor};\
      dispatch moveworkspacetomonitor 5 ${extMonitor};\
      dispatch moveworkspacetomonitor 6 ${extMonitor}"
      dispatch moveworkspacetomonitor 7 ${extMonitor}"
      dispatch moveworkspacetomonitor 8 ${extMonitor}"
      dispatch moveworkspacetomonitor 9 ${extMonitor}"
  '';


  monitorInit = pkgs.writeShellScriptBin "monitor-removed" ''
    ${pkgs.hyprctl}/bin/hyprctl dispatch dpms on ${intMonitor}
    echo "monitor=${intMonitor},1920x1200@90,0x0,2" > ${monitorsConf}
  '';
  wsNix = pkgs.writeShellScriptBin "ws-nix" ''${pkgs.kitty}/bin/kitty -d ~/dev/workspaces --hold 'tmux' & '';


in
{
  inherit monitorInit;
  inherit wsNix;
  inherit extMonitor;

}
