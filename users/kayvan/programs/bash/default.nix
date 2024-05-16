{ config, lib, pkgs, ... }:

let
  bashConfig = ''
    set -o vi
    eval "$(direnv hook bash)"
    '';
in
{

  programs.bash = {
    shellAliases = {
      # cat     = "bat";
      config    = "git --git-dir=$HOME/.cfg/ --work-tree=$HOME";
      dc        = "docker-compose";
      dps       = "docker-compose ps";
      dcd       = "docker-compose down --remove-orphans";
      emc       = "nohup emacsclient -c &> /dev/null &";
      emd       = "emacs --daemon";
      ping      = "prettyping";
      pbcopy    = "xsel -ib";
      pbpaste   = "xsel -ob";
      wiohk    = "cd ~/dev/workspaces/workspace-iohk";
      wq2io   = "cd ~/dev/workspaces/workspace-q2io";
    };
    sessionVariables = { ## shell env vars are set here
      "EDITOR" = "vim";
      "VISUAL" = "vim";
      "HISTFILESIZE" = "1000000000"; # Bigger history files for all users
      "HISTSIZE" = "1000000000";
      "HISTTIMEFORMAT"="[%F %T] ";
      DIRENV_ALLOW_NIX=1;
      PATH="$PATH:~/bin:~/.cargo/bin";
    };
    initExtra   = bashConfig;
  };
}
