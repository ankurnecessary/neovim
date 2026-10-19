return {
  {
    "nvim-telescope/telescope.nvim",
    version = "*",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    keys = {
      {
        "<C-p>",
        function()
          require("telescope.builtin").find_files({
            hidden = true,
            no_ignore = true,
            find_command = {
              "rg", "--files", "--hidden", "--no-ignore",
              "--glob", "!**/.git/**",
              "--glob", "!**/node_modules/**",
            },
            file_ignore_patterns = {
              "^%.git/",
              "/%.git/",
              "^node_modules/",
              "/node_modules/",
            },
          })
        end,
        mode = "n",
        desc = "Find files",
      },
    },
  },
}
