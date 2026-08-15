# Dotfiles

A macOS development environment managed with [chezmoi](https://chezmoi.io).
One `chezmoi init` sets up a new Mac: zsh + Starship, Neovim, tmux, git, and a
curated set of CLI tools and apps via Homebrew. No secrets are stored in this
repo; identity is prompted for at setup, so it is safe to share.

## What's inside

- **Shell** — zsh under `~/.config/zsh` (XDG layout), Starship prompt,
  history + completion, fzf, zoxide, autosuggestions, and syntax highlighting.
- **Editor** — Neovim (lazy.nvim) with LSP, completion, treesitter, telescope,
  and quality-of-life plugins.
- **Terminal** — tmux, iTerm2, a Nerd Font.
- **Git** — templated identity, a global ignore file, and optional SSH commit
  signing that turns on automatically once a signing key is present.
- **Tooling** — mise (runtimes), gh, ripgrep, fd, bat, eza, direnv, and more
  (see `homebrew/Brewfile`).
- **Secrets** — none in the repo; read from the macOS Keychain at runtime
  (see [docs/SECRETS.md](docs/SECRETS.md)).

## Set up a new machine

Prerequisites: macOS with an internet connection. Everything else is installed
by the steps below.

1. **Install Homebrew**, then add it to your PATH as its output instructs:

   ```sh
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. **Install chezmoi and apply the dotfiles.** You will be prompted for your
   name and email (used for git):

   ```sh
   brew install chezmoi
   chezmoi init --apply <your-repo-url>
   ```

   This clones the source to `~/.local/share/chezmoi`, writes
   `~/.config/chezmoi/chezmoi.toml`, and applies every config into place.

   > **No git remote yet?** If the source only exists locally, either push it
   > to a private remote first (see [Backups & remote](#backups--remote)) and
   > use that URL above, or copy `~/.local/share/chezmoi` onto the new machine
   > and run `chezmoi apply` there.

3. **Install packages** from the Brewfile:

   ```sh
   brew bundle --file="$HOME/.local/share/chezmoi/homebrew/Brewfile"
   ```

4. **Restart your shell** (or open a new terminal) so zsh, Starship, and the
   shell plugins load. Open `nvim` once to let it install its plugins.

5. **Add machine-specific secrets when you need them** — API tokens into the
   Keychain, SSH keys, and commit signing. See
   [docs/SECRETS.md](docs/SECRETS.md). None of this is required for the
   environment to work.

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
    mise/config.toml        -> ~/.config/mise/config.toml
    nvim/                   -> ~/.config/nvim
    tmux/tmux.conf          -> ~/.config/tmux/tmux.conf
    starship.toml           -> ~/.config/starship.toml
  private_dot_ssh/          -> ~/.ssh               (config only; keys ignored)
homebrew/Brewfile              package manifest
docs/SECRETS.md                secrets & commit-signing runbook
```

Filenames use chezmoi
[source-state attributes](https://chezmoi.io/reference/source-state-attributes/):
`dot_` becomes a leading `.`, `private_` applies mode `0600`, and `.tmpl` marks
a templated file.

## Day-to-day

```sh
chezmoi diff                 # preview pending changes before applying
chezmoi apply -v             # apply the source to $HOME
chezmoi edit ~/.zshrc        # edit a managed file through the source
chezmoi re-add               # pull local edits back into the source
chezmoi cd                   # open a shell in the source repo
```

Sync packages after editing the Brewfile:

```sh
brew bundle --file="$HOME/.local/share/chezmoi/homebrew/Brewfile"
```

After changing configs, commit them from the source repo:

```sh
chezmoi cd
git add -A && git commit -m "describe your change"
```

## Secrets & commit signing

No secret material lives in this repo. API tokens are read from the macOS
Keychain at shell startup, SSH keys are created per machine, and commit signing
uses your SSH key — activating automatically once that key exists and you
re-run `chezmoi apply`. Full details and exact commands are in
[docs/SECRETS.md](docs/SECRETS.md).

## Backups & remote

The source in `~/.local/share/chezmoi` is a git repo with full history but
**no remote** by default. To back it up and enable one-command setup on other
machines, add a private remote and push:

```sh
chezmoi cd
git remote add origin <your-private-repo-url>
git push -u origin main
```

Once pushed, step 2 above works with that URL on any new Mac.
