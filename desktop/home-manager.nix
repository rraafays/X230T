{ pkgs, lib, ... }:

let
  dconfSettings = ./dconf/settings.ini;
in
{
  home.activation.importDconf = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -s ${dconfSettings} ]; then
      run ${pkgs.dconf}/bin/dconf load / < ${dconfSettings}
    fi
  '';
}
