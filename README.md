# Neovim Configuration

Personal Neovim configuration for development with TypeScript, JavaScript, React, and Markdown in WSL.

## Features

- TypeScript and React IntelliSense using LSP and `blink.cmp`
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

### 5. Install Markdown parsers

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

### 6. Preview Markdown

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

## WSL Clipboard Configuration

This configuration integrates Neovim with the Windows clipboard using:

- `clip.exe`
- `powershell.exe`

It is designed for WSL on Windows and will require changes for native Linux or macOS.

## Plugin Version Management

The repository includes `lazy-lock.json`, which records plugin revisions.

Run `:Lazy sync` to install the configured plugin versions, or `:Lazy update` when intentionally upgrading plugins.

External tools and Mason-managed language servers are not pinned by `lazy-lock.json`.
