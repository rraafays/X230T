{
  documentation = {
    enable = true;
    dev.enable = true;
    doc.enable = true;
    info.enable = true;
    nixos = {
      enable = true;
      includeAllModules = true;
    };
    man = {
      man-db.enable = true;
      mandoc.enable = false;
      cache = {
        enable = true;
        generateAtRuntime = true;
      };
    };
  };
}
