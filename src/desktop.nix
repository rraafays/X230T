{ pkgs, ... }:

let
  user = import ./user.nix;
in
{
  services = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    gnome.sushi.enable = true;
    xserver.xkb = {
      layout = "us";
      variant = "";
    };
  };

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-user-docs
    gnome-music
    showtime
    epiphany
    gnome-console
  ];

  home-manager.users.${user.name}.qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "adwaita";
  };
}
