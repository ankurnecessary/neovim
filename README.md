# Neovim Configuration

Personal Neovim configuration for development with TypeScript, JavaScript, React, CSS, SCSS, Less, and Markdown in WSL.

## Features

- TypeScript and React IntelliSense using LSP and `blink.cmp`
- CSS, SCSS, and Less IntelliSense using `cssls`
- Language server management using Mason
- Markdown rendering using `render-markdown.nvim`
- Windows clipboard integration through WSL
- Project-wide text search using ripgrep
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

Run `:Lazy sync` to install the configured plugin versions, or `:Lazy update` when intentionally upgrading plugins.

External tools and Mason-managed language servers are not pinned by `lazy-lock.json`.
