# Startup Guide

A quick guide to get this environment running on a new Mac. Run the steps in
order. For how secrets, SSH keys, and commit signing work in depth, see
[SECRETS.md](SECRETS.md).

## Prerequisites

macOS with an administrator account and an internet connection.

## 1. Install Homebrew

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Then run the two `brew shellenv` lines it prints so `brew` is on your PATH (on
Apple Silicon they reference `/opt/homebrew`).

## 2. Get the source

- **From a git remote:** have the repository URL ready (used in the next step).
- **Local-only:** copy `~/.local/share/chezmoi` from your other machine to the
  same path here, then run the next step without a URL.

## 3. Install chezmoi and apply

```sh
brew install chezmoi
chezmoi init --apply <your-repo-url>     # omit the URL if the source is already local
```

You'll be prompted for your name and email (used for git). chezmoi writes all
managed files into `$HOME`. Preview changes anytime with `chezmoi diff`.

## 4. Install the core tools

The core Brewfile is CLI-only and needs no admin (once Homebrew is present).
It uses two third-party taps (Terraform, and tflint's); trust them once first,
or `brew bundle` will refuse to load them:

```sh
brew trust hashicorp/tap
brew trust terraform-linters/tap
brew bundle --file="$HOME/.local/share/chezmoi/homebrew/Brewfile"
```

GUI apps are optional and kept separate because they may need admin:

```sh
brew bundle --file="$HOME/.local/share/chezmoi/homebrew/Brewfile.casks"
```

No administrator rights? See [Non-admin / managed machines](#non-admin--managed-machines).

## 5. Start the configured shell

```sh
exec zsh
```

Run this **after** step 4 — the shell config expects the tools to be installed.
You should get the Starship prompt.

## 6. Initialize Neovim

```sh
nvim
```

Let lazy.nvim install plugins on first launch, then quit with `:q`.

## You're up

The core environment is ready. Add these when you need them:

- **SSH keys** — required for git over SSH and for commit signing.
  See [SECRETS.md → SSH keys](SECRETS.md#ssh-keys).
- **Commit signing** — activates automatically once an SSH key exists; just
  re-run `chezmoi apply`. See [SECRETS.md → Commit signing](SECRETS.md#commit-signing-ssh).
- **API tokens** — stored in the macOS Keychain, never the repo.
  See [SECRETS.md → API tokens](SECRETS.md#api-tokens--environment-values).
- **Python** — managed by `uv`: `uv python install 3.13` (interpreters),
  `uv init` / `uv add <pkg>` / `uv run <cmd>` (projects & venvs).

## Non-admin / managed machines

The dotfiles and every CLI tool install **without administrator rights**. Admin
only enters in two places:

- **Installing Homebrew itself** creates `/opt/homebrew`, which needs `sudo`. If
  Homebrew is already present (common on IT-managed Macs), skip step 1 — the
  core Brewfile then installs with no admin at all.
- **GUI apps** (`Brewfile.casks`) normally install into `/Applications`, which a
  non-admin user can't write. Install them into your home folder instead:

  ```sh
  HOMEBREW_CASK_OPTS="--appdir=~/Applications" \
    brew bundle --file="$HOME/.local/share/chezmoi/homebrew/Brewfile.casks"
  ```

  Docker Desktop is the exception — it installs a privileged helper and needs
  admin regardless. Have IT/MDM deploy it, or use a rootless alternative like
  Colima (`brew install colima`, no admin).

If you have neither admin nor Homebrew, ask IT to install Homebrew (or deploy
the core tools via MDM); everything else here is user-level.

## Quick check

```sh
which starship zoxide uv fzf     # all resolve
git config user.email            # shows your email
chezmoi diff                     # no unexpected changes
```
