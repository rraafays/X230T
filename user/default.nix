{ pkgs, ... }:

let
  USER = "raf";
in
{
  home-manager = {
    backupFileExtension = "old";
    users.${USER} = import ./home-manager.nix;
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
