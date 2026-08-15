return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },
  -- Add/change/delete surrounding pairs: ys / cs / ds  (e.g. cs"'  ds(  ysiw))
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },
  -- Commenting (gc / gcc) is built into Neovim 0.10+, so no plugin needed.
}
