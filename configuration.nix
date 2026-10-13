{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./common
    ./system
    ./user
    ./shell
    ./terminal
    ./desktop
    ./editor
    ./keyboard
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader.grub = {
      enable = true;
      device = "/dev/sda";
      useOSProber = true;
      configurationLimit = 10;
    };
  };

  networking = {
    hostName = "X230T";
    wireless.enable = true;
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };
  };

  environment.sessionVariables = {
    MESA_GL_VERSION_OVERRIDE = "4.3";
    MESA_GLSL_VERSION_OVERRIDE = "430";
  };
}
