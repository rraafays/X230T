{ pkgs, ... }:

let
  USER = "raf";
in
{
  home-manager = {
    backupFileExtension = "old";
    users.raf = {
      programs.fish.enable = true;
      programs.gh.enable = true;
      programs.git = {
        enable = true;
        settings = {
          user = {
            name = "raf";
            email = "rraf@tuta.io";
          };
        };
      };
      programs.nix-your-shell = {
        enable = true;
        enableFishIntegration = true;
      };
      programs.ghostty = {
        enable = true;
        systemd.enable = true;
        enableFishIntegration = true;
        clearDefaultKeybinds = true;
        settings = {
          font-family = "Iosevka";
          theme = "light:Adwaita,dark:Adwaita Dark";
        };
      };
      home = {
        shell.enableFishIntegration = true;
        stateVersion = "26.05";
      };
    };
  };

  users.users."raf" = {
    shell = pkgs.fish;
    isNormalUser = true;
    description = "raf";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      amberol
      apostrophe
      audio-sharing
      blanket
      collision
      constrict
      curtail
      deja-dup
      decoder
      dialect
      eartag
      eyedropper
      fragments
      fretboard
      impression
      junction
      gnome-mahjongg
      gnome-obfuscate
      paper-clip
      pika-backup
      switcheroo
      tangram
      valuta
      video-trimmer
      gnome-boxes
      dconf2nix
      firefox
      firefox-gnome-theme
      cine
      mpv
      wechat
      tuxguitar
    ];
  };
}
