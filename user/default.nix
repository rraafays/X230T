{ config, pkgs, ... }:

let
  user = config.common.username;
in
{
  home-manager.users.${user} =
      let
        gitName = config.common.username;
        gitEmail = config.common.email;
      in
      {
        pkgs,
        lib,
        ...
      }:
      {
        imports = [ ./home-manager.nix ];
        programs.git = {
          enable = true;
          settings.user = {
            name = gitName;
            email = gitEmail;
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
