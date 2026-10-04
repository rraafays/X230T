{ pkgs, ... }:

let
  USER = "raf";
in
{
  users.groups = {
    "input" = {
      name = "input";
      members = [ USER ];
    };
    "uinput" = {
      name = "uinput";
      members = [ USER ];
    };
  };
  services.kanata = {
    enable = true;
    keyboards."default".config = ''
      (defsrc
        grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
        tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
        caps a    s    d    f    g    h    j    k    l    ;    '    ret
        lsft z    x    c    v    b    n    m    ,    .    /    rsft
        lctl lmet lalt           spc            ralt rmet rctl
      )

      (deflayer main
        grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
        tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
        lctl a    s    d    f    g    h    j    k    l    ;    '    ret
        lsft z    x    c    v    b    n    m    ,    .    /    rsft
        lctl lmet lalt           @nav            ralt rmet rctl
      )

      (deflayer nav
        _    _    _    _    _    _    _    _    _    _    _    _    _    _
        _    _    _    _    _    _    _    _    _    _    _    _    _    _
        _    _    @ml    @md    @mu    @mr    left down   up   right _    _    _
        _    @mwl    @mwd    @mwu    @mwr    _    _    _    mlft    mrgt    mmid    _
        _    _    _                 _              _    _    _
      )

      (defalias
        nav (tap-hold 200 200 spc (layer-while-held nav))
      )

      (defalias
        ml (movemouse-accel-left 10 500 1 20)
        md (movemouse-accel-down 10 500 1 20)
        mu (movemouse-accel-up 10 500 1 20)
        mr (movemouse-accel-right 10 500 1 20)
      )

      (defalias
        mwl (mwheel-left 10 20)
        mwd (mwheel-down 10 20)
        mwu (mwheel-up 10 20)
        mwr (mwheel-right 10 20)
      )
    '';
  };

  systemd.services.kanata-input-device = {
    description = "Restart Kanata after an input device is connected";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.systemd}/bin/systemctl restart kanata-default.service";
    };
  };

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="input", ENV{ID_INPUT}=="1", ATTRS{name}!="kanata", \
      TAG+="systemd", ENV{SYSTEMD_WANTS}+="kanata-input-device.service"
  '';
}
