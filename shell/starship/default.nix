{ pkgs, lib }:
let
  merge = files: pkgs.runCommand "starship.toml" {
    nativeBuildInputs = [ pkgs.yq ];
  } ''
    tomlq -s -t 'reduce .[] as $item ({}; . * $item)' ${lib.concatStringsSep " " files} > $out
  '';
in
{
  user = merge [
    ./base.toml
    ./user.toml
  ];
  root = merge [
    ./base.toml
    ./root.toml
  ];
}
