{ pkgs, lib, ... }:

let
  user = import ./user.nix;
  starship = import ./.config/starship { inherit pkgs lib; };
  gitGhShort = import ./.config/git-gh-fish.nix { inherit pkgs lib; };
  fishInit = ''
    fish_vi_key_bindings
    set fish_greeting
  '';
in
{
  programs.fish.enable = true;
  users.users.${user.name}.shell = pkgs.fish;
  users.users.root.shell = pkgs.fish;
  home-manager.users.${user.name} = {
    home.shell.enableFishIntegration = true;
    home.file = {
      ".config/fish/conf.d" = {
        source = ./.config/fish;
        recursive = true;
      };
      ".config/fish/conf.d/50-git-gh-short.fish".text = gitGhShort.loader;
      ".config/fish/git-gh-short-defs.inc".text = gitGhShort.defs;
      ".config/lsd" = {
        source = ./.config/lsd;
        recursive = true;
      };
      ".config/starship.toml".source = starship.user;
      ".config/direnv/direnv.toml".text = ''
        [global]
        warn_timeout = "0s"
      '';
    };
    programs = {
      fish = {
        enable = true;
        interactiveShellInit = fishInit;
        shellAliases = {
          ls = "lsd";
          l = "lsd";
          la = "lsd -a";
          ll = "lsd -l";
          lla = "lsd -la";
          lt = "lsd -l --total-size";
          dir = "lsd";
          vdir = "lsd -l";
          tree = "lsd --tree";
        };
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
    home.file.".config/starship.toml".source = starship.root;
    programs = {
      fish = {
        enable = true;
        interactiveShellInit = fishInit;
      };
      starship = {
        enable = true;
        enableFishIntegration = true;
      };
    };
  };
}
