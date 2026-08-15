# Dotfiles

A macOS development environment managed with [chezmoi](https://chezmoi.io):
zsh + Starship, Neovim, tmux, git, and a curated CLI toolchain via Homebrew —
Python-focused (uv). No secrets live in the repo and your identity is prompted
for at setup, so it is safe to share.

This README is a map. Detailed, per-topic guides live in [`docs/`](docs).

## What's inside

- **Shell** — zsh (XDG layout), Starship prompt, history, completion, fzf,
  zoxide, autosuggestions, syntax highlighting. → [docs/ZSH.md](docs/ZSH.md)
- **Editor** — Neovim (lazy.nvim): LSP, completion, treesitter, telescope, and
  quality-of-life plugins. → [docs/NEOVIM.md](docs/NEOVIM.md)
- **Terminal** — tmux, plus iTerm2 and a Nerd Font. → [docs/TMUX.md](docs/TMUX.md)
- **Python** — uv for interpreters, virtualenvs, packages, and tools; Ruff +
  pylsp in the editor. → [docs/PYTHON.md](docs/PYTHON.md)
- **Infrastructure** — Terraform and tflint, with terraform-ls in the editor.
  → [docs/TERRAFORM.md](docs/TERRAFORM.md)
- **Git** — templated identity, a global ignore file, and optional SSH commit
  signing that activates once a signing key exists. → [docs/GIT.md](docs/GIT.md)
- **Secrets** — none in the repo; read from the macOS Keychain at runtime.
  → [docs/SECRETS.md](docs/SECRETS.md)
- **Theme** — Catppuccin Mocha across Starship, Neovim, bat, eza, and fzf.
  → [docs/THEMING.md](docs/THEMING.md)

## Documentation

| Guide | What it covers |
|-------|----------------|
| [STARTUP_GUIDE.md](docs/STARTUP_GUIDE.md) | Set up a new Mac, step by step (incl. non-admin machines) |
| [ZSH.md](docs/ZSH.md) | Shell: prompt, aliases, history, completion, integrations |
| [NEOVIM.md](docs/NEOVIM.md) | Editor: layout, options, keybindings, plugins, LSP |
| [TMUX.md](docs/TMUX.md) | Terminal multiplexer: prefix, keybindings, sessions |
| [PYTHON.md](docs/PYTHON.md) | uv workflow (versions, projects, tools) + Ruff/pylsp |
| [TERRAFORM.md](docs/TERRAFORM.md) | Terraform CLI, tflint, editor support, state & creds |
| [GIT.md](docs/GIT.md) | git config, global ignore, signing, machine-local overrides |
| [SECRETS.md](docs/SECRETS.md) | Keychain secrets, SSH keys, and commit signing |
| [THEMING.md](docs/THEMING.md) | Catppuccin Mocha across the toolchain |

## Quick start

On a new Mac (full walkthrough, including non-admin machines, in
[docs/STARTUP_GUIDE.md](docs/STARTUP_GUIDE.md)):

```sh
# 1. Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# 2. chezmoi + dotfiles (prompts for name/email)
brew install chezmoi && chezmoi init --apply <your-repo-url>
# 3. core packages  (GUI apps: also run Brewfile.casks)
brew bundle --file="$HOME/.local/share/chezmoi/homebrew/Brewfile"
```

Then restart your shell (`exec zsh`) and open `nvim` once to let plugins install.

## Layout

```
.chezmoiroot                 -> "home" (managed source lives under home/)
home/                        -> $HOME
  .chezmoi.toml.tmpl            prompts for name/email at init
  dot_zshenv                 -> ~/.zshenv           (XDG dirs + ZDOTDIR)
  dot_editorconfig           -> ~/.editorconfig
  dot_gitconfig.tmpl         -> ~/.gitconfig        (identity + optional signing)
  dot_config/
    zsh/dot_zshrc            -> ~/.config/zsh/.zshrc
    zsh/private_secrets.zsh  -> ~/.config/zsh/secrets.zsh  (Keychain loader, 0600)
    git/ignore              -> ~/.config/git/ignore
    nvim/                   -> ~/.config/nvim
    tmux/tmux.conf          -> ~/.config/tmux/tmux.conf
    starship.toml           -> ~/.config/starship.toml
  private_dot_ssh/          -> ~/.ssh               (config only; keys ignored)
homebrew/Brewfile              core formulae (no admin)
homebrew/Brewfile.casks        GUI apps + VS Code extensions (may need admin)
docs/                          per-topic guides (see Documentation above)
```

Filenames use chezmoi
[source-state attributes](https://chezmoi.io/reference/source-state-attributes/):
`dot_` becomes a leading `.`, `private_` applies mode `0600`, and `.tmpl` marks
a templated file.

## Managing the repo

```sh
chezmoi diff                 # preview pending changes before applying
chezmoi apply -v             # apply the source to $HOME
chezmoi edit ~/.zshrc        # edit a managed file through the source
chezmoi cd                   # open a shell in the source repo (a git repo)
```

Commit changes from the source repo (`chezmoi cd`, then `git add -A && git commit`).
After editing a Brewfile, re-sync packages with
`brew bundle --file="$HOME/.local/share/chezmoi/homebrew/Brewfile"`.

## Backups & remote

The source in `~/.local/share/chezmoi` is a git repo with full history but
**no remote** by default. To back it up and enable one-command setup on other
machines, add a private remote and push:

```sh
chezmoi cd
git remote add origin <your-private-repo-url>
git push -u origin main
```

Once pushed, the quick-start `chezmoi init --apply <url>` works on any new Mac.
