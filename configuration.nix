{ config, pkgs, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-26.05.tar.gz";
in
{
  imports = [
    "${home-manager}/nixos"
    ./hardware-configuration.nix
    ./neovim.nix
    ./keyboard.nix
  ];

  home-manager.backupFileExtension = "old";
  home-manager.users.raf = {
    programs.fish.enable = true;
    programs.gh.enable = true;
    programs.git = {
      enable = true;
      settings = {
        user = {
          name = "raf";
          email = "rraf@tuta.io";
        };
      };
    };
    programs.nix-your-shell = {
      enable = true;
      enableFishIntegration = true;
    };
    programs.ghostty = {
      enable = true;
      systemd.enable = true;
      enableFishIntegration = true;
      clearDefaultKeybinds = true;
      settings = {
        font-family = "Iosevka";
        theme = "light:Adwaita,dark:Adwaita Dark";
      };
    };
    home = {
      shell.enableFishIntegration = true;
      stateVersion = "26.05";
    };
  };

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

  users.users."raf" = {
    shell = pkgs.fish;
    isNormalUser = true;
    description = "raf";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      amberol
      apostrophe
      audio-sharing
      blanket
      collision
      constrict
      curtail
      deja-dup
      decoder
      dialect
      eartag
      eyedropper
      fragments
      fretboard
      impression
      junction
      gnome-mahjongg
      gnome-obfuscate
      paper-clip
      pika-backup
      switcheroo
      tangram
      valuta
      video-trimmer
      gnome-boxes
      dconf2nix
      firefox
      firefox-gnome-theme
      cine
      mpv
      wechat
      tuxguitar
    ];
  };

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-user-docs
    gnome-music
    showtime
    epiphany
    gnome-console
  ];

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      	fish_vi_key_bindings
      	set fish_greeting
    '';
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

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
