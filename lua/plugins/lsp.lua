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
      ensure_installed = { "ts_ls", "cssls", "tailwindcss" },
      automatic_enable = { exclude = { "ts_ls", "tsc", "tsgo" } },
    },
    config = function(_, opts)
      vim.lsp.config("cssls", {
        init_options = { provideFormatter = true, handledSchemas = { "file" } },
        on_init = function(client)
          -- JSON-RPC positional parameters: one argument containing the URI list.
          client:notify("css/customDataChanged", {
            { vim.uri_from_fname(vim.fn.stdpath("config") .. "/css-data/tailwind.json") },
          })
        end,
      })
      require("mason-lspconfig").setup(opts)
      require("config.typescript").setup()
    end,
  },
}
