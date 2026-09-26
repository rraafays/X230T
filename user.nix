{ pkgs, ... }:

let
  USER = "raf";
in
{
  home-manager = {
    backupFileExtension = "old";
    users.${USER} = {
      programs = {
        fish.enable = true;

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

        nix-your-shell = {
          enable = true;
          enableFishIntegration = true;
        };

        ghostty = {
          enable = true;
          systemd.enable = true;
          enableFishIntegration = true;
          settings = {
            font-family = "Iosevka";
            theme = "light:Adwaita,dark:Adwaita Dark";
            command = "${pkgs.tmux}/bin/tmux new-session -A -D -s ghostty";
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
