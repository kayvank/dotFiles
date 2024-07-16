{ config, lib, pkgs, ... }:

{
    services.printing = { # Enable CUPS to print documents.
      enable = true;
      drivers = [ pkgs.mfcj6510dwlpr ]; # printer driver
      browsing = true;
      listenAddresses = [ "*:631" ];
      allowFrom = [ "all" ];
      defaultShared = true;
    };
}
