# Neovim Configuration

Personal Neovim configuration for development with TypeScript, JavaScript, React, CSS, SCSS, Less, and Markdown in WSL.

## Features

- TypeScript and React IntelliSense using LSP and `blink.cmp`
- CSS, SCSS, and Less IntelliSense using `cssls`
- Language server management using Mason
- Markdown rendering using `render-markdown.nvim`
- Windows clipboard integration through WSL
- Project-wide text search using ripgrep
- Fuzzy file search using Telescope with `Ctrl+P`
- Diagnostic messages in a floating window with `Space` then `e`
- Relative line numbers

## Prerequisites

Install the following tools before configuring Neovim:

- Neovim (tested with `v0.12.0-dev`)
- Git
- Node.js and npm
- A C compiler, such as GCC
- ripgrep (`rg`)
- Tree-sitter CLI

Install Tree-sitter CLI:

```bash
npm install -g tree-sitter-cli
```

Verify:

```bash
tree-sitter --version
```

## Configuration Structure

```text
~/.config/nvim/
ÃÄÄ init.lua
ÃÄÄ lazy-lock.json
ÀÄÄ lua/
    ÀÄÄ plugins/
        ÃÄÄ completion.lua
        ÃÄÄ lsp.lua
        ÀÄÄ markdown.lua
        ÀÄÄ telescope.lua
```

- `init.lua` - Bootstrap, editor options, clipboard, searching, diagnostic shortcut, and plugin loading
- `completion.lua` - Autocomplete configuration using `blink.cmp`
- `lsp.lua` - Language server installation and configuration
- `markdown.lua` - Tree-sitter Markdown parsers and in-editor rendering
- `telescope.lua` - Fuzzy file picker, `Ctrl+P` mapping, and folder exclusions
- `lazy-lock.json` - Locked plugin revisions

