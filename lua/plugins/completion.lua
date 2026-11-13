return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = {
      {
        "mattn/emmet-vim",
        init = function()
          vim.g.user_emmet_install_global = 0
          vim.g.user_emmet_settings = {
            typescriptreact = { extends = "jsx" },
            javascriptreact = { extends = "jsx" },
          }
        end,
        config = function()
          vim.keymap.set("i", "<Plug>(expand-emmet-tab)", function()
            local keys = vim.fn["emmet#expandAbbr"](0, "")
            if keys ~= "" then
              vim.api.nvim_feedkeys(keys, "n", false)
            end
          end)
        end,
      },
    },
    opts = {
      keymap = {
        preset = "default",
        ["<C-l>"] = { "snippet_forward", "fallback" },
        ["<C-h>"] = { "snippet_backward", "fallback" },
        ["<Tab>"] = {
          function(cmp)
            if not vim.tbl_contains({ "html", "javascriptreact", "typescriptreact" }, vim.bo.filetype) then
              return
            end
            local before = vim.api.nvim_get_current_line():sub(1, vim.api.nvim_win_get_cursor(0)[2])
            -- Expand markup abbreviations, not arbitrary JS identifiers or rafce.
            local abbr = before:match("(%S+)$") or ""
            local tag = abbr:match("^([%a][%w]*)")
            local tags = { "a", "p", "div", "span", "section", "article", "main", "header", "footer", "nav", "aside", "h1", "h2", "h3", "h4", "h5", "h6", "ul", "ol", "li", "button", "input", "form", "label", "textarea", "select", "option", "img", "br", "hr", "table", "thead", "tbody", "tr", "th", "td", "strong", "em" }
            if tag and vim.tbl_contains(tags, tag) and vim.fn["emmet#isExpandable"]() == 1 then
              cmp.hide()
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>(expand-emmet-tab)", true, false, true), "m", false)
              return true
            end
          end,
          "select_and_accept",
          "fallback",
        },
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
