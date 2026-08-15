# zsh

The shell setup: **zsh** arranged in an XDG-friendly layout, with a Starship
prompt, sensible history and completion, fuzzy tooling, and autosuggestions.

## Files

zsh reads two files here:

- **`~/.zshenv`** — sourced for *every* zsh (login, interactive, scripts). It's
  deliberately tiny: it defines the XDG base directories and sets `ZDOTDIR` to
  `~/.config/zsh` so the rest of the config lives there instead of cluttering
  `$HOME`. It also sets `EDITOR`/`VISUAL` to `nvim`.
- **`~/.config/zsh/.zshrc`** — the interactive configuration (everything below).

## What `.zshrc` sets up

**Homebrew** — `brew shellenv` runs first so brew's tools are on `PATH` before
anything else is initialized.

**History** — stored at `~/.local/state/zsh/history`, 50,000 lines, shared live
between open shells, with duplicates and space-prefixed commands ignored and
timestamps recorded.

**Completion** — `compinit` with a cached dump in `~/.cache/zsh`, a selectable
menu, and case-insensitive matching.

**Prompt & tools** — initializes [Starship](https://starship.rs) (prompt),
[zoxide](https://github.com/ajeetdsouza/zoxide) (smarter `cd`), `uv` shell
completions, and [fzf](https://github.com/junegunn/fzf) key bindings + fuzzy
completion.

**Secrets** — sources `~/.config/zsh/secrets.zsh`, which loads secrets from the
macOS Keychain (empty and harmless until you add any). See
[SECRETS.md](SECRETS.md).

**Plugins** — `zsh-autosuggestions` (fish-style suggestions from history) and
`zsh-syntax-highlighting` (colors your command line as you type), sourced last.

## Aliases

| Alias   | Runs                                        | Why                              |
|---------|---------------------------------------------|----------------------------------|
| `ls`    | `eza --group-directories-first`             | modern `ls` with icons/colors    |
| `ll`    | `eza -lah --group-directories-first --git`  | long listing, hidden files, git  |
| `cat`   | `bat`                                       | syntax-highlighted `cat`         |
| `find`  | `fd`                                        | fast, friendly `find`            |
| `grep`  | `rg`                                        | ripgrep                          |

Aliases only affect the interactive shell — scripts still get the real `cat`,
`find`, and `grep`. To bypass an alias once, prefix a command with `\` (e.g.
`\grep`).

## Navigation helpers

- **zoxide** — `z <part-of-path>` jumps to a directory you visit often; `zi`
  picks from matches interactively.
- **fzf** — `Ctrl-r` fuzzy-searches command history, `Ctrl-t` inserts a file
  path, and `Alt-c` cd's into a subdirectory.

## The prompt (Starship)

Configured in `~/.config/starship.toml` with the Catppuccin Mocha palette. Left
to right it shows: an OS/user segment, the current directory (truncated), the
git branch and status, detected language versions (Python, Node, Rust, Go, and
more), and the time — plus the duration of the last command, with a desktop
notification for commands that run longer than 45s. Icons require a Nerd Font
(installed by the Brewfile).

## Where state lives (XDG)

| Path                              | Contents                    |
|-----------------------------------|-----------------------------|
| `~/.config/zsh/`                  | `.zshrc`, `secrets.zsh`     |
| `~/.local/state/zsh/history`      | command history             |
| `~/.cache/zsh/zcompdump`          | completion cache            |

## Customizing

Edit through chezmoi so changes are tracked, then apply:

```sh
chezmoi edit ~/.config/zsh/.zshrc
chezmoi apply
exec zsh                     # reload the shell
```
