{ pkgs, ... }:

let
  USER = "raf";
in
{
  home-manager.users.${USER} = {
    home.packages = with pkgs; [
      iosevka
      sarasa-gothic
    ];
    programs = {
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
          set-option -g focus-events on
          set -s extended-keys on
          set -s extended-keys-format xterm
          set -g user-keys on

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

          # Neovim sets @vim on the pane (editor/lua/editor/tmux.lua).
          bind-key -n 'M-Left' if-shell -F '#{@vim}' 'send-keys M-Left' 'select-pane -L'
          bind-key -n 'M-Down' if-shell -F '#{@vim}' 'send-keys M-Down' 'select-pane -D'
          bind-key -n 'M-Up' if-shell -F '#{@vim}' 'send-keys M-Up' 'select-pane -U'
          bind-key -n 'M-Right' if-shell -F '#{@vim}' 'send-keys M-Right' 'select-pane -R'
        '';
      };
    };
  };
}
