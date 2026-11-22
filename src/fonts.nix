{ pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      iosevka
      sarasa-gothic
      nerd-fonts.symbols-only
    ];
    fontconfig.defaultFonts = {
      sansSerif = [
        "Noto Sans CJK SC"
        "DejaVu Sans"
      ];
      serif = [
        "Noto Serif CJK SC"
        "DejaVu Serif"
      ];
      emoji = [ "Noto Color Emoji" ];
    };
  };
}
