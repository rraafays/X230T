{ config, pkgs, ... }:

let
  VERSION = "26.05";
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

  nix.settings.auto-optimise-store = true;
  nixpkgs.config.allowUnfree = true;

  system = {
    stateVersion = "26.05";
    autoUpgrade = {
      enable = true;
      channel = "https://channels.nixos.org/nixos-${VERSION}";
      dates = "10:00";
      operation = "switch";
      runGarbageCollection = true;
    };
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader.grub = {
      enable = true;
      device = "/dev/sda";
      useOSProber = true;
      configurationLimit = 10;
    };
  };

  security = {
    rtkit.enable = true;
    sudo = {
      enable = true;
      extraConfig = ''
        Defaults lecture = never
        Defaults pwfeedback
      '';
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
      dconf2nix
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
}
