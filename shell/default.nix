{ pkgs, lib, ... }:

let
  USER = "raf";
  starshipConfigs = import ./starship { inherit pkgs lib; };
  gitGhShort = import ./fish/git-gh-fish.nix { inherit lib pkgs; };
in
{
  programs.fish.enable = true;

  users.users.root.shell = pkgs.fish;

  home-manager.users.${USER} = {
    home.packages = with pkgs; [
      nerd-fonts.symbols-only
    ];
    home.file.".config/starship.toml".source = starshipConfigs.user;
    home.file.".config/fish/conf.d/50-git-gh-short.fish".text = gitGhShort.loader;
    home.file.".config/fish/git-gh-short-defs.inc".text = gitGhShort.defs;
    programs = {
      fish = {
        enable = true;
        interactiveShellInit = ''
          fish_vi_key_bindings
          set fish_greeting
          # Let tmux handle Alt+arrows for pane navigation (not fish dir/history).
          if set -q TMUX
            for mode in insert default
              bind --preset -M $mode -e alt-left
              bind --preset -M $mode -e alt-right
              bind --preset -M $mode -e alt-up
              bind --preset -M $mode -e alt-down
              bind --preset -M $mode -e \e\[1\;9C
              bind --preset -M $mode -e \e\[1\;9D
              bind --preset -M $mode -e \e\[1\;9A
              bind --preset -M $mode -e \e\[1\;9B
            end
          end
        '';
      };
      starship = {
        enable = true;
        enableFishIntegration = true;
      };
      zoxide = {
        enable = true;
        enableFishIntegration = true;
      };
      nix-your-shell = {
        enable = true;
        enableFishIntegration = true;
      };
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
    };
    home.file.".config/direnv/direnv.toml".text = ''
      [global]
      warn_timeout = "0s"
    '';
  };

  home-manager.users.root = {
    home.stateVersion = "26.05";
    home.file.".config/starship.toml".source = starshipConfigs.root;
    programs = {
      fish = {
        enable = true;
        interactiveShellInit = ''
          fish_vi_key_bindings
          set fish_greeting
        '';
      };
      starship = {
        enable = true;
        enableFishIntegration = true;
        enableBashIntegration = true;
      };
    };
  };
}
