let
  user = import ./user.nix;
  rate = 48000;
  quantum = 256;
  minQuantum = 32;
  maxQuantum = 2048;
  frames = n: "${toString n}/${toString rate}";
in
{
  users.users.${user.name}.extraGroups = [ "audio" ];
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    extraConfig = {
      pipewire."90-music-low-latency"."context.properties" = {
        "default.clock.rate" = rate;
        "default.clock.quantum" = quantum;
        "default.clock.min-quantum" = minQuantum;
        "default.clock.max-quantum" = maxQuantum;
      };
      pipewire-pulse."90-music-low-latency" = {
        "context.properties" = {
          "default.clock.rate" = rate;
          "default.clock.quantum" = quantum;
        };
        "pulse.properties" = {
          "pulse.min.req" = frames minQuantum;
          "pulse.default.req" = frames quantum;
          "pulse.min.quantum" = frames minQuantum;
          "pulse.max.quantum" = frames maxQuantum;
        };
      };
      jack."90-music-low-latency"."jack.properties" = {
        "node.latency" = frames minQuantum;
        "node.rate" = "1/${toString rate}";
      };
    };
  };

  security = {
    rtkit.enable = true;
    pam.loginLimits = [
      {
        domain = "@audio";
        item = "rtprio";
        type = "-";
        value = "95";
      }
      {
        domain = "@audio";
        item = "memlock";
        type = "-";
        value = "unlimited";
      }
    ];
  };

}
