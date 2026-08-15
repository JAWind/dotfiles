# Theming — Catppuccin Mocha

The environment uses the **Catppuccin Mocha** palette consistently across every
themeable tool.

## What's themed

| Tool                     | How                                                              |
|--------------------------|------------------------------------------------------------------|
| Starship                 | `catppuccin_mocha` palette in `~/.config/starship.toml`          |
| Neovim                   | `catppuccin/nvim` plugin, `catppuccin-mocha` colorscheme         |
| bat                      | `Catppuccin Mocha.tmTheme` + `~/.config/bat/config` (`--theme`)  |
| eza                      | `~/.config/eza/theme.yml` (Mocha, **mauve** accent)              |
| fzf                      | `FZF_DEFAULT_OPTS` colors in `~/.config/zsh/.zshrc`              |
| zsh-syntax-highlighting  | Mocha `ZSH_HIGHLIGHT_STYLES` sourced in `~/.config/zsh/.zshrc`   |
| tmux                     | Mocha status bar, borders, mode & messages in `tmux.conf`        |
| VS Code                  | `catppuccin` extension **+ managed `settings.json`**             |
| iTerm2                   | file-managed **dynamic profile** (`Catppuccin Mocha`)            |

## Notes per tool

**bat** — the theme is a `.tmTheme` file in `~/.config/bat/themes/`, and bat only
sees custom themes after its cache is built. A chezmoi `run_onchange` script runs
`bat cache --build` automatically when the theme changes. On a brand-new machine
where bat is installed *after* the first `chezmoi apply`, run it once by hand:

```sh
bat cache --build
```

**eza** — uses the Mocha **mauve** accent. Swap `theme.yml` for another file from
[catppuccin/eza](https://github.com/catppuccin/eza) to change the accent.

**fzf** — colors are exported via `FZF_DEFAULT_OPTS`, so every picker (including
`Ctrl-r` / `Ctrl-t`) is themed.

**zsh-syntax-highlighting** — the Mocha style file is sourced *before* the plugin
loads, so your command line is colored as you type.

**tmux** — the status bar, pane borders, copy-mode, and messages use Mocha
colors (mauve accent). Reload after changes with `prefix` then `r`.

**VS Code** — a managed `settings.json` sets the color and icon themes so they
apply automatically. Note this **replaces** `~/Library/Application Support/Code/
User/settings.json` — keep any personal VS Code settings in that file (they'll
live in the repo too).

**iTerm2** — a dynamic profile JSON is placed in
`~/Library/Application Support/iTerm2/DynamicProfiles/`, which iTerm2 loads
automatically. Select **Catppuccin Mocha** under Settings → Profiles (and click
“Other Actions → Set as Default” if you want it everywhere).

## Changing flavor or accent

To move the whole environment to another Catppuccin flavor (Latte, Frappé,
Macchiato), swap each tool's theme reference: the Starship palette, the Neovim
colorscheme name, the bat/eza theme files, the fzf and tmux colors, the
zsh-syntax-highlighting style file, the VS Code theme names, and the iTerm2
profile. All the source files live under the paths in the table above.
