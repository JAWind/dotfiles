# Neovim

A modest, understandable Neovim setup managed with
[lazy.nvim](https://github.com/folke/lazy.nvim) — closer to a hand-rolled
"kickstart" config than a full distribution. Every plugin lives in its own file
so it is easy to read, change, or remove. This document lists what you get out
of the box.

## Layout

```
~/.config/nvim/
  init.lua                     loads the three config modules below
  lua/config/
    options.lua                editor options (see "Defaults")
    keymaps.lua                global key mappings (see "Keybindings")
    lazy.lua                   bootstraps lazy.nvim, loads lua/plugins/*
  lua/plugins/                 one file per plugin (or small group)
    colorscheme.lua            catppuccin
    treesitter.lua             syntax + indentation
    telescope.lua              fuzzy finder (+ fzf-native)
    lsp.lua                    LSP client + mason
    cmp.lua                    completion + snippets
    editing.lua                autopairs, surround, which-key
    ui.lua                     statusline, git signs, indent guides
    filetree.lua               nvim-tree explorer
```

Add your own plugin by dropping a new file in `lua/plugins/` that returns a
lazy.nvim spec — it is picked up automatically (see "Customizing").

## Defaults

The leader key is **Space**. Notable options set in `options.lua`:

- Absolute + relative line numbers; sign column always shown.
- Two-space indentation, `expandtab`, `smartindent`; no line wrap.
- Case-insensitive search that becomes case-sensitive when you type a capital.
- System clipboard integration (`unnamedplus`) — yank/paste shares with macOS.
- `scrolloff=8` (keep context around the cursor); splits open right/below.
- 24-bit color (`termguicolors`).

## Keybindings

**General**

| Key          | Action                     |
|--------------|----------------------------|
| `<leader>`   | Space (leader key)         |
| `<leader>w`  | Save file (`:w`)           |
| `<leader>q`  | Quit (`:q`)                |

**Window navigation**

| Key                | Action                              |
|--------------------|-------------------------------------|
| `<C-h/j/k/l>`      | Move to the split left/down/up/right |

**Find (Telescope)**

| Key          | Action                          |
|--------------|---------------------------------|
| `<leader>ff` | Find files                      |
| `<leader>fg` | Live grep (search file contents) |
| `<leader>fb` | Switch between open buffers      |

**Explorer & diagnostics**

| Key          | Action                                  |
|--------------|-----------------------------------------|
| `<leader>e`  | Toggle the file explorer (nvim-tree)    |
| `<leader>d`  | Show diagnostics for the line (float)   |

**LSP** (active once a language server attaches to the buffer)

| Key           | Action              |
|---------------|---------------------|
| `gd`          | Go to definition    |
| `gr`          | List references     |
| `K`           | Hover documentation |
| `<leader>rn`  | Rename symbol       |
| `<leader>ca`  | Code action         |

**Completion** (insert mode, while the menu is open)

| Key             | Action                    |
|-----------------|---------------------------|
| `<C-Space>`     | Trigger completion        |
| `<CR>`          | Confirm selection         |
| `<Tab>` / `<S-Tab>` | Next / previous item  |

**Editing**

| Key                    | Action                                        |
|------------------------|-----------------------------------------------|
| `gc` / `gcc`           | Toggle comment for a motion / line (built-in) |
| `ys{motion}{char}`     | Add a surrounding pair (nvim-surround)        |
| `cs{old}{new}`         | Change a surrounding pair                     |
| `ds{char}`             | Delete a surrounding pair                     |

Press `<leader>` (and pause) to see available mappings via **which-key**.

## Plugins

**Editing & language support**

- **nvim-treesitter** — syntax-tree-based highlighting and indentation.
- **nvim-lspconfig** + **mason.nvim** / **mason-lspconfig.nvim** — the LSP client
  plus a manager that installs and wires up language servers.
- **nvim-cmp** (`cmp-nvim-lsp`, `cmp-buffer`, `cmp-path`) — autocompletion.
- **LuaSnip** + **friendly-snippets** — snippet engine and a ready-made snippet
  library.
- **nvim-autopairs** — auto-close brackets and quotes.
- **nvim-surround** — add/change/delete surrounding pairs.

**Navigation & search**

- **telescope.nvim** (+ **plenary.nvim**, **telescope-fzf-native**) — fuzzy
  finder for files, text, buffers, and more.
- **nvim-tree.lua** — sidebar file explorer (`<leader>e`).

**Interface**

- **catppuccin** — colorscheme (mocha).
- **lualine.nvim** — statusline.
- **gitsigns.nvim** — added/changed/removed markers in the gutter.
- **indent-blankline** — vertical indent guides.
- **which-key.nvim** — popup of available keybindings.
- **nvim-web-devicons** — file-type icons (needs a Nerd Font, which the Brewfile
  installs).

Commenting uses Neovim's **built-in** `gc` (0.10+), so there is no comment plugin.

## Language servers

Node-free and Python-focused. Installed automatically via Mason on first launch:

| Server   | Purpose                                                  |
|----------|----------------------------------------------------------|
| `lua_ls` | Lua language server (prebuilt binary)                    |
| `pylsp`  | Python intelligence — completion, hover, go-to-definition |
| `ruff`   | Python linting, formatting, and code actions (Ruff)      |

Ruff handles linting/formatting while pylsp provides code intelligence; pylsp's
own linters are disabled so they don't overlap with Ruff, and Ruff's hover is
disabled so pylsp owns hover. `pylsp` installs via pip (Mason uses a `python3`
from the Command Line Tools or uv); `lua_ls` and `ruff` are prebuilt binaries —
no Node required.

JSON, YAML, and Bash keep Treesitter highlighting but have **no LSP by default**
(their servers are Node-based). To enable them, install Node and add `jsonls`,
`yamlls`, and/or `bashls` to the `servers` list in `lua/plugins/lsp.lua`.

Add or change servers by editing that list, or browse and install with `:Mason`.

## Treesitter languages

Parsers installed for: `lua`, `python`, `bash`, `json`, `yaml`, `toml`, `markdown`.
Add more in `lua/plugins/treesitter.lua` (`ensure_installed`) or run
`:TSInstall <language>`.

## First launch & updating

The first time you run `nvim`, lazy.nvim installs all plugins and Mason installs
the language servers (and `telescope-fzf-native` compiles). Let it finish, then
restart nvim.

| Command       | Purpose                                        |
|---------------|------------------------------------------------|
| `:Lazy`       | Plugin manager UI (install/update/clean)       |
| `:Lazy update`| Update plugins                                 |
| `:Mason`      | Manage language servers, formatters, linters   |
| `:TSUpdate`   | Update treesitter parsers                       |
| `:checkhealth`| Diagnose configuration/tooling issues          |

## Customizing

Every file in `lua/plugins/` that returns a spec is loaded automatically. To add
a plugin, create a file there — for example `lua/plugins/example.lua`:

```lua
return {
  {
    "author/plugin-name",
    event = "VeryLazy",     -- lazy-load trigger (optional)
    opts = {},              -- passed to the plugin's setup()
  },
}
```

Then restart nvim (or run `:Lazy`) to install it. Edit configs through chezmoi
so changes are tracked:

```sh
chezmoi edit ~/.config/nvim/lua/plugins/example.lua
chezmoi apply
```
