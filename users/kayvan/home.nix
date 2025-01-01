{ config, pkgs, lib, stdenv,inputs, ... }:
let
  username = "kayvan";
  homeDirectory = "/home/${username}";
  configHome = "${homeDirectory}/.config";

  screenCapture = pkgs.pkgs.writeShellScriptBin "start" ''
    DIR_PATH=$HOME/Pictures/Screenshots
    mkdir -p $DIR_PATH
    FILE_PATH=$DIR_PATH/$(date +'%s_grim.png')
    grim -g "$(slurp)" $FILE_PATH
    imv $FILE_PATH
'';

  startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
    ${pkgs.waybar}/bin/waybar &
    ${pkgs.swww}/bin/swww init &

    sleep 1

    ${pkgs.swww}/bin/swww img ${./wallpapers/saturn.jpg} &
  '';
  fontPkgs = with pkgs; [
    font-awesome # awesome fonts
    material-design-icons # fonts with glyphs
    (nerdfonts.override {
      fonts = [
        "JetBrainsMono"
        "Iosevka"
      ];
    })
  ];

  audioPkgs = with pkgs; [
    paprefs # pulseaudio preferences
    pasystray # pulseaudio systray
    pavucontrol # pulseaudio volume control
    playerctl # music player controller
    pulsemixer # pulseaudio mixer
  ];

  defaultPkgs = with pkgs; [
    arandr               # simple GUI for xrandr
    mate.atril           # A simple multi-page document viewer
    aspell
    aspellDicts.en       # Aspell dictionary for English
    bgs # Extremely fast and small background setter for X

	  bemenu #  	#App launcher
    brightnessctl        # Xbacklight (Hardware Level)
    nemo        # file explorer
    cmake
    code-cursor          # cursor ai tool
    cowsay               # cow shell ouput
    docker-compose       # docker manager
    duf                  # disk utility
    devenv               # A simple multi-page document viewer
    direnv               # customize env per directory
    eza                  # a better `ls`
    fd                   # "find" for files
    feh                  # image viewer
    file                 # light weight image viewer
    firefox-beta
    gcc                  # C/C++
    gh                   # github CLI tool
    gimp                 # gnu image manipulation program
    glow                 # terminal markdown viewer
    gnumake              # A tool to control the generation of non-source files from sources
    grim                 # screenshots
    grimblast            # screenshot program from hyprland
    gvfs                 # gnu Virtual Filesystem support library
    imv                  # image viewer
    ispell               # An interactive spell-checking program for Unix usec by emacs
    killall              # kill processes by name
    libnotify            # notificationsk
    loupe                # image viewer
    lsof                 # A tool to list open files
    mp4v2                # Provides functions to read, create, and modify mp4 files
    nerdfetch            # command-line system information
    nixpkgs-fmt          # format nix files
    nix-prefetch-git
    nix-search-cli       # faster nix serach client
    pa_applet            # pulseaudio applet for trayer
    pgformatter          # postgresql sql syntax beatifier
    prettyping           # like ping
    ranger               # terminal file explorer
    rtags                # C/C++ client-server indexer based on clang
    ripgrep              # fast grep
    sbcl                 # lisp compiler
    shfmt                # a shell parser and formatter
    sqlite               # db sqlite
    slack                # messaging client
    telegram-desktop
    tmate                # tmux like Terminal Sharing
    tree                 # display files in a tree view
    volumeicon           # volume icon for trayer
    virt-manager         # mange vms
    virt-viewer          # view vmx
    virtiofsd

    # vivaldi              # brwoser
    vscode-with-extensions  # ms visual studio
    watchexec            # execute commands in response to file change
    wayfarer             # Screen recording for wayland
    wl-clipboard         # clipboard support
    wofi                 # app launcher
    xwaylandvideobridge  # screensharing bridge
    zip                  # zip archive
    zeal                 # offline api docs

  ] ++ fontPkgs ++ audioPkgs;
  home.stateVersion = "22.05";

  gitPkgs = with pkgs.gitAndTools; [
    diff-so-fancy # git diff with colors
    git-crypt     # git files encryption
    hub           # github command-line client
    tig           # diff and commit view
  ];

  haskellPkgs = with pkgs.haskellPackages; [
    cabal-install           # package manager
    # haskell-language-server # haskell IDE (ships with ghcide)
    hoogle                  # documentation
    implicit-hie
    # ghc
  ];
  pythonPkgs = [
    (pkgs.python3.withPackages (python-pkgs: [
      python-pkgs.pandas
      python-pkgs.requests
    ]))
  ];


  wpctl = "${pkgs.wireplumber}/bin/wpctl";
  gblast = "${pkgs.grimblast}/bin/grimblast";
  hyprlock = "${pkgs.hyprlock}/bin/hyprlock";
hyprpaper  = "${pkgs.hyprpaper}/bin/hyprpaper";

scripts = import ./wm/hyprland/scripts.nix { inherit pkgs; } ;

  workspaceConf = { monitor }: ''
    workspace=1,persistent:true,monitor:${monitor}
    workspace=2,persistent:true,monitor:${monitor}
    workspace=3,persistent:true,monitor:${monitor}
    workspace=4,persistent:true,monitor:${monitor}
    workspace=5,persistent:true,monitor:${monitor}
    workspace=6,persistent:true,monitor:${monitor}
    workspace=7,persistent:true,monitor:${monitor}
    workspace=8,persistent:true,monitor:${monitor}
    workspace=9,persistent:true,monitor:${monitor}
  '';

in

{

  programs.home-manager.enable = true;

  imports = (import ./programs) ++ (import ./services);

  xdg = {
    inherit configHome;
    enable = true;
  };

  home = {
    packages =
      defaultPkgs ++
      gitPkgs ++
      haskellPkgs ++
      pythonPkgs;
  };

  fonts.fontconfig.enable = true;

  # e.g. for slack, signal, etc
  xdg.configFile."electron-flags.conf".text = ''
    --enable-features=UseOzonePlatform
    --ozone-platform=wayland
  '';

  xdg.portal = {
    enable = true;
    config = {
      common = {
        default = [ "hyprland" ];
      };
      hyprland = {
        default = [ "gtk" "hyprland" ];
      };
    };
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];
    xdgOpenUsePortal = true;
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
  };
  # restart services on change
  systemd.user.startServices = "sd-switch";


  programs = {
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
  };


  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = (builtins.readFile ./wm/hyprland/hyprland.conf) + ''
      bind=SUPER,P,exec,"wofi" --show run --style=${./wm/hyprland/wofi.css} --term=footclient --prompt=Run
      bind=SUPER,A,exec,${gblast} save area
      bind=SUPER,S,exec,${gblast} save screen
      bind=SUPERCTRL,L,exec,${hyprlock}
      # audio volume bindings
      bindel=,XF86AudioRaiseVolume,exec,${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%+
      bindel=,XF86AudioLowerVolume,exec,${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%-
      bindl=,XF86AudioMute,exec,${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle
      bindl=,Print,exec,${screenCapture}
      monitor = , preferred, auto, 1
 ${workspaceConf { monitor = ", preferred, auto, 1"; }}

      exec-once=${hyprpaper}
      exec-once=${pkgs.blueman}/bin/blueman-applet
      exec-once=${pkgs.networkmanagerapplet}/bin/nm-applet --sm-disable --indicator
    '';
    plugins = [ ];
    systemd = {
      enable = true;
      variables = [ "--all" ];
    };
    xwayland.enable = true;
  };
}
