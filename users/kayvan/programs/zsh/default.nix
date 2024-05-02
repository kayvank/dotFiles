{ config, lib, pkgs, ... }:

let
  zshConfig = ''
    bindkey -v
    eval "$(direnv hook zsh)"
    # eval "$(starship init zsh)"
    # neofetch
    '';
in
{

  programs.zsh = {
    enable = true;
    shellAliases = {
      ".." = "cd ..";
      config    = "git --git-dir=$HOME/.cfg/ --work-tree=$HOME";
      dc        = "docker-compose";
      dps       = "docker-compose ps";
      dcd       = "docker-compose down --remove-orphans";
      ping      = "prettyping";
      pbcopy    = "xsel -ib";
      pbpaste   = "xsel -ob";
      wdev      = "cd ~/dev";
      wwork     = "cd ~/dev/workspaces";
      wq2io     = "cd ~/dev/workspaces/workspace-q2io";
      whaskell  = "cd ~/dev/workspaces/workspace-q2io/workspace-haskell";
      wsoos     = "cd ~/dev/workspaces/workspae-q2io/workspace-soostone";
      wumb      = "cd ~/dev/workspaces/workspace-q2io/workspace-umbrage";
      wproto    = "cd ~/dev/workspaces/workspace-q2io/workspace-proto";
      wnixos    = "cd ~/dev/workspaces/workspace-q2io/workspace-nixos";
      wiohk     = "cd ~/dev/workspaces/workspace-iohk";
      wrust     = "cd ~/dev/workspaces/workspace-q2io/workspace-rust";
      tmx       = "tmux new-session -s $USER-`date +%s`";
    };

    shellGlobalAliases = {
      UUID = "$(uuidgen | tr -d \\n)";

    };
    sessionVariables = { ## shell env vars are set here
      "BROWSER" = "brave";
      "EDITOR" = "vim";
      "VISUAL" = "vim";
      "HISTFILESIZE" = "1000000000"; # Bigger history files for all users
      "HISTSIZE" = "1000000000";
      "HISTTIMEFORMAT"="[%F %T] ";
      "PATH" = "$PATH:$HOME/bin:$HOME/.cabal/bin:$HOME/.local/bin:~/.cargo/bin";
      DIRENV_ALLOW_NIX=1;
    };
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell" ; ## lambda
    };

    initExtra   = zshConfig;
  };
}
