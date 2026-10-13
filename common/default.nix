{ lib, ... }:

let
  homeManagerRelease = "26.05";
  home-manager = fetchTarball "https://github.com/nix-community/home-manager/archive/release-${homeManagerRelease}.tar.gz";
in
{
  imports = [
    "${home-manager}/nixos"
    ./home-manager.nix
  ];

  options.common = {
    username = lib.mkOption {
      type = lib.types.str;
      description = ''
        Login name for the primary human user. Home Manager blocks in importable
        modules (shell, terminal, desktop, …) attach to this account.
      '';
    };

    home.stateVersion = lib.mkOption {
      type = lib.types.str;
      description = ''
        Home Manager state version for the primary user. Set once per host;
        importable modules rely on common setting HM stateVersion.
      '';
    };

    email = lib.mkOption {
      type = lib.types.str;
      description = ''
        Primary user email (e.g. Git author on hosts that import user/ or set the
        same Home Manager block).
      '';
    };

    homeManagerRelease = lib.mkOption {
      type = lib.types.str;
      description = ''
        Home Manager release tag wired in this module (must match the tarball
        import in common/default.nix and the host NixOS channel).
      '';
    };
  };

  config.common.username = lib.mkDefault "raf";
  config.common.email = lib.mkDefault "rraf@tuta.io";
  config.common.home.stateVersion = lib.mkDefault "26.05";
  config.common.homeManagerRelease = lib.mkDefault homeManagerRelease;
}
