# git

Git is configured through a **templated** `~/.gitconfig`, a shared **global
ignore** file, and **SSH commit signing** that switches on when a signing key is
present.

## Identity

Your name and email come from the values you enter at `chezmoi init` (stored in
`~/.config/chezmoi/chezmoi.toml`), so the shared repo never hard-codes anyone's
identity. On a machine whose hostname is `work-laptop`, the template uses your
**work** email instead of your personal one — a simple way to keep work commits
under the right address.

## Core settings

`~/.gitconfig` sets a few sensible defaults:

| Setting               | Value                    | Effect                                    |
|-----------------------|--------------------------|-------------------------------------------|
| `init.defaultBranch`  | `main`                   | new repos start on `main`                 |
| `core.editor`         | `nvim`                   | messages, rebases, etc. open in Neovim    |
| `core.excludesfile`   | `~/.config/git/ignore`   | a global ignore applied to every repo     |
| `pull.rebase`         | `false`                  | `git pull` merges (doesn't rebase)        |
| `color.ui`            | `auto`                   | colored output in the terminal            |

## Global ignore

`~/.config/git/ignore` keeps noise out of *every* repository without a per-project
entry. It covers macOS clutter (`.DS_Store`, `._*`), editor files (`*.swp`,
`.idea/`, `.vscode/`), Python (`__pycache__/`, `.venv/`), Node (`node_modules/`),
local env files (`.env`, `.env.local`), and common build output (`dist/`,
`build/`, `.cache/`).

Add anything you never want tracked, anywhere:

```sh
chezmoi edit ~/.config/git/ignore
chezmoi apply
```

Project-specific ignores still belong in that repo's own `.gitignore`.

## Commit signing (SSH)

Commits and tags are signed with your SSH key, and the config activates
automatically once `~/.ssh/id_ed25519_personal.pub` exists — so a keyless
machine still commits (unsigned) and `chezmoi apply` never fails. The full setup
— creating the key, uploading it to your host as a *Signing* key, and enabling
local verification — is in
[SECRETS.md → Commit signing](SECRETS.md#commit-signing-ssh).

## Machine-local settings (optional)

Not set up by default, but a useful pattern: to keep settings that shouldn't be
shared (a one-off email, a corporate proxy) out of the repo, add an include to
the tracked gitconfig pointing at an **untracked** per-machine file:

```ini
[include]
    path = ~/.config/git/local
```

Then create `~/.config/git/local` by hand on that machine. Anything in it
overrides the shared config and never leaves the machine.

## Customizing

`~/.gitconfig` is generated from a template (`dot_gitconfig.tmpl`), so edit it
through chezmoi rather than in place:

```sh
chezmoi edit ~/.gitconfig      # opens the source template
chezmoi apply
```

Check the effective result with `git config --list --show-origin`.
