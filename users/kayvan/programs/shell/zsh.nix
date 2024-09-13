{ config, lib, pkgs, ... }:

let
  zshConfig = ''
    bindkey -v
    eval "$(direnv hook zsh)"
    nerdfetch
    '';
in
{

  programs.zsh = {
    enable = true;
    shellAliases = {
      # cat     = "bat";
      config    = "git --git-dir=$HOME/.cfg/ --work-tree=$HOME";
      dc        = "docker-compose";
      dps       = "docker-compose ps";
      dcd       = "docker-compose down --remove-orphans";
      emc       = "nohup emacsclient -c &> /dev/null &";
      emd       = "emacs --daemon";
      ping      = "prettyping";
      pbcopy    = "wl-copy";
      pbpaste   = "wl-paste";
      whaskell  = "cd ~/dev/workspaces/workspace-haskell";
      wsoos     = "cd ~/dev/workspaces/workspace-soostone";
      wiohk     = "cd ~/dev/workspaces/workspace-iohk";
      wq2io     = "cd ~/dev/workspaces/workspace-q2io";
      wdev      = "cd ~/dev";
      wwork     = "cd ~/dev/workspaces";
      tmx       = "tmux new-session -s $USER-`date +%s`";
    };
    sessionVariables = { ## shell env vars are set here
      "EDITOR" = "vim";
      "VISUAL" = "vim";
      "HISTFILESIZE" = "1000000000"; # Bigger history files for all users
      "HISTSIZE" = "1000000000";
      "HISTTIMEFORMAT"="[%F %T] ";
      "PATH" = "$PATH:/home/kayvan/bin";
      DIRENV_ALLOW_NIX=1;
    };
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell" ; ## lambda
    };

    initExtra   = zshConfig;
  };
}
