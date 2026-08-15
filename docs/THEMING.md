# Theming — Catppuccin Mocha

The environment uses the **Catppuccin Mocha** palette consistently across tools.

## What's themed

| Tool        | How                                                             |
|-------------|-----------------------------------------------------------------|
| Starship    | `catppuccin_mocha` palette in `~/.config/starship.toml`         |
| Neovim      | `catppuccin/nvim` plugin, `catppuccin-mocha` colorscheme        |
| bat         | `Catppuccin Mocha.tmTheme` + `~/.config/bat/config` (`--theme`) |
| eza         | `~/.config/eza/theme.yml` (Mocha, **mauve** accent)             |
| fzf         | `FZF_DEFAULT_OPTS` colors set in `~/.config/zsh/.zshrc`          |
| VS Code     | `catppuccin.catppuccin-vsc` extension (Brewfile.casks)          |

## Notes per tool

**bat** — the theme is a `.tmTheme` file in `~/.config/bat/themes/`, and bat
only sees custom themes after its cache is built. A chezmoi `run_onchange`
script runs `bat cache --build` automatically whenever the theme changes. On a
brand-new machine where bat is installed *after* the first `chezmoi apply`, run
it once by hand:

```sh
bat cache --build
```

**eza** — `theme.yml` uses the Mocha **mauve** accent. To use a different accent
(blue, peach, teal, …), replace that file with another from
[catppuccin/eza](https://github.com/catppuccin/eza).

**fzf** — colors are exported via `FZF_DEFAULT_OPTS`, so every fzf invocation
(including `Ctrl-r`, `Ctrl-t`) is themed.

**VS Code** — the extension is installed, but you still need to select the theme
once: Command Palette → “Color Theme” → **Catppuccin Mocha** (or set
`"workbench.colorTheme": "Catppuccin Mocha"` in settings). VS Code settings are
not managed by this repo.

## Not themed by default (optional)

- **iTerm2** — import a Catppuccin color preset manually (Settings → Profiles →
  Colors → Import) from [catppuccin/iterm](https://github.com/catppuccin/iterm),
  or switch to a terminal whose colors are file-managed.
- **tmux** — the status bar is minimal/transparent; it can be themed with Mocha
  colors or the `catppuccin/tmux` plugin.
- **zsh-syntax-highlighting** — command-line highlight colors can be set with
  `ZSH_HIGHLIGHT_STYLES` from [catppuccin/zsh-syntax-highlighting](https://github.com/catppuccin/zsh-syntax-highlighting).

## Changing flavor

To move the whole environment to another Catppuccin flavor (Latte, Frappé,
Macchiato), swap each tool's theme reference — the Starship palette, the Neovim
colorscheme name, the bat/eza theme files, and the fzf colors.
