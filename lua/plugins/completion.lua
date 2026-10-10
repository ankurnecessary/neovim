return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    opts = {
      keymap = {
        preset = "default",
	["<Tab>"] = { "select_and_accept", "fallback" },
	["<S-Tab>"] = { "select_prev", "fallback" },
      },
      completion = {
        documentation = {
          auto_show = true,
        },
      },
      sources = {
        default = {
          "lsp",
          "path",
          "snippets",
          "buffer",
        },
      },
    },
  },
}
