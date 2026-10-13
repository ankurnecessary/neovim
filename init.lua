-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- To get line numbers in the editor
vim.opt.number = true
vim.opt.relativenumber = true

-- Indentation: 2 spaces per level
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true

-- To enable syntax highlighting
vim.cmd("syntax enable")

-- START:To make clipboard shareable with windows
vim.g.clipboard = {
  name = "WslClipboard",
  copy = {
    ["+"] = { "clip.exe" },
    ["*"] = { "clip.exe" },
  },
  paste = {
    ["+"] = {
      "powershell.exe",
      "-NoProfile",
      "-Command",
      "[Console]::Out.Write((Get-Clipboard -Raw) -replace \"`r\", \"\")",
    },
    ["*"] = {
      "powershell.exe",
      "-NoProfile",
      "-Command",
      "[Console]::Out.Write((Get-Clipboard -Raw) -replace \"`r\", \"\")",
    },
  },
  cache_enabled = 0,
}

vim.opt.clipboard = "unnamedplus"
-- END:To make clipboard shareable with windows

-- START: VS Code Ctrl+Shift+F equivalent:
-- :grep SEARCH_STRING .
--
-- Search results:
-- :copen  -> open quickfix list
-- :cnext  -> next occurrence
-- :cprev  -> previous occurrence
--
-- Put additional search exclusions in the project's .rgignore.
vim.opt.grepprg = "rg --vimgrep --smart-case --hidden"
vim.opt.grepformat = "%f:%l:%c:%m"
-- END: VS Code Ctrl+Shift+F equivalent:

-- START: To show the error message with the help of <space> and then <e> press
-- This will help when E is present in the gutter.
vim.keymap.set("n", "<leader>e", function()
  vim.diagnostic.open_float()
end, { desc = "Show diagnostic message" })
-- END: Error message

-- START: Format shortcut
-- Enable shortcut <space> + <f> to format the whole document
vim.keymap.set("n", "<leader>f", function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Format current file" })
-- END: format shortcut

-- Toggle comments using Neovim's built-in commenting mappings.
vim.keymap.set("n", "<leader>/", "gcc", { remap = true, desc = "Toggle line comment" })
vim.keymap.set("x", "<leader>/", "gc", { remap = true, desc = "Toggle selected comments" })

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- add your plugins here
    { import = "plugins" },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})
