# tmux

A light [tmux](https://github.com/tmux/tmux) configuration for splitting the
terminal into panes and windows, keeping long-running sessions, and navigating
vim-style. Config lives at `~/.config/tmux/tmux.conf`.

## The prefix

tmux commands are triggered by a **prefix** key, then the command key. This
setup keeps the default prefix, **`Ctrl-b`**. Throughout this doc, "`prefix`"
means press `Ctrl-b`, release, then press the next key.

## Behavior

Set in `tmux.conf`:

- **True color** — `tmux-256color` with RGB overrides, so colors match your
  terminal and Neovim.
- **Mouse on** — click to select panes/windows, drag borders to resize, scroll
  to view history.
- **10,000-line scrollback** per pane.
- **Instant escape** (`escape-time 0`) — no lag on `Esc`, which matters in vim.
- **1-based numbering** — windows and panes start at `1` (easier to reach than
  `0` on the keyboard).

## Keybindings (customized)

| Keys              | Action                                             |
|-------------------|----------------------------------------------------|
| `prefix` then `\|` | Split the pane **left/right** (vertical border)   |
| `prefix` then `-` | Split the pane **top/bottom** (horizontal border)  |
| `prefix` then `h/j/k/l` | Move to the pane left/down/up/right (vim-style) |
| `prefix` then `r` | Reload the config (shows "Config reloaded")        |

New splits open in the **current pane's directory**. The default `"` and `%`
split bindings are removed in favor of `|` and `-`.

## Useful built-in bindings

These come with tmux and are worth knowing:

| Keys              | Action                               |
|-------------------|--------------------------------------|
| `prefix` then `c` | Create a new window                  |
| `prefix` then `n` / `p` | Next / previous window         |
| `prefix` then `1`..`9` | Jump to window by number        |
| `prefix` then `,` | Rename the current window            |
| `prefix` then `z` | Zoom (maximize) the current pane; repeat to unzoom |
| `prefix` then `x` | Close the current pane               |
| `prefix` then `d` | Detach the session (leaves it running) |
| `prefix` then `[` | Enter copy/scroll mode (`q` to exit) |

Reattach a detached session later with `tmux attach` (or `tmux a`).

## Status bar

A minimal bar with a transparent background: the **session name** (bold) on the
left, and the **time** (`HH:MM`) on the right.

## Sessions

Start named sessions so they're easy to find:

```sh
tmux new -s work      # create/attach a session called "work"
tmux ls               # list sessions
tmux attach -t work   # reattach
```

Sessions keep running after you detach or close the terminal, which makes tmux
handy for long tasks and remote work.

## Reload & customize

After editing the config, reload it with `prefix` then `r` (or restart tmux).
Edit through chezmoi so changes are tracked:

```sh
chezmoi edit ~/.config/tmux/tmux.conf
chezmoi apply
```
