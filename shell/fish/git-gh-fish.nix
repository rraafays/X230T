# Generates ~/.config/fish/conf.d/50-git-gh-short.fish
{ lib }:
let
  inherit (lib) concatStringsSep;

  extraNames = [
    "lg"
    "lgh"
    "sw"
  ];

  # switch: Fish reserved keyword → sw
  gitCommands = [
    "add"
    "am"
    "archive"
    "bisect"
    "blame"
    "branch"
    "bundle"
    "checkout"
    "cherry-pick"
    "clean"
    "clone"
    "commit"
    "config"
    "describe"
    "diff"
    "fetch"
    "format-patch"
    "fsck"
    "gc"
    "grep"
    "init"
    "log"
    "merge"
    "mv"
    "pull"
    "push"
    "rebase"
    "reflog"
    "remote"
    "reset"
    "restore"
    "revert"
    "rm"
    "show"
    "sparse-checkout"
    "stage"
    "stash"
    "submodule"
    "tag"
    "worktree"
  ];

  ghCommands = [
    "api"
    "auth"
    "browse"
    "cache"
    "co"
    "codespace"
    "completion"
    "extension"
    "gist"
    "gpg-key"
    "issue"
    "label"
    "org"
    "pr"
    "preview"
    "project"
    "release"
    "repo"
    "ruleset"
    "run"
    "search"
    "secret"
    "ssh-key"
    "variable"
    "workflow"
  ];

  shortNames = gitCommands ++ ghCommands ++ extraNames;

  namesFishList =
    concatStringsSep " " (map (n: "'${n}'") shortNames);

  mkGitFn = cmd: ''
    function '${cmd}' --wraps 'git ${cmd}' --description 'git ${cmd}'
        git ${cmd} $argv
    end'';

  mkGhFn = cmd: ''
    function '${cmd}' --wraps 'gh ${cmd}' --description 'gh ${cmd}'
        gh ${cmd} $argv
    end'';

  lgFn = ''
    function lg --wraps 'git status' --description 'git status --short'
        git status --short $argv
    end'';

  swFn = ''
    function sw --wraps 'git switch' --description 'git switch'
        git switch $argv
    end'';

  lghFn = ''
    function lgh --wraps 'gh status' --description 'gh status'
        gh status $argv
    end'';

  allShortFns =
    concatStringsSep "\n\n" (
      [ lgFn swFn lghFn ]
      ++ map mkGitFn gitCommands
      ++ map mkGhFn ghCommands
    );

  indentFour =
    s:
    concatStringsSep "\n" (map (line: "    " + line) (lib.strings.splitString "\n" s));

in
''
  # Short git/gh commands — defined only inside a work tree (PWD / fish_prompt hooks).
  set -g __git_gh_short_names ${namesFishList}

  function __git_gh_in_repo
      git rev-parse --is-inside-work-tree >/dev/null 2>&1
  end

  function __git_gh_disable
      for fn in $__git_gh_short_names
          functions -e $fn 2>/dev/null
      end
  end

  function __git_gh_enable
${indentFour allShortFns}
  end

  function __git_gh_sync
      if __git_gh_in_repo
          if not set -q __git_gh_short_active
              __git_gh_enable
              set -g __git_gh_short_active 1
          end
      else if set -q __git_gh_short_active
          __git_gh_disable
          set -e __git_gh_short_active
      end
  end

  function __git_gh_on_pwd --on-variable PWD
      __git_gh_sync
  end

  # .git removed without cd (rare): drop shortcuts on next prompt only when active.
  function __git_gh_on_prompt --on-event fish_prompt
      if not set -q __git_gh_short_active
          return
      end
      if not __git_gh_in_repo
          __git_gh_disable
          set -e __git_gh_short_active
      end
  end

  __git_gh_sync
''
