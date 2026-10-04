{ pkgs, ... }:

let
  USER = "raf";
in
{
  home-manager = {
    backupFileExtension = "old";
    users.${USER} = {
      programs = {
        gh.enable = true;
        git = {
          enable = true;
          settings = {
            user = {
              name = "${USER}";
              email = "rraf@tuta.io";
            };
          };
        };
      };
      home = {
        shell.enableFishIntegration = true;
        stateVersion = "26.05";
      };
    };
  };

  users.users.${USER} = {
    shell = pkgs.fish;
    isNormalUser = true;
    description = "${USER}";
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
      dialect
      eartag
      eyedropper
      fragments
      fretboard
      gnome-boxes
      gnome-mahjongg
      gnome-obfuscate
      gnomeExtensions.audio-switch-shortcuts
      impression
      junction
      mpv
      nootka
      paper-clip
      pika-backup
      pwvucontrol
      rawtherapee
      rockbox-utility
      switcheroo
      tuxguitar
      ungoogled-chromium
      valuta
      video-trimmer
      wechat
    ];
  };
}
