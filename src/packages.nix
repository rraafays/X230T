{ pkgs, ... }:

let
  user = import ./user.nix;
  duf = pkgs.writeShellScriptBin "duf" ''
    exec ${pkgs.duf}/bin/duf --theme ansi "$@"
  '';
in
{
  environment.systemPackages = with pkgs; [
    btop
    duf
    dust
    fd
    lf
    nix-search
    p7zip
    rar
  ];

  users.users.${user.name}.packages = with pkgs; [
    amberol
    android-tools
    apostrophe
    ardour
    audio-sharing
    blanket
    bottles
    carla
    cine
    collision
    constrict
    crosspipe
    cursor-cli
    curtail
    davinci-resolve
    dialect
    eartag
    eyedropper
    firefox
    fragments
    fretboard
    gimp3
    gnome-boxes
    gnome-mahjongg
    gnome-obfuscate
    gnome-sound-recorder
    guitarix
    impression
    junction
    lilypond
    lsd
    mpv
    multiplex
    paper-clip
    pika-backup
    rawtherapee
    rockbox-utility
    switcheroo
    tonelib-gfx
    tonelib-jam
    tor-browser
    tuxguitar
    valuta
    video-trimmer
    wechat
    zathura
  ];
}
