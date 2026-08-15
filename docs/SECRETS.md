# Secrets & sensitive files

How this environment handles anything sensitive — API tokens, SSH keys, and the
commit-signing key. This is the detailed reference; for the fast machine setup
path see [STARTUP_GUIDE.md](STARTUP_GUIDE.md).

## Principles

1. **Nothing sensitive is committed** — no plaintext, and no encrypted blobs
   either. The repo only ever contains *references* and *config*.
2. **`chezmoi apply` is always safe on a bare machine.** Every secret lookup
   degrades to empty instead of failing, so the whole config applies before any
   secret exists.
3. **Secrets are added per machine** into native, designated stores: the macOS
   login Keychain for values, `~/.ssh` for keys.
4. **One store, no extra daemons** — no `pass`, no GnuPG. Just the Keychain and
   the ssh-agent macOS already runs.

## Where each secret lives

| Secret type              | Stored in                     | Read by                                               |
|--------------------------|-------------------------------|-------------------------------------------------------|
| API tokens / env values  | macOS **login Keychain**      | `~/.config/zsh/secrets.zsh` at shell startup          |
| SSH private keys         | `~/.ssh/` (mode `0600`)       | ssh-agent + Keychain (`AddKeysToAgent`/`UseKeychain`) |
| Commit-signing key       | your SSH key (same as above)  | git, via `gpg.format = ssh`, when the key exists      |

---

## API tokens & environment values

Secret values — tokens and keys consumed as environment variables — live in the
macOS **login Keychain** and are read into your shell at startup. Nothing is
written into the repo.

### How it works

`~/.config/zsh/secrets.zsh` (applied with mode `0600`) defines one helper and
then reads whatever you ask for:

    keychain() { security find-generic-password -s "$1" -a "${2:-$USER}" -w 2>/dev/null; }

`security find-generic-password … -w` prints the stored password to stdout, and
`2>/dev/null` swallows the "item not found" error so a missing secret yields an
empty string rather than breaking your shell. That is the key property: **reads
are always safe**, whether or not the secret exists yet.

### Storing a secret

Use chezmoi's keyring command (it writes to the login Keychain through the same
`security` layer):

    chezmoi secret keyring set --service=<service> --user="$USER"
    # you are prompted for the value; nothing is echoed

The exact native equivalent, if you prefer it:

    security add-generic-password -U -s <service> -a "$USER" -w
    # -U updates the item in place if it already exists

`<service>` is any name you choose — it is just the lookup key.

### Exposing it to your shell

Add (or uncomment) a line in `~/.config/zsh/secrets.zsh`:

    export HOMEBREW_GITHUB_API_TOKEN="$(keychain homebrew-github-api)"

Then start a new shell, or `source ~/.config/zsh/secrets.zsh`. A few common
examples are pre-stubbed as comments in that file. Because it is chezmoi-managed,
edit it through the source so the change is tracked:

    chezmoi edit ~/.config/zsh/secrets.zsh
    chezmoi apply

The `export` lines name services only — never values — so they are safe to
commit.

### Reading, updating, removing

    # read
    security find-generic-password -s <service> -a "$USER" -w
    chezmoi secret keyring get --service=<service> --user="$USER"

    # update (set it again with -U)
    security add-generic-password -U -s <service> -a "$USER" -w

    # remove
    security delete-generic-password -s <service> -a "$USER"

### Putting a secret inside a generated config file

If a secret must appear in a file chezmoi renders (not just an env var), read it
in the template with a graceful shell call. **Do not** use chezmoi's built-in
`keyring` template function: it *errors* when the item is missing and would break
`chezmoi apply` on a machine that does not have that secret yet.

    token = {{ output "sh" "-c" "security find-generic-password -s <service> -a $USER -w 2>/dev/null || true" | trim }}

The `|| true` guarantees a clean apply even when the secret is absent.

### Keychain is local, not synced

The login Keychain is **not** part of the repo and is not synced or backed up by
this setup. That is deliberate — secrets stay on the machine — but it means:

