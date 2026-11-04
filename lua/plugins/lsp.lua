return {
  {
    "mason-org/mason.nvim",
    opts = {},
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = { "ts_ls", "cssls", },
      automatic_enable = { exclude = { "ts_ls", "tsc", "tsgo" } },
    },
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)
      require("config.typescript").setup()
    end,
  },
}
