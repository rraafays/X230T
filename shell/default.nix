{ pkgs, lib, ... }:

let
  USER = "raf";
  starshipConfigs = import ./starship { inherit pkgs lib; };
in
{
  programs.fish.enable = true;

  users.users.root.shell = pkgs.fish;

  home-manager.users.${USER} = {
    home.packages = with pkgs; [
      nerd-fonts.symbols-only
    ];
    home.file.".config/starship.toml".source = starshipConfigs.user;
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
