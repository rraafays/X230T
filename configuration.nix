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

  security.rtkit.enable = true;

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-user-docs
    gnome-music
    showtime
    epiphany
    gnome-console
  ];

  nixpkgs.config.allowUnfree = true;

  environment.enableAllTerminfo = true;
  environment.systemPackages = with pkgs; [
    nix-search
    iosevka
    sarasa-gothic
    nerd-fonts.symbols-only
  ];

  environment.sessionVariables = rec {
    MESA_GL_VERSION_OVERRIDE = "4.3";
    MESA_GLSL_VERSION_OVERRIDE = "430";
  };

  system.stateVersion = "26.05";
}
