{ pkgs, lib, ... }:

let
  dconfSettings = ./dconf/settings.ini;
in
{
  programs.gh.enable = true;

  home.shell.enableFishIntegration = true;

  home.activation.importDconf = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -s ${dconfSettings} ]; then
      run ${pkgs.dconf}/bin/dconf load / < ${dconfSettings}
    fi
  '';
}
