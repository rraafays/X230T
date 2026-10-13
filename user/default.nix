{ config, pkgs, ... }:

let
  user = config.shared.username;
in
{
  home-manager = {
    backupFileExtension = "old";
    users.${user} =
      let
        homeStateVersion = config.shared.home.stateVersion;
        gitName = config.shared.username;
        gitEmail = config.shared.email;
      in
      {
        pkgs,
        lib,
        ...
      }:
      {
        imports = [ ./home-manager.nix ];
        home.stateVersion = homeStateVersion;
        programs.git = {
          enable = true;
          settings.user = {
            name = gitName;
            email = gitEmail;
          };
        };
      };
  };

  users.users.${user} = {
    shell = pkgs.fish;
    isNormalUser = true;
    description = user;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      amberol
      apostrophe
      audio-sharing
      blanket
      bottles
      cine
      collision
      constrict
      crosspipe
      cursor-cli
      curtail
      davinci-resolve
      dialect
      eartag
      eyedropper
      fragments
      fretboard
      gimp3
      gnome-boxes
      gnome-mahjongg
      gnome-obfuscate
      gnome-sound-recorder
      gnomeExtensions.audio-switch-shortcuts
      impression
      junction
      mpv
      nootka
      paper-clip
      pika-backup
      pwvucontrol
      rawtherapee
      reaper
      rockbox-utility
      switcheroo
      tor-browser
      tuxguitar
      ungoogled-chromium
      valuta
      video-trimmer
      wechat
    ];
  };
}
