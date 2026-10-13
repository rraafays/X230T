{ pkgs, ... }:

{
  environment = {
    enableAllTerminfo = true;
    systemPackages = with pkgs; [
      fd
      nix-search
    ];
    sessionVariables.GOPATH = "$HOME/.go";
  };
}
