return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "williamboman/mason.nvim", build = ":MasonUpdate", config = true },
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- Node-free, Python-focused servers:
      --   lua_ls  Lua (prebuilt binary)
      --   pylsp   Python intelligence: completion / hover / go-to-def (pure Python)
      --   ruff    Python lint / format / code actions (Rust binary)
      local servers = { "lua_ls", "pylsp", "ruff", "terraformls" }
      require("mason-lspconfig").setup({ ensure_installed = servers })

      if vim.lsp.config then
        vim.lsp.config("*", {
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
        })
        -- Let Ruff own linting; disable pylsp's overlapping linters.
        vim.lsp.config("pylsp", {
          settings = {
            pylsp = {
              plugins = {
                pycodestyle = { enabled = false },
                pyflakes = { enabled = false },
                mccabe = { enabled = false },
              },
            },
          },
        })
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          -- Let pylsp provide hover; Ruff handles lint/format/code-actions.
          if client and client.name == "ruff" then
            client.server_capabilities.hoverProvider = false
          end
          local function map(keys, fn)
            vim.keymap.set("n", keys, fn, { buffer = args.buf })
          end
          map("gd", vim.lsp.buf.definition)
          map("gr", vim.lsp.buf.references)
          map("K", vim.lsp.buf.hover)
          map("<leader>rn", vim.lsp.buf.rename)
          map("<leader>ca", vim.lsp.buf.code_action)
        end,
      })
    end,
  },
}
