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
      wq2io     = "cd ~/dev/workspaces/workspace-q2io";
      wiohk     = "cd ~/dev/workspaces/workspace-iohk";
      tmx       = "tmux new-session -s $USER-`date +%s`";
      ls        = "ls --hyperlink=auto --color=tty";
    };

    shellGlobalAliases = {
      UUID = "$(uuidgen | tr -d \\n)";

    };
## shell env vars are set here
    sessionVariables = {
      BROWSER = "brave";
      EDITOR = "vim";
      VISUAL = "vim";
      HISTTIMEFORMAT ="[%F %T]";
      AIKEN_EXE = "$HOME/.cargo/bin";
      PATH = "$PATH:$HOME/bin:$AIKEN_EXE";
      DIRENV_ALLOW_NIX=1;
    };
    oh-my-zsh = {
    custom="$HOME/.config/dotfiles/zsh.themes";

      enable = true;
      # theme = "robbyrussell" ;
      theme = "lambda-gitster";
    };

    initExtra   = zshConfig;
  };
}
