let
  user = import ./src/user.nix;
  version = "26.05";
  home-manager = fetchTarball "https://github.com/nix-community/home-manager/archive/release-${version}.tar.gz";
in
{
  imports = [
    ./hardware-configuration.nix
    "${home-manager}/nixos"
    ./src/audio.nix
    ./src/desktop.nix
    ./src/editor.nix
    ./src/fonts.nix
    ./src/input.nix
    ./src/languages.nix
    ./src/packages.nix
    ./src/shell.nix
    ./src/terminal.nix
    ./src/timezone.nix
  ];

  environment.sessionVariables = {
    GOPATH = "$HOME/.go";
    MESA_GL_VERSION_OVERRIDE = "4.3";
    MESA_GLSL_VERSION_OVERRIDE = "430";
  };

  boot = {
    loader.grub = {
      enable = true;
      device = "/dev/sda";
      useOSProber = true;
      configurationLimit = 10;
    };
    kernelParams = [ "threadirqs" ];
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

  nix.settings.auto-optimise-store = true;
  nixpkgs.config.allowUnfree = true;
  powerManagement.cpuFreqGovernor = "performance";
  system = {
    stateVersion = version;
    autoUpgrade = {
      enable = true;
      channel = "https://channels.nixos.org/nixos-${version}";
      dates = "08:00";
      operation = "switch";
      runGarbageCollection = true;
    };
  };

  services = {
    openssh = {
      enable = true;
      settings.AcceptEnv = [
        "LANG"
        "LC_*"
        "LC_ALL"
        "LANGUAGE"
        "XMODIFIERS"
      ];
    };
    libinput.enable = true;
    printing.enable = true;
  };

  security.sudo = {
    enable = true;
    extraConfig = ''
      Defaults lecture = never
      Defaults pwfeedback
    '';
  };

  users.users.${user.name} = {
    isNormalUser = true;
    description = user.name;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  home-manager = {
    backupFileExtension = "old";
    users.${user.name} = {
      home.stateVersion = version;
      programs = {
        git = {
          enable = true;
          settings.user = {
            inherit (user) name email;
          };
        };
        gh.enable = true;
      };
    };
    users.root.home.stateVersion = version;
  };

  documentation = {
    enable = true;
    dev.enable = true;
    doc.enable = true;
    info.enable = true;
    nixos = {
      enable = true;
      includeAllModules = true;
    };
    man = {
      man-db.enable = true;
      mandoc.enable = false;
      cache = {
        enable = true;
        generateAtRuntime = true;
      };
    };
  };
}
