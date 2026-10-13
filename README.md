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
- Git change markers and inline blame using Gitsigns
- Git diffs and file history using Diffview
- Diagnostic messages in a floating window with `Space` then `e`
- Asynchronous LSP formatting with `Space f`
- Toggle line or selection comments with `Space /`
- Two-space indentation using spaces instead of tabs
- Absolute and relative line numbers

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
|-- init.lua
|-- lazy-lock.json
`-- lua/
    `-- plugins/
        |-- completion.lua
        |-- git.lua
        |-- lsp.lua
        |-- markdown.lua
        `-- telescope.lua
```

- `init.lua` - Bootstrap, editor options, clipboard, searching, diagnostic and formatting shortcuts, and plugin loading
- `completion.lua` - Autocomplete configuration using `blink.cmp`
- `lsp.lua` - Language server installation and configuration
- `markdown.lua` - Tree-sitter Markdown parsers and in-editor rendering
- `telescope.lua` - Fuzzy file picker, `Ctrl+P` mapping, and folder exclusions
- `git.lua` - Gitsigns inline blame and change previews, plus Diffview diffs and file history
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

## Shortcuts

The leader key is `Space`; press leader sequences one key at a time in normal mode. The local leader is `\`, with no custom local-leader mappings currently configured.

### Configured mappings

| Shortcut | Mode / context | Action | Configuration |
|---|---|---|---|
| `Space e` | Normal | Show diagnostics for the current line in a floating window | `init.lua` |
| `Space f` | Normal | Format the current file asynchronously using an attached LSP | `init.lua` |
| `Space /` | Normal | Toggle a comment on the current line | `init.lua` |
| `Space /` | Visual | Toggle comments on the selected lines | `init.lua` |
| `Ctrl+P` | Normal | Find files with Telescope | `lua/plugins/telescope.lua` |
| `Space g b` | Normal, Gitsigns attached | Show detailed blame for the current line | `lua/plugins/git.lua` |
| `Space g p` | Normal, Gitsigns attached | Preview the changed block under the cursor | `lua/plugins/git.lua` |
| `Space g t` | Normal, Gitsigns attached | Toggle inline blame | `lua/plugins/git.lua` |
| `Space g d` | Normal | Open Git diffs | `lua/plugins/git.lua` |
| `Space g h` | Normal | Show the current file's commit history | `lua/plugins/git.lua` |
| `Tab` | Insert, completion menu | Select and accept a completion suggestion; fall back to normal Tab behavior when unavailable | `lua/plugins/completion.lua` |
| `Shift+Tab` | Insert, completion menu | Select the previous suggestion; fall back when unavailable | `lua/plugins/completion.lua` |

### Completion preset shortcuts

`blink.cmp` uses its `default` preset, with the Tab mappings overridden above. These shortcuts apply in insert mode:

| Shortcut | Action |
|---|---|
| `Ctrl+Space` | Show completion; show or hide its documentation |
| `Ctrl+Y` | Select and accept a completion suggestion |
| `Ctrl+E` | Cancel completion |
| `Ctrl+N` / `Down` | Select the next suggestion |
| `Ctrl+P` / `Up` | Select the previous suggestion |
| `Ctrl+B` / `Ctrl+F` | Scroll completion documentation up / down |
| `Ctrl+K` | Show or hide signature help |

### File picker controls

These are Telescope defaults inside the picker, rather than custom editor mappings:

| Shortcut | Action |
|---|---|
| `Ctrl+N` / `Ctrl+P` | Select the next / previous result in insert mode |
| `Enter` | Open the selected file |
| `Esc`, then `Esc` | Leave insert mode, then close the picker |

### Neovim LSP and diagnostic defaults

These built-in mappings are separate from the custom mappings above. LSP actions require an attached server that supports the action.

| Shortcut | Mode | Action |
|---|---|---|
| `K` | Normal, LSP attached | Show hover documentation |
| `Ctrl+]` | Normal, LSP attached | Go to definition using the LSP tag function |
| `grr` | Normal | Find references |
| `grn` | Normal | Rename symbol |
| `gra` | Normal / Visual | Show code actions |
| `gri` | Normal | Go to implementation |
| `grt` | Normal | Go to type definition |
| `gO` | Normal | List document symbols |
| `Ctrl+S` | Insert | Show signature help |
| `]d` / `[d` | Normal | Jump to the next / previous diagnostic |
| `]D` / `[D` | Normal | Jump to the last / first diagnostic in the buffer |

`gd` is not mapped to LSP definition lookup in this configuration. Use `Ctrl+]` when the LSP tag function is available.

## Indentation and Formatting

Press `Space /` in normal mode to comment or uncomment the current line. Select lines in Visual mode and press the same shortcut to toggle comments on the selection. This uses Neovim's built-in `gcc` / `gc` mappings and the filetype's `commentstring`; no additional plugin is required.

`init.lua` sets `tabstop`, `shiftwidth`, and `softtabstop` to `2`, with `expandtab` enabled. New indentation uses spaces, with two spaces per level; existing tabs are not automatically converted. Filetype plugins or project settings may override these defaults.

In normal mode, press `Space f` to format the whole file. This calls `vim.lsp.buf.format({ async = true })` and requires an attached language server with formatting support. No standalone formatter such as Prettier is configured here, so this shortcut does not guarantee formatting for every supported language.

## Find Files (VS Code Ctrl+P)

Telescope provides a fuzzy file picker, configured in `lua/plugins/telescope.lua`.

Start Neovim from your project directory so the picker searches that directory:

```bash
cd /path/to/project
nvim .
```

In normal mode, press `Ctrl+P` and type part of a filename.

See [Shortcuts](#shortcuts) for file picker navigation.

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

## Running Shell Commands and Terminals

Run a shell command with `:!`:

```vim
:!pnpm install
:!mkdir -p src/components
:!git status
```

Press `Enter` after the output to return to editing when prompted. Save any relevant buffer changes with `:w` before running commands that read files from disk.

For an interactive shell or a long-running process such as a development server, open a terminal:

```vim
:terminal
```

Press `i` if needed to enter terminal input mode, then run commands normally:

```bash
pnpm dev
mkdir -p src/components
```

To open the terminal in a horizontal split:

```vim
:split | terminal
```

Commands start in Neovim's current working directory. Check it with `:pwd` or change it before launching a command or terminal:

```vim
:cd /path/to/project
```

An already-running terminal shell keeps its own working directory; use `cd` inside that shell to change it.

### Terminal controls

These are built-in controls, with no custom mappings required:

| Keys / command | Context | Action |
|---|---|---|
| `Ctrl+\\`, then `Ctrl+N` | Terminal input | Return to normal mode to navigate buffers and windows |
| `i` | Normal mode in the terminal buffer | Return to terminal input |
| `Ctrl+C` | Terminal input | Interrupt the foreground command |
| `exit` | At the shell prompt | Exit the terminal shell |

## Git Integration

Git plugins are configured in `lua/plugins/git.lua`:

- `gitsigns.nvim` shows added, changed, and deleted lines in the gutter, previews changed blocks (hunks), and displays Git blame information.
- `diffview.nvim` provides side-by-side diffs and the current file's commit history. It uses `plenary.nvim` as a dependency.

After adding the plugin configuration, restart Neovim and run:

```vim
:Lazy sync
```

Open a tracked file inside a Git repository. Inline blame is enabled by default and appears after the cursor stays on a line for 500 milliseconds.

See [Shortcuts](#shortcuts) for Git mappings. Gitsigns mappings are available in buffers where Gitsigns has attached.

You can also open and close Diffview with commands:

```vim
:DiffviewOpen
:DiffviewFileHistory %
:DiffviewClose
```

`%` selects the current file for the history view. Use `:DiffviewClose` to return from either the diff or history view.

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

See [Shortcuts](#shortcuts) for diagnostic navigation.

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

Plugin update checking is enabled automatically. Run `:Lazy sync` to synchronize installed plugins with the configuration and lockfile, or `:Lazy update` to intentionally upgrade plugins.

External tools and Mason-managed language servers are not pinned by `lazy-lock.json`.

`.nvimlog` is a generated Neovim runtime log and is excluded by `.gitignore`. Keep it out of version control; share relevant excerpts separately when troubleshooting. Configuration files and `lazy-lock.json` are the useful files to commit.
