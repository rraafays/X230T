let
  VERSION = "26.05";
in
{
  nix.settings.auto-optimise-store = true;
  nixpkgs.config.allowUnfree = true;

  system = {
    stateVersion = VERSION;
    autoUpgrade = {
      enable = true;
      channel = "https://channels.nixos.org/nixos-${VERSION}";
      dates = "10:00";
      operation = "switch";
      runGarbageCollection = true;
    };
  };
}
