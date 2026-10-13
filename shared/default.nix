{ lib, ... }:

{
  options.shared = {
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
        Home Manager state version for shared.users. Set once per host repo;
        importable modules read it instead of hardcoding.
      '';
    };

    email = lib.mkOption {
      type = lib.types.str;
      description = ''
        Primary user email (e.g. Git author on hosts that import user/ or set the
        same Home Manager block).
      '';
    };
  };

  config.shared = {
    username = lib.mkDefault "raf";
    email = lib.mkDefault "rraf@tuta.io";
    home.stateVersion = lib.mkDefault "26.05";
  };
}
