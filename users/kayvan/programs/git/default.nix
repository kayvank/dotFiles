{ config, pkgs, ... }:
let
  gitConfig = {
    core = {
      editor = "vim";
      pager = "diff-so-fancy | less --tabs=4 -RFX";
    };
    init.defaultBranch = "main";
    merge = {
      conflictStyle = "diff3";
      tool = "vim_mergetool";
    };
    mergetool."vim_mergetool" = {
      cmd = ''vim -f -c "MergetoolStart" "$MERGED" "$BASE" "$LOCAL" "$REMOTE"'';
      prompt = false;
    };
    pull.rebase = false;
    push.autoSetupRemote = true;
    url = {
      "https://github.com/".insteadOf = "gh:";
      "ssh://git@github.com".pushInsteadOf = "gh:";
      "https://gitlab.com/".insteadOf = "gl:";
      "ssh://git@gitlab.com".pushInsteadOf = "gl:";
    };
  };

  rg = "${pkgs.ripgrep}/bin/rg";
in {
  programs.git = {
    enable = true;
    aliases = {
      amend = "commit --amend -m";
      fixup =
        "!f(){ git reset --soft HEAD~\${1} && git commit --amend -C HEAD; };f";
      loc = ''
        !f(){ git ls-files | ${rg} "\.''${1}" | xargs wc -l; };f''; # lines of code
      br = "branch";
      co = "checkout";
      st = "status";
      ls = ''
        log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate'';
      ll = ''
        log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate --numstat'';
      cm = "commit -m";
      ca = "commit -am";
      dc = "diff --cached";
    };
    extraConfig = gitConfig;
    ignores = [
      "*.bloop"
      "*.bsp"
      "*.metals"
      "*.metals.sbt"
      "*metals.sbt"
      "*~" # vi tempfile
      "*.swap" # vi tempfile
      "*.direnv"
      "*.envrc" # there is lorri, nix-direnv & simple direnv; let people decide
      "*hie.yaml" # ghcide files
      "*.mill-version" # used by metals
      "*.jvmopts" # should be local to every project
      "*.jvmopts" # should be local to every project
    ];
    includes = [
      {
        condition = "gitdir:~/dev/workspaces/workspace-iohk/**/.git";
        contentSuffix = "gitconfig-iohk";
        contents = {
          user = {
            name = "Kayvan Kazeminejad";
            email = "kayvan.kazeminejad@iohk.io";
            userName = "kayvank";
            sshCommand = "ssh -i ~/.ssh/id_rsa_q2io";
            signingkey = "D2B4E616C9524F86";
          };
        };
      }

      {
        condition = "gitdir:~/dev/worksapces/workspace-q2io/**/.git";
        contentSuffix = "gitconfig-q2io";
        contents = {
          user = {
            name = "kayvan Kazeminejad";
            email = "kayvan@q2io.com";
            userName = "kayvank";
            sshCommand = "ssh -i ~/.ssh/id_rsa_q2io";
            signingkey = "D2B4E616C9524F86";
          };
        };
      }
      {
        condition = "gitdir:~/dev/workspaces/workspace-schwarzer-swan/**/.git";
        contentSuffix = "gitconfig-schwarzer-swan";
        contents = {
          user = {
            name = "Schwarzer Swan";
            email = "schwarzer.swan@gmail.com";
            userName = "schwarzer-swan";
            sshCommand = "ssh -i ~/.ssh/schwazer_swan_rsa";
            signingkey = "542015B83D61D66A";
          };
        };
      }
{
        condition = "gitdir:~/.config/**/.git";
        contentSuffix = "gitconfig-q2io";
        contents = {
          user = {
            name = "kayvan Kazeminejad";
            email = "kayvan@q2io.com";
            userName = "kayvank";
            sshCommand = "ssh -i ~/.ssh/id_rsa_q2io";
            signingkey = "D2B4E616C9524F86";
          };
        };
      }
    ];

     # signing.key = "D2B4E616C9524F86";
     # signing.signByDefault=true;
     # userEmail = "kayvan@q2io.com";
     # userName = "kayvank";
  };
}