The leader key is configured as `Space`, and the local leader key is `\`.

## Installation

### 1. Find the Neovim configuration directory

Run in your WSL terminal:

```bash
nvim --headless +'lua print(vim.fn.stdpath("config"))' +qa
```

Expected output:

```text
/home/your-username/.config/nvim
```

### 2. Clone this repository

If `~/.config/nvim` does not already exist:

```bash
git clone <your-repository-url> ~/.config/nvim
```

If the directory already exists, back up your existing configuration before cloning. Do not overwrite it without reviewing its contents.

### 3. Install Neovim plugins

Start Neovim:

```bash
nvim
```

Run:

```vim
:Lazy sync
```

Wait for installation to finish, then restart Neovim.

### 4. Verify TypeScript IntelliSense

Open a `.ts` or `.tsx` file in a project with TypeScript installed.

Run:

```vim
:LspInfo
```

Verify that `ts_ls` is attached.

If the TypeScript language server is missing, run:

```vim
:MasonInstall typescript-language-server
```

Restart Neovim if necessary.

### 5. Verify CSS, SCSS, and Less IntelliSense

The `cssls` language server provides code completion, diagnostics, and hover documentation for CSS, SCSS, and Less.

Open a `.css`, `.scss`, or `.less` file.

Run:

```vim
:LspInfo
```

Verify that `cssls` is attached.

If the language server is missing, install it:

```vim
:MasonInstall css-lsp
```

Restart Neovim and reopen the stylesheet.

Verify the detected filetype:

```vim
:set filetype?
```

For an SCSS file, the expected output is:

```text
filetype=scss
```

Check attached language servers:

```vim
:lua print(vim.inspect(vim.lsp.get_clients({ bufnr = 0 })))
```

Look for `cssls`.

Test autocomplete by typing:

```scss
.container {
  display: fl
}
```

You should receive suggestions such as `flex` and `flow-root`.

**Note:** CSS Modules class-name autocomplete inside `.tsx` files is not provided by `cssls` alone. Additional tooling is required for that functionality.

### 6. Install Markdown parsers

Inside Neovim:

```vim
:lua require("nvim-treesitter").install({ "markdown", "markdown_inline" }):wait(120000)
```

Verify both parsers:

```vim
:lua print(pcall(vim.treesitter.language.add, "markdown"))
:lua print(pcall(vim.treesitter.language.add, "markdown_inline"))
```

Both commands should begin with `true true` when successful.

### 7. Preview Markdown

Open a Markdown file:

```bash
nvim README.md
```

Toggle rendering:

```vim
:RenderMarkdown toggle
```

This renders Markdown inside Neovim. It is not an exact GitHub browser preview.

## IntelliSense Shortcuts

| Shortcut | Action |
|---|---|
| `Tab` | Accept completion suggestion |
| `Shift + Tab` | Select previous suggestion |
| `K` | Show type information |
| `gd` | Go to definition |
| `grr` | Find references |
| `grn` | Rename symbol |
| `gra` | Show code actions |

The Tab behaviour depends on the mappings configured in `lua/plugins/completion.lua`.

## Find Files (VS Code Ctrl+P)

Telescope provides a fuzzy file picker, configured in `lua/plugins/telescope.lua`.

Start Neovim from your project directory so the picker searches that directory:

```bash
cd /path/to/project
nvim .
```

In normal mode, press `Ctrl+P` and type part of a filename.

| Shortcut | Action |
|---|---|
| `Ctrl+P` in normal mode | Open the file picker |
| `Ctrl+N` / `Ctrl+P` inside the picker | Select the next / previous result |
| `Enter` | Open the selected file |
| `Esc` twice | Close the picker from insert mode |

The picker includes hidden files and excludes `.git` and `node_modules` directories at the project root and in nested directories. It also respects ripgrep's usual ignore rules.

The exclusions are configured in the `find_files` call:

```lua
require("telescope.builtin").find_files({
  hidden = true,
  file_ignore_patterns = {
    "^%.git/",
    "/%.git/",
    "^node_modules/",
    "/node_modules/",
  },
})
```

These exclusions use Lua patterns, so `%` escapes the dot in `.git`.

After adding the Telescope plugin file, restart Neovim and run `:Lazy sync` to install Telescope and its `plenary.nvim` dependency. Restart Neovim after changing the mapping or exclusions.

## Project-Wide Search

This configuration uses ripgrep (`rg`) for searching across project files.

Search for text from inside Neovim:

```vim
:grep SEARCH_STRING .
```

View and navigate the results:

| Command | Action |
|---|---|
| `:copen` | Open search results in the quickfix window |
| `:cnext` | Jump to the next result |
| `:cprev` | Jump to the previous result |
| `:cclose` | Close the quickfix window |

Searches use smart-case matching and include hidden files, while respecting ripgrep's usual ignore rules.

Use a project's `.rgignore` file for additional search exclusions.

## Diagnostics

Language servers can report errors and warnings directly in Neovim.

To inspect a diagnostic, place your cursor on the affected line in normal mode and press `Space`, then `e`. This opens a floating window with the diagnostic message, including errors marked with `E` in the gutter. Press `Esc` to dismiss it.

The shortcut is defined in `init.lua` as `<leader>e`, with `Space` configured as the leader key. You can also run the equivalent command:

```vim
:lua vim.diagnostic.open_float()
```

To view all diagnostics in the current buffer:

```vim
:lua vim.diagnostic.setloclist()
```

| Shortcut | Action |
|---|---|
| `Space` then `e` | Show diagnostic message in a floating window |
| `]d` | Next diagnostic |
| `[d` | Previous diagnostic |
| `]D` | Next error |
| `[D` | Previous error |

The `E` and `W` indicators represent errors and warnings, respectively.

If language-server diagnostics are missing, check the attached servers with `:LspInfo`.

## Language Server Configuration

Language servers are declared in `lua/plugins/lsp.lua`:

```lua
ensure_installed = {
  "ts_ls",
  "cssls",
},
automatic_enable = true,
```

| Language server | Supported languages | Mason package |
|---|---|---|
| `ts_ls` | TypeScript, JavaScript, TSX, JSX | `typescript-language-server` |
| `cssls` | CSS, SCSS, Less | `css-lsp` |

The `ensure_installed` configuration automatically requests installation of these language servers through `mason-lspconfig.nvim`.

Installing a server manually through Mason does not update `lsp.lua`. Add new language servers to `ensure_installed` when you want them included in future installations.

## WSL Clipboard Configuration

This configuration integrates Neovim with the Windows clipboard using:

- `clip.exe`
- `powershell.exe`

It is designed for WSL on Windows and will require changes for native Linux or macOS.

## Plugin Version Management

The repository includes `lazy-lock.json`, which records plugin revisions.

Plugin update checking is enabled automatically. Run :Lazy sync to synchronize installed plugins with the configuration and lockfile, or :Lazy update to intentionally upgrade plugins.

External tools and Mason-managed language servers are not pinned by `lazy-lock.json`.
