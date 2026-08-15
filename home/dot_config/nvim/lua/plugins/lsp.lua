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
      local servers = { "lua_ls", "pyright", "bashls", "jsonls", "yamlls" }
      require("mason-lspconfig").setup({ ensure_installed = servers })

      -- Give every server the completion capabilities from nvim-cmp.
      -- vim.lsp.config exists on Neovim 0.11+ (mason-lspconfig v2 auto-enables).
      if vim.lsp.config then
        vim.lsp.config("*", {
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
        })
      end

      -- Buffer-local keymaps once a server attaches.
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
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
