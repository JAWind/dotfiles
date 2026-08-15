return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Explorer (nvim-tree)" },
    },
    -- Disable netrw so nvim-tree is the only file explorer.
    init = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
    opts = {},
    config = function(_, opts)
      require("nvim-tree").setup(opts)
    end,
  },
}
