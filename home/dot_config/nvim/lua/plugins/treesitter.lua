return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "python", "bash", "json", "yaml", "toml", "markdown" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
}
