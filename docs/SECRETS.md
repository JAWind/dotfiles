# Secrets & sensitive files

Design goal: `chezmoi apply` on a **bare machine produces a fully working
config with no secrets present**, and each secret is then added by hand into
its designated secure location. No secret material — encrypted or not — is
ever committed to this repo.

Where each kind of secret lives:

| Secret type            | Home                          | How it's read                                  |
|------------------------|-------------------------------|------------------------------------------------|
| API tokens / env vars  | macOS **login Keychain**      | `~/.config/zsh/secrets.zsh` at shell start     |
| SSH private keys        | `~/.ssh/` (mode 0600)         | ssh-agent + Keychain (`UseKeychain`)           |
| Commit signing          | your SSH key (above)          | git signs with `gpg.format = ssh` when present |

## Tokens & environment values (Keychain)

Store on this machine, then reference it. Storing:

    chezmoi secret keyring set --service=homebrew-github-api --user=jeremy
    # native equivalent:
    # security add-generic-password -U -s homebrew-github-api -a jeremy -w

Referencing — add/uncomment a line in `~/.config/zsh/secrets.zsh`:

    export HOMEBREW_GITHUB_API_TOKEN="$(keychain homebrew-github-api)"

The `keychain` helper returns empty (no error) if the item is absent, so a new
machine loads shells fine before any secret exists. Open a new shell (or
`source ~/.config/zsh/secrets.zsh`) after adding one.

Need a secret **inside a generated config file** instead of an env var? Use a
graceful template so a missing value can't break apply — do NOT use the bare
`keyring` function:

    token = {{ output "sh" "-c" "security find-generic-password -s SERVICE -a USER -w 2>/dev/null || true" | trim }}

## SSH keys

Keys are never in the repo (`.chezmoiignore` excludes `id_*`, `*.pub`,
`known_hosts`). `~/.ssh/config` is managed and already wires keys into the
agent + Keychain. On a new machine, create or import the key, then add it:

    ssh-keygen -t ed25519 -C "jeremy.wind@icloud.com" -f ~/.ssh/id_ed25519_personal
    ssh-add --apple-use-keychain ~/.ssh/id_ed25519_personal
    # upload the matching ~/.ssh/id_ed25519_personal.pub to GitHub, etc.

## Commit signing (SSH)

Commits are signed with your **SSH key** — no GPG involved. The git template
only writes the signing config when `~/.ssh/id_ed25519_personal.pub` exists, so
a bare machine still commits fine (just unsigned) until you create the key.

To turn signing on:

    # 1. create the key (see "SSH keys" above) if you haven't
    # 2. re-apply — signing config activates now that the key exists
    chezmoi apply
    # 3. upload the PUBLIC key to GitHub as a *Signing* key
    #    (Settings > SSH and GPG keys > New SSH key > type: Signing)

Optional — enable local verification (`git log --show-signature`):

    printf '%s namespaces="git" %s\n' "$(git config user.email)" \
      "$(cat ~/.ssh/id_ed25519_personal.pub)" > ~/.config/git/allowed_signers

## New-machine bootstrap, end to end

1. Install Homebrew, then `brew bundle --file=homebrew/Brewfile`.
2. `chezmoi init --apply <this-repo>`  → all config applies, no secrets needed.
3. Add secrets as needed: Keychain tokens (above) and SSH key(s).
   Re-run `chezmoi apply` after creating the SSH key to turn on signing.
4. Open a fresh shell so Keychain-backed env vars load.
