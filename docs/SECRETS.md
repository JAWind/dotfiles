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
| GPG / signing key       | GnuPG keyring / YubiKey       | imported out-of-band; git uses it for signing  |

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

## GPG / commit signing

Import your private key from backup or a YubiKey (never store it here):

    gpg --import /path/to/backup/private-key.asc   # or plug in the YubiKey

The non-secret signing config (which key id, sign by default) can live in the
tracked gitconfig; only the key material is provisioned out-of-band.

## New-machine bootstrap, end to end

1. Install Homebrew, then `brew bundle --file=homebrew/Brewfile`.
2. `chezmoi init --apply <this-repo>`  → all config applies, no secrets needed.
3. Add secrets as needed: Keychain tokens (above), SSH key(s), GPG import.
4. Open a fresh shell so Keychain-backed env vars load.
