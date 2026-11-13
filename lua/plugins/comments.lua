return {
  {
    "folke/ts-comments.nvim",
    opts = {},
    config = function(_, opts)
      vim.treesitter.language.register("tsx", "typescriptreact")
      vim.treesitter.language.register("javascript", "javascriptreact")
      require("ts-comments").setup(opts)
    end,
  },
}
