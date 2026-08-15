# ~/.config/zsh/secrets.zsh
# Loads secrets from the macOS login Keychain into the environment.
#
# IMPORTANT: this file contains NO secrets and neither does the dotfiles repo.
# It only READS from Keychain. Every lookup stays silent and empty until you
# store the secret on THIS machine, so `chezmoi apply` always succeeds on a
# fresh box. To store a secret (per machine):
#
#     chezmoi secret keyring set --service=<service> --user=<user>
#     # equivalent native command:
#     # security add-generic-password -U -s <service> -a <user> -w
#
# Then uncomment / add the matching export line below.

# keychain <service> [user]  -> prints the secret, or nothing if it isn't set.
keychain() { security find-generic-password -s "$1" -a "${2:-$USER}" -w 2>/dev/null; }

# ── Your secrets (uncomment and adjust once stored in Keychain) ──────
# export HOMEBREW_GITHUB_API_TOKEN="$(keychain homebrew-github-api)"
# export OPENAI_API_KEY="$(keychain openai)"
# export NPM_TOKEN="$(keychain npm)"
# export ANTHROPIC_API_KEY="$(keychain anthropic)"
