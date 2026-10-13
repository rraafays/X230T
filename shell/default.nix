{
  config,
  pkgs,
  lib,
  ...
}:

let
  user = config.shared.username;
  starshipConfigs = import ./starship { inherit pkgs lib; };
  gitGhShort = import ./fish/git-gh-fish.nix { inherit lib pkgs; };
in
{
  programs.fish.enable = true;

  users.users.root.shell = pkgs.fish;

  home-manager.users.${user} = {
    home.packages = with pkgs; [
      lsd
      nerd-fonts.symbols-only
    ];
    home.file.".config/lsd/config.yaml".source = ./lsd/config.yaml;
    home.file.".config/lsd/colors.yaml".source = ./lsd/colors.yaml;
    home.file.".config/starship.toml".source = starshipConfigs.user;
    home.file.".config/fish/conf.d/40-pager-colors.fish".source = ./fish/40-pager-colors.fish;
    home.file.".config/fish/conf.d/45-git-path-complete.fish".source = ./fish/git-path-complete.fish;
    home.file.".config/fish/conf.d/50-git-gh-short.fish".text = gitGhShort.loader;
    home.file.".config/fish/git-gh-short-defs.inc".text = gitGhShort.defs;
    programs = {
      fish = {
        enable = true;
        shellAliases = {
          ls = "lsd";
          l = "lsd";
          la = "lsd -a";
          ll = "lsd -l";
          lla = "lsd -la";
          dir = "lsd";
          vdir = "lsd -l";
        };
        functions.lt = {
          description = "Directory tree (lsd)";
          body = "command lsd --tree $argv";
        };
        interactiveShellInit = ''
          fish_vi_key_bindings
          set fish_greeting
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
    home.stateVersion = config.shared.home.stateVersion;
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
