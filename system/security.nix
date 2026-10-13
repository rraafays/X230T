{
  security = {
    rtkit.enable = true;
    sudo = {
      enable = true;
      extraConfig = ''
        Defaults lecture = never
        Defaults pwfeedback
      '';
    };
  };
}
