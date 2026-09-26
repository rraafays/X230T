{ config, pkgs, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-26.05.tar.gz";
in
{
  imports = [
    "${home-manager}/nixos"
    ./user.nix
    ./hardware-configuration.nix
    ./neovim.nix
    ./keyboard.nix
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
    firewall.enable = true;
    firewall.allowedTCPPorts = [ ];
    firewall.allowedUDPPorts = [ ];
  };

  time.timeZone = "Europe/London";
  i18n = {
    defaultLocale = "en_GB.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_GB.UTF-8";
      LC_IDENTIFICATION = "en_GB.UTF-8";
      LC_MEASUREMENT = "en_GB.UTF-8";
      LC_MONETARY = "en_GB.UTF-8";
      LC_NAME = "en_GB.UTF-8";
      LC_NUMERIC = "en_GB.UTF-8";
      LC_PAPER = "en_GB.UTF-8";
      LC_TELEPHONE = "en_GB.UTF-8";
      LC_TIME = "en_GB.UTF-8";
    };
  };

  security.rtkit.enable = true;
  services = {
    openssh.enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    gnome.sushi.enable = true;
    libinput.enable = true;
    printing.enable = true;
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    xserver.xkb = {
      layout = "us";
      variant = "";
    };
  };

  environment = {
    enableAllTerminfo = true;
    systemPackages = with pkgs; [
      nix-search
    ];
    gnome.excludePackages = with pkgs; [
      gnome-tour
      gnome-user-docs
      gnome-music
      showtime
      epiphany
      gnome-console
    ];

    sessionVariables = rec {
      MESA_GL_VERSION_OVERRIDE = "4.3";
      MESA_GLSL_VERSION_OVERRIDE = "430";
    };
  };

  nix = {
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "26.05";
}
