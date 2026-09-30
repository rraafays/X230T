{ pkgs, ... }:

let
  USER = "raf";
in
{
  programs.fish.enable = true;

  home-manager = {
    backupFileExtension = "old";
    users.${USER} = {
      gtk = {
        enable = true;
        colorScheme = "dark";
        theme = {
          name = "Adwaita-dark";
          package = pkgs.gnome-themes-extra;
        };
      };
      qt = {
        enable = true;
        style = {
          name = "adwaita-dark";
          package = pkgs.adwaita-qt;
        };
      };
      programs = {
        fish = {
          enable = true;
          interactiveShellInit = ''
            fish_vi_key_bindings
            set fish_greeting
          '';
        };

        zoxide = {
          enable = true;
          enableFishIntegration = true;
        };

        nix-your-shell = {
          enable = true;
          enableFishIntegration = true;
        };

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
      # fonts
      iosevka
      sarasa-gothic
      nerd-fonts.symbols-only

      # applications
      amberol
      apostrophe
      audio-sharing
      blanket
      bottles
      cine
      collision
      constrict
      crosspipe
      curtail
      dconf2nix
      decoder
      deja-dup
      dialect
      eartag
      eyedropper
      firefox
      firefox-gnome-theme
      fragments
      fretboard
      gnome-boxes
      gnome-mahjongg
      gnome-obfuscate
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
      tangram
      tuxguitar
      valuta
      video-trimmer
      wechat
      gnomeExtensions.audio-switch-shortcuts
    ];
  };
}