- On each new machine you re-enter the secrets you actually need.
- Keep an **inventory** of the services you use. The simplest approach: keep an
  `export` line in `secrets.zsh` for each one (they name services, not values),
  so that file doubles as your checklist.

---

## SSH keys

SSH private keys are **never** in the repo — `.chezmoiignore` excludes
`private_dot_ssh/id_*`, `*.pub`, and `known_hosts`. Only `~/.ssh/config` is
managed, and it already enables the agent and stores the passphrase in the
Keychain:

    Host *
        AddKeysToAgent yes
        UseKeychain yes
        IdentitiesOnly yes

### Create and register a key

    ssh-keygen -t ed25519 -C "$(git config user.email)" -f ~/.ssh/id_ed25519_personal
    ssh-add --apple-use-keychain ~/.ssh/id_ed25519_personal   # store passphrase in Keychain
    pbcopy < ~/.ssh/id_ed25519_personal.pub                   # then paste on your git host

Add the **public** key to your host (GitHub: Settings → SSH and GPG keys → New
SSH key, type *Authentication*). Test with:

    ssh -T git@github.com

### Multiple identities

The managed config expects `~/.ssh/id_ed25519_personal`. On a machine that also
needs a work identity, the SSH config template adds a `github-work` host block
(keyed on the hostname `work-laptop`); create `~/.ssh/id_ed25519_work` there the
same way.

### Rotating a key

Generate a new key, register its public half with your host (and as a signing
key, below), remove the old public key from the host, then delete the old files.
If you keep the `id_ed25519_personal` filename, no config change is needed.

---

## Commit signing (SSH)

Commits and tags are signed with your **SSH key** — no GPG. The git template
writes the signing configuration **only when `~/.ssh/id_ed25519_personal.pub`
exists**, so a keyless machine still commits (unsigned) and `chezmoi apply`
never fails.

### What gets configured

Once the key exists, `~/.gitconfig` gains:

    [user]
        signingkey = /Users/<you>/.ssh/id_ed25519_personal.pub
    [gpg]
        format = ssh
    [gpg "ssh"]
        allowedSignersFile = /Users/<you>/.config/git/allowed_signers
    [commit]
        gpgsign = true
    [tag]
        gpgsign = true

### Turn it on

    # after creating the SSH key:
    chezmoi apply

Then upload the **same public key a second time** to your host as a *Signing*
key (GitHub: Settings → SSH and GPG keys → New SSH key, type *Signing*).
Authentication and signing are separate slots, even for the same key.

### Local verification (optional)

To make `git log --show-signature` report a good signature locally, list your
key in an allowed-signers file:

    printf '%s namespaces="git" %s\n' "$(git config user.email)" \
      "$(cat ~/.ssh/id_ed25519_personal.pub)" > ~/.config/git/allowed_signers

Each line is `<principal> namespaces="git" <public-key>`, where the principal is
your signing email. Verify:

    git commit --allow-empty -m "signing test"
    git log --show-signature -1

---

## Adding a machine (secrets checklist)

The base environment applies with no secrets. When you are ready:

1. Create your SSH key and register it (*Authentication*) — see *SSH keys*.
2. `chezmoi apply` to activate signing, then register the key as *Signing*.
3. Store any API tokens in the Keychain and add their `export` lines.
4. Open a fresh shell so the values load.

For full machine setup from scratch, see [STARTUP_GUIDE.md](STARTUP_GUIDE.md).

---

## Command cheat-sheet

    # Keychain values
    chezmoi secret keyring set --service=S --user="$USER"     # store (prompts)
    security find-generic-password -s S -a "$USER" -w         # read
    security add-generic-password -U -s S -a "$USER" -w       # update
    security delete-generic-password -s S -a "$USER"          # remove

    # SSH
    ssh-keygen -t ed25519 -C "$(git config user.email)" -f ~/.ssh/id_ed25519_personal
    ssh-add --apple-use-keychain ~/.ssh/id_ed25519_personal
    ssh -T git@github.com

    # Commit signing
    chezmoi apply                       # activates once the key exists
    git log --show-signature -1         # verify
