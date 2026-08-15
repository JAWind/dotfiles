# Dotfiles (chezmoi)

Managed with [chezmoi](https://chezmoi.io). Source layout uses `.chezmoiroot = home`,
so everything under `home/` maps to `$HOME`.

## Layout

    home/                       -> $HOME
      dot_zshenv                -> ~/.zshenv        (XDG dirs + ZDOTDIR)
      dot_editorconfig          -> ~/.editorconfig
      dot_gitconfig.tmpl        -> ~/.gitconfig     (templated identity)
      dot_config/
        zsh/dot_zshrc           -> ~/.config/zsh/.zshrc
        git/ignore              -> ~/.config/git/ignore  (global gitignore)
        mise/config.toml        -> ~/.config/mise/config.toml
        nvim/                   -> ~/.config/nvim   (lazy.nvim)
        tmux/tmux.conf          -> ~/.config/tmux/tmux.conf
        starship.toml           -> ~/.config/starship.toml
      private_dot_ssh/          -> ~/.ssh           (config only; keys ignored)
    homebrew/Brewfile           Package manifest

## Common tasks

    chezmoi diff                # preview pending changes
    chezmoi apply -v            # apply to $HOME
    chezmoi edit ~/.zshrc       # edit a managed file via the source
    chezmoi re-add              # pull local edits back into the source

    brew bundle --file=homebrew/Brewfile   # install all packages
