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

        tmux = {
          enable = true;
          escapeTime = 0;
          extraConfig = ''
            unbind -a
            set -g mode-keys vi
            set -g prefix None
            set -s set-clipboard external
            set -g status off
            set -g status-keys emacs

            bind -n M-Escape copy-mode
            bind -n M-Enter run "tmux setenv PREVIOUS_DIR '#{pane_current_path}'; [[ $(($(tmux display -p '8*#{pane_width}-20*#{pane_height}'))) -lt 0 ]] \
                                 && tmux splitw -v \
                                 || tmux splitw -h" 

            bind -T copy-mode-vi M-Escape send -X cancel
            bind -T copy-mode-vi v send -X begin-selection
            bind -T copy-mode-vi C-v send-keys -X rectangle-toggle \; send -X begin-selection
            bind -T copy-mode-vi y send -X copy-pipe
            bind -T copy-mode-vi M-Left select-pane -L 
            bind -T copy-mode-vi M-Down select-pane -D 
            bind -T copy-mode-vi M-Up select-pane -U   
            bind -T copy-mode-vi M-Right select-pane -R
          '';
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
