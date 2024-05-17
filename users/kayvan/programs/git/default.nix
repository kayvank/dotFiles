{ config, pkgs, ... }:
let

  rg = "${pkgs.ripgrep}/bin/rg";
in {
  programs.git = {
    signing.key = "D2B4E616C9524F86";
    signing.signByDefault=true;
    userEmail = "kayvan@q2io.com";
    userName = "kayvank";
    enable = true;
    # extraConfig = gitConfig;
    includes = [
      {
        ##  include for all repositories inside workspace-iohk
        condition = "gitdir:$HOME/dev/workspaces/workspace-iohk/";
        path = "$HOME/.config/dotfiles/git-configs/iohk.inc";
      }

      {
        ##  include for all repositories inside workspace-q2io
        condition = "gitdir:$HOME/dev/worksapces/workspace-q2io/";
        path = "$HOME/.config/dotfiles/git-configs/q2io.inc";
      }
      {
        ##  include for all repositories inside workspace-schwarzer-swan
        condition = "gitdir:$HOME/dev/workspaces/workspace-schwarzer-swan/";
        path = "$HOME/.config/dotfiles/git-configs/schwarzer-swan.inc";
      }
      {
        condition = "gitdir:$HOME/.config/";
        path = "$HOME/.config/dotfiles/git-configs/q2io.inc";
      }
    ];

    };
}
