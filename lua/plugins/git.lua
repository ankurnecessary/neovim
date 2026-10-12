return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 500,
      },
      on_attach = function(bufnr)
        local gs = require("gitsigns")

        local function map(key, action, desc)
          vim.keymap.set("n", key, action, {
            buffer = bufnr,
            desc = desc,
          })
        end

        map("<leader>gb", function()
          gs.blame_line({ full = true })
        end, "Show Git blame")

        map("<leader>gp", gs.preview_hunk, "Preview Git change")
        map("<leader>gt", gs.toggle_current_line_blame, "Toggle inline blame")
      end,
    },
  },
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    keys = {
      {
        "<leader>gd",
        "<cmd>DiffviewOpen<CR>",
        desc = "Show Git diffs",
      },
      {
        "<leader>gh",
        "<cmd>DiffviewFileHistory %<CR>",
        desc = "Show current file history",
      },
    },
  },
}
