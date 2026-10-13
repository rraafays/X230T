# Git submodules (`src/`)

Importable Nix modules live in **separate GitHub repos** (`rraafays/<name>.nix`) and are wired into this host as submodules under **`src/<name>/`**.

| Submodule path | Remote repo |
| -------------- | ----------- |
| `src/common` | [common.nix](https://github.com/rraafays/common.nix) |
| `src/system` | [system.nix](https://github.com/rraafays/system.nix) |
| `src/user` | [user.nix](https://github.com/rraafays/user.nix) |
| `src/shell` | [shell.nix](https://github.com/rraafays/shell.nix) |
| `src/terminal` | [terminal.nix](https://github.com/rraafays/terminal.nix) |
| `src/desktop` | [desktop.nix](https://github.com/rraafays/desktop.nix) |
| `src/editor` | [editor.nix](https://github.com/rraafays/editor.nix) |
| `src/keyboard` | [keyboard.nix](https://github.com/rraafays/keyboard.nix) |

## Clone and update

```bash
git clone --recurse-submodules https://github.com/rraafays/X230T.git
cd X230T
```

Existing clone without submodules:

```bash
git submodule update --init --recursive
```

Pull host and move submodule pointers:

```bash
git pull
git submodule update --init --recursive
```

Work inside one module (commit in the **module repo**, then bump the host pointer):

```bash
cd src/shell
git checkout -b my-change
# edit, commit, push to github.com/rraafays/shell.nix
cd ../..
git add src/shell
git commit -m "Bump shell.nix"
```

## Add modules to another host repo

Use the same paths as this project: submodule checkout at **`src/<name>/`**, Nix import **`./src/<name>`**. Steps and a minimal `configuration.nix` example are in the root [README.md](../../README.md#import-elsewhere).
