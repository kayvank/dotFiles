# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, inputs, ... }:

let
  nixpkgs.config.allowUnfree = true;
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
in {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./cache.nix
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allow-import-from-derivation = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.systemd.enable = true; # #K
  boot.initrd.kernelModules = [ ];
  boot.initrd.availableKernelModules =
    [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
  # boot.kernelParams = [ "module_blacklist=hid_sensor_hub" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules =
    [ "kvm-intel" "btqca" "btusb" "hci_qca" "hci_uart" "sg" "btintel" ];
  boot.extraModulePackages = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp108s0.useDHCP = lib.mkDefault true;
  networking.hostName = "saturn-iohk"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager = {
    enable = true; # Easiest to use and most distros use this by default.
    insertNameservers = [ # # google nameservers
      "8.8.8.8"
      "8.8.4.4"
    ];
  };
  time.timeZone = "America/Los_Angeles";
  services = {
      libinput = {
        enable = true;
        touchpad = {
          disableWhileTyping = true;
          tapping = true;
          buttonMapping = "lmr";
        };
      };
    xserver = {
      enable = true;
      displayManager = {
        lightdm.enable = true;
        defaultSession = "none+xmonad";
      };
      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
      };
    };
    gnome.gnome-keyring.enable = true;
    upower.enable = true;
    blueman.enable = true;

    dbus = {
      enable = true;
      packages = [ pkgs.dconf ];
    };
    printing = { # Enable CUPS to print documents.
      enable = true;
      drivers = [ pkgs.mfcj6510dwlpr ]; # printer driver
      browsing = true;
      listenAddresses = [ "*:631" ];
      allowFrom = [ "all" ];
      defaultShared = true;
    };
    openssh.enable = true;

  };
  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  hardware.pulseaudio.enable = true;
  hardware.bluetooth.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kayvan = {
    isNormalUser = true;
    initialPassword = "123password";
    extraGroups = [
      "wheel"
      "audio"
      "bluetooth"
      "docker"
      "networkmanager"
      "scanner"
      "lp"
      "video"
      "vboxusers"
      # "nixbld"
      "libvirtd"
      "qemu-libvirtd"
    ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    packages = with pkgs; [ brave ];
  };
  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    home-manager
    pciutils
    konsole
    xorg.xbacklight
    qemu_kvm
    cachix
    dict
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs = {
    light.enable = true;
    mtr.enable = true;
    dconf.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    zsh.enable = true;
  };
  # Enable Docker
  virtualisation = {
    docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
    libvirtd.enable = true;
  };

  nix = {
    # Automate garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs          = true
      keep-derivations      = true
    '';

    # Required by Cachix to be used as non-root user
    settings = {
      trusted-users = [ "root" "kayvan" "@wheel" ];
      auto-optimise-store = true;
    };
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 35901 8000 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}
