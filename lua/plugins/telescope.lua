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
