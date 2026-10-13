{ config, ... }:

let
  user = config.common.username;
in
{
  home-manager.backupFileExtension = "old";

  home-manager.users.${user} = {
    home.stateVersion = config.common.home.stateVersion;
  };
}
