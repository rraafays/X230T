{ pkgs, ... }:

let
  USER = "raf";
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

  home-manager.users.${USER} = {
    home.packages = with pkgs; [
      gnome-themes-extra
      adwaita-qt
    ];
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
  };
}
