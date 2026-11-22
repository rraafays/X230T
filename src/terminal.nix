{ pkgs, ... }:

let
  user = import ./user.nix;
in
{
  environment.enableAllTerminfo = true;
  home-manager.users.${user.name} = {
    home.file.".config/fontconfig/conf.d/10-terminal-mono.conf".text = ''
      <?xml version="1.0"?>
      <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
      <fontconfig>
        <alias>
          <family>monospace</family>
          <prefer>
            <family>Iosevka</family>
            <family>Sarasa Mono SC</family>
          </prefer>
        </alias>
      </fontconfig>
    '';

    programs.alacritty = {
      enable = true;
      settings = {
        terminal.shell = {
          program = "${pkgs.tmux}/bin/tmux";
          args = [
            "new-session"
            "-A"
            "-D"
            "-s"
            "main"
          ];
        };
        font = {
          size = 12.0;
          normal = {
            family = "Iosevka";
            style = "Regular";
          };
          bold.style = "Bold";
          italic.style = "Italic";
          bold_italic.style = "Bold Italic";
        };
        cursor.style = {
          shape = "Block";
          blinking = "On";
        };
        window = {
          padding = {
            x = 20;
            y = 20;
          };
          dynamic_padding = true;
          title = "";
          dynamic_title = false;
        };
        colors = {
          primary = {
            background = "0x000000";
            foreground = "0xaaaaaa";
          };
          cursor = {
            cursor = "0xaaaaaa";
            text = "0x000000";
          };
          selection = {
            background = "0xaaaaaa";
            text = "0x000000";
          };
          normal = {
            black = "0x000000";
            red = "0xaa0000";
            green = "0x00aa00";
            yellow = "0xaa5500";
            blue = "0x0000aa";
            magenta = "0xaa00aa";
            cyan = "0x00aaaa";
            white = "0xaaaaaa";
          };
          bright = {
            black = "0x555555";
            red = "0xff5555";
            green = "0x55ff55";
            yellow = "0xffff55";
            blue = "0x5555ff";
            magenta = "0xff55ff";
            cyan = "0x55ffff";
            white = "0xffffff";
          };
        };
      };
    };

    programs.tmux = {
      enable = true;
      escapeTime = 0;
      terminal = "tmux-256color";
      focusEvents = false;
      extraConfig = ''
        unbind -a
        set -g copy-mode-selection-style 'reverse'
        set -g mode-keys vi
        set -g mode-style 'reverse'
        set -as terminal-overrides ',*:Ss=\E[%p1%d q:Se=\E[1 q'
        set -g prefix None
        set -s set-clipboard external
        set -g status off
        set -g status-keys emacs
        set -g allow-passthrough off
        setw -g aggressive-resize on
        set -as terminal-features ',*:RGB'
        set -as terminal-overrides ',tmux-256color:RGB:Tc'
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

        bind-key -n 'M-Left' if-shell -F '#{@vim}' 'send-keys M-Left' 'select-pane -L'
        bind-key -n 'M-Down' if-shell -F '#{@vim}' 'send-keys M-Down' 'select-pane -D'
        bind-key -n 'M-Up' if-shell -F '#{@vim}' 'send-keys M-Up' 'select-pane -U'
        bind-key -n 'M-Right' if-shell -F '#{@vim}' 'send-keys M-Right' 'select-pane -R'
      '';
    };
  };
}
