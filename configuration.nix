{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./src/common
    ./src/system
    ./src/user
    ./src/shell
    ./src/terminal
    ./src/tty
    ./src/desktop
    ./src/editor
    ./src/keyboard
    ./src/music
  ];

  services.music.enable = true;

  boot = {
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
