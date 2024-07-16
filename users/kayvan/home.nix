{ config, pkgs, lib, stdenv, ... }:
let
  username = "kayvan";
  homeDirectory = "/home/${username}";
  configHome = "${homeDirectory}/.config";

  defaultPkgs = with pkgs; [
    amazon-ecs-cli       # amazon ecs client
    arandr               # simple GUI for xrandr
    mate.atril
    aspell
    aspellDicts.en       # Aspell dictionary for English
    awscli2              # asw cli
    bashmount            # mount usb
    bgs # Extremely fast and small background setter for X
    brightnessctl        # Xbacklight (Hardware Level)
    blueman              # GTK-based Bluetooth Manager
    cmake
    cowsay               # cow shell ouput
    docker-compose       # docker manager
    duf                  # disk utility
    direnv               # customize env per directory
    element              #  Periodic table
    element-desktop      #  A feature-rich client for Matrix.org
    eza                  # a better `ls`
    fd                   # "find" for files
    feh                  # image viewer
    file                 # light weight image viewer
    firefox
    gcc                  # C/C++
    gh                   # github CLI tool
    grafana
    gimp                 # gnu image manipulation program
    glow                 # terminal markdown viewer
    gnumake              # A tool to control the generation of non-source files from sources
    graphviz             # grapsh visualization tool
    gvfs                 # gnu Virtual Filesystem support library
    irony-server         # c/c++ minor mode, emacs
    ispell               # An interactive spell-checking program for Unix usec by emacs
    killall              # kill processes by name
    # kitty
    libnotify            # notify-send command
    libreoffice          # mostly for the pdf editor
    lsof                 # A tool to list open files
    multilockscreen      # fast lockscreen based on i3lock
    cinnamon.nemo        # file explorer
    neofetch             # command-line system information
    nixfmt-classic       # format nix files
    nix-prefetch-git
    rclone              # sync with gdrive
    pa_applet            # pulseaudio applet for trayer
    pgformatter          # postgresql sql syntax beatifier
    polybar              # use with xmonad bar
    postgresql
    prettyping           # a nicer pingpdfmixtool
    ranger               # terminal file explorer
    rtags                # C/C++ client-server indexer based on clang
    # redis                # redis
    ripgrep              # fast grep
    sbcl                 # lisp compiler
    signal-desktop       # encrypted com
    shfmt                # a shell parser and formatter
    sqlite               # db sqlite
    slack                # messaging client
    termonad             # haskell terminal emulator
    tmate                # tmux like Terminal Sharing
    tree                 # display files in a tree view
    usbutils             # Tools for working with USB devices, such as lsusb
    volumeicon           # volume icon for trayer
    virt-manager         # mange vms
    virt-viewer          # view vmx
    vscode               # ms visual studio
    watchexec            # execute commands in response to file change
    xsel                 # clipboard support (also for neovim)
    xclip                # copy pate like mac does
    yarn                 # js build
    zip                  # zip archive
    zeal                 # offline api docs

    # fixes the `ar` error required by cabal
    # binutils-unwrapped
  ];
  home.stateVersion = "22.05";

  pythonPkgs = with pkgs.python311Packages;[
    # ipython
    pip
  ];
  gitPkgs = with pkgs.gitAndTools; [
    diff-so-fancy # git diff with colors
    git-crypt     # git files encryption
    hub           # github command-line client
    tig           # diff and commit view
  ];

  haskellPkgs = with pkgs.haskellPackages; [
    cabal-install           # package manager
    haskell-language-server # haskell IDE (ships with ghcide)
    hoogle                  # documentation
    implicit-hie
    xmobar
    ghc
  ];

  xmonadPkgs = with pkgs; [
    networkmanager_dmenu   # networkmanager on dmenu
    networkmanagerapplet   # networkmanager applet
    nitrogen               # wallpaper manager
    xcape                  # keymaps modifier
    xorg.xkbcomp           # keymaps modifier
    xorg.xmodmap           # keymaps modifier
    xorg.xrandr            # display manager (X Resize and Rotate protocol)
    xorg.xdpyinfo
  ];

  nodePkgs = with pkgs.NodePackages; [
    bash-language-server
  ];

in

{

  programs.home-manager.enable = true;
  imports = (import ./programs) ++ (import ./services);

  xdg = {
    inherit configHome;
    enable = true;
  };
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    packages =
      defaultPkgs ++
      gitPkgs ++
      haskellPkgs ++
      pythonPkgs ++
      xmonadPkgs ;

      sessionVariables = {
        DISPLAY = ":0";
        EDITOR = "vim";
      };
  };
  # notifications about home-manager news
  news.display = "silent";

  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = true;
    # packageOverrides = p: {nur = import (import pinned/nur.nix) { inherit pkgs; };};
  };

  # Let Home Manager install and manage itself.
  services = {
    gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      enableSshSupport = true;
    };
    flameshot.enable = true;
    trayer = {
      enable = true;
      settings = {
        edge = "top";
        align = "right";
        SetDockType  = true;
        SetPartialStrut = true;
        expand = true;
        transparent = true;
        width = 5;
        height=15;
        tint = "black";
      };
    };
  };
  # restart services on change
  systemd.user.startServices = "sd-switch";

  programs = {
    # bash.enable = true;
    zsh.enable = true;
    emacs = {
      enable = true;
      package = pkgs.emacs29-gtk3;  # replace with pkgs.emacs-gtk, or a version provided by the community overlay if desired.
      extraPackages = epkgs: [
        epkgs.nix-mode
        epkgs.magit
        epkgs.emacsql
        epkgs.emacsql-sqlite
      ];
    };
    htop = {
      enable = true;
      settings = {
        sort_direction = true;
        sort_key = "PERCENT_CPU";
      };
    };
    bat.enable = true;
    direnv = {
      enable = true;
      enableZshIntegration = true;
      # enableBashIntegration = true;
      nix-direnv.enable = true;
    };
    jq.enable = true;
    ssh = {
      enable = true;
      extraConfig = ''
        Host *
        ControlMaster auto
        ControlPath /tmp/%r@%h:%p
        ControlPersist 2h
        # Read more about SSH config files: https://linux.die.net/man/5/ssh_config
#
        Host q2io.dev
        HostName q2io.dev
        User q2io
#
        Host testbox
        HostName 192.168.122.23
        User kayvan
#
        Host saturn-t480
        HostName 192.168.183.240
        User kayvan
#
        Host github.com
        HostName github.com
        User git
        IdentityFile ~/.ssh/id_rsa_q2io
        IdentitiesOnly yes

        Host github.com-schwarzer-swan
          HostName github.com
          User schwarzer-swan
          IdentityFile ~/.ssh/schwarzer_swan_rsa
          IdentitiesOnly yes
      '';
    };
    zoxide = {
      enable = true;
      # enableBashIntegration = true;
      enableZshIntegration = true;
      options = [];
    };
  }; ## program

}
