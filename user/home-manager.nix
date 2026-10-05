{ pkgs, lib, ... }:

let
  dconfSettings = ./dconf/settings.ini;
in
{
  programs = {
    gh.enable = true;
    git = {
      enable = true;
      settings = {
        user = {
          name = "raf";
          email = "rraf@tuta.io";
        };
      };
    };
  };

  home = {
    shell.enableFishIntegration = true;
    stateVersion = "26.05";
  };

  home.activation.importDconf = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -s ${dconfSettings} ]; then
      run ${pkgs.dconf}/bin/dconf load / < ${dconfSettings}
    fi
  '';
}
