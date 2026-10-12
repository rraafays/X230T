{ pkgs, lib }:
let
  inherit (lib) concatStringsSep filter unique;

  fishReserved = [
    "and"
    "begin"
    "break"
    "case"
    "continue"
    "else"
    "end"
    "for"
    "function"
    "if"
    "in"
    "not"
    "or"
    "return"
    "status"
    "switch"
    "while"
  ];

  gitSkip = [
    "status"
    "switch"
    "help"
  ];

  ghSkip = [
    "config"
    "status"
    "alias"
    "help"
  ];

  gitCmdsFile =
    pkgs.runCommand "git-short-cmd-list"
      {
        nativeBuildInputs = [ pkgs.git ];
      }
      ''
        git --list-cmds=main,others,alias 2>/dev/null | sort -u > $out
      '';

  ghCmdsFile =
    pkgs.runCommand "gh-short-cmd-list"
      {
        nativeBuildInputs = [
          pkgs.gh
          pkgs.python3
        ];
      }
      ''
            python3 <<'PY' > $out
        import re, subprocess
        out = []
        insec = False
        for line in subprocess.run(["gh", "--help"], capture_output=True, text=True).stdout.splitlines():
            if line.endswith(" COMMANDS"):
                insec = True
                continue
            if line == "HELP TOPICS":
                break
            if insec:
                m = re.match(r"^\s+(\S+):", line)
                if m:
                    out.append(m.group(1))
        print("\n".join(sorted(set(out))))
        PY
      '';

  readLines = path: filter (l: l != "") (lib.splitString "\n" (lib.fileContents path));

  isSkipped = skip: cmd: lib.elem cmd fishReserved || lib.elem cmd skip;

  gitNames = unique (filter (cmd: !(isSkipped gitSkip cmd)) (readLines gitCmdsFile));

  ghNames =
    let
      taken = gitNames;
    in
    unique (filter (cmd: !(isSkipped ghSkip cmd) && !(lib.elem cmd taken)) (readLines ghCmdsFile));

  extraNames = [
    "lg"
    "sw"
    "lgh"
  ];

  shortNames = extraNames ++ gitNames ++ ghNames;

  namesFishList = concatStringsSep " " (map (n: "'${n}'") shortNames);

  mkGitFn = cmd: ''
    function '${cmd}' --wraps 'git ${cmd}' --description 'git ${cmd}'
        git ${cmd} $argv
    end'';

  mkGhFn = cmd: ''
    function '${cmd}' --wraps 'gh ${cmd}' --description 'gh ${cmd}'
        gh ${cmd} $argv
    end'';

  defs =
    concatStringsSep "\n\n" (
      [
        ''
          function lg --wraps 'git status' --description 'git status --short'
              git status --short $argv
          end''
        ''
          function sw --wraps 'git switch' --description 'git switch'
              git switch $argv
          end''
        ''
          function lgh --wraps 'gh status' --description 'gh status'
              gh status $argv
          end''
      ]
      ++ map mkGitFn gitNames
      ++ map mkGhFn ghNames
    )
    + "\n";

  loader = ''
    set -g __git_gh_short_names ${namesFishList}
    set -g __git_gh_short_defs $__fish_config_dir/git-gh-short-defs.inc

    function __git_gh_in_repo
        git rev-parse --is-inside-work-tree >/dev/null 2>&1
    end

    function __git_gh_disable
        for fn in $__git_gh_short_names
            functions -e $fn 2>/dev/null
        end
        set -e __git_gh_short_active
    end

    function __git_gh_enable
        source $__git_gh_short_defs
        set -g __git_gh_short_active 1
    end

    function __git_gh_sync
        if __git_gh_in_repo
            if not set -q __git_gh_short_active
                __git_gh_enable
            end
        else if set -q __git_gh_short_active
            __git_gh_disable
        end
    end

    function __git_gh_on_pwd --on-variable PWD
        __git_gh_sync
    end

    function __git_gh_on_prompt --on-event fish_prompt
        if not set -q __git_gh_short_active
            return
        end
        if not __git_gh_in_repo
            __git_gh_disable
        end
    end

    __git_gh_sync
  '';

in
{
  inherit loader defs;
}
