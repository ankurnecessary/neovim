# Neovim Configuration

Personal Neovim configuration for development with TypeScript, JavaScript, React, CSS, SCSS, Less, and Markdown in WSL.

## Features

- Automatic bracket and quote pairing, plus closing HTML and JSX/TSX tags
- TypeScript and React IntelliSense using LSP and `blink.cmp`
- React component snippet (`rafce`) for `.tsx` files
- CSS, SCSS, and Less IntelliSense using `cssls`
- Tailwind CSS class completion, hover information, and diagnostics
- Language server management using Mason
- Markdown rendering using `render-markdown.nvim`
- Browser-based Markdown preview using `markdown-preview.nvim`
- Windows clipboard integration through WSL
- Save images from the Windows clipboard as PNG files with `:Screenshot`
- Project-wide text search using ripgrep
- Copy all occurrences of the current search pattern with `:CopyMatches`
- Fuzzy file search using Telescope with `Ctrl+P`
- Git change markers and inline blame using Gitsigns
- Git diffs and file history using Diffview
- Diagnostic messages in a floating window with `Space` then `e`
- Asynchronous Prettier formatting with `Space f`, with LSP fallback
- Toggle line or selection comments with `Space /`
- Two-space indentation using spaces instead of tabs
- Absolute and relative line numbers
- Indentation-based code folding, with folds expanded when opening files

## Prerequisites

Install the following tools before configuring Neovim:

- Neovim (tested with `v0.12.0-dev`)
- Git
- Node.js and npm
- Prettier (required for `Space f` formatting of supported files, including Markdown; install locally in each project or globally for use outside projects)
- A C compiler, such as GCC
- ripgrep (`rg`)
- Tree-sitter CLI

Install Prettier globally so formatting also works outside projects with a local installation:

```bash
npm install --global prettier
prettier --version
```

Project-local Prettier takes precedence. See [Indentation and Formatting](#indentation-and-formatting) for project installation and configuration.

The `:Screenshot` command requires WSL with `wslpath` and Windows `powershell.exe` available on PATH. It uses the Windows Forms and Drawing assemblies to read an image from the Windows clipboard.

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
|-- lua/
|   `-- plugins/
|       |-- autopairs.lua
|       |-- completion.lua
|       |-- formatting.lua
|       |-- git.lua
|       |-- lsp.lua
|       |-- markdown-preview.lua
|       |-- markdown.lua
|       `-- telescope.lua
`-- snippets/
    `-- typescriptreact.json
```

- `init.lua` - Bootstrap, editor options, clipboard, searching, diagnostic and formatting shortcuts, and plugin loading
- `completion.lua` - Autocomplete configuration using `blink.cmp`
- `autopairs.lua` - Automatic bracket/quote pairing and HTML/JSX/TSX closing tags
- `formatting.lua` - Prettier filetype configuration using `conform.nvim`
- `snippets/typescriptreact.json` - Custom React component snippet for TSX files
- `lsp.lua` - Language server installation and configuration
- `markdown.lua` - Tree-sitter Markdown parsers and in-editor rendering
- `markdown-preview.lua` - Browser-based Markdown preview through Windows `explorer.exe`
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

Verify that `tsc` is attached for TypeScript 7 or newer, or `ts_ls` for TypeScript 6 and older.

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

For a browser preview, run these commands from a Markdown buffer:

```vim
:MarkdownPreview
:MarkdownPreviewStop
:MarkdownPreviewToggle
```

The browser preview plugin builds with `npm install` in its `app` directory during plugin installation. It uses Windows `explorer.exe` to open the preview URL, so that executable must be available from WSL. `mkdp_auto_close = 0` keeps the preview open when switching to another buffer; use `:MarkdownPreviewStop` to stop it explicitly.

## Shortcuts

The leader key is `Space`; press leader sequences one key at a time in normal mode. The local leader is `\`, with no custom local-leader mappings currently configured.

### Configured mappings

In normal mode, place the cursor on a symbol and press `gd` to go to its definition using the attached language server. Press `Ctrl+O` to return.

| Shortcut | Mode / context | Action | Configuration |
|---|---|---|---|
| `gd` | Normal, LSP attached | Go to definition (`Ctrl+O` to return) | `init.lua` |
| `Space e` | Normal | Show diagnostics for the current line in a floating window | `init.lua` |
| `Space f` | Normal | Format asynchronously with Prettier, falling back to an attached LSP when no formatter is available | `init.lua`, `lua/plugins/formatting.lua` |
| `Space /` | Normal | Toggle a comment on the current line | `init.lua` |
| `Space /` | Visual | Toggle comments on the selected lines | `init.lua` |
| `Ctrl+P` | Normal | Find files with Telescope | `lua/plugins/telescope.lua` |
| `Space g b` | Normal, Gitsigns attached | Show detailed blame for the current line | `lua/plugins/git.lua` |
| `Space g p` | Normal, Gitsigns attached | Preview the changed block under the cursor | `lua/plugins/git.lua` |
| `Space g t` | Normal, Gitsigns attached | Toggle inline blame | `lua/plugins/git.lua` |
| `Space g d` | Normal | Open Git diffs | `lua/plugins/git.lua` |
| `Space g h` | Normal | Show the current file's commit history | `lua/plugins/git.lua` |
| `Tab` | Insert, HTML/JSX/TSX abbreviation or completion menu | Select and accept a completion suggestion; fall back to normal Tab behavior when unavailable | `lua/plugins/completion.lua` |
| `Shift+Tab` | Insert, completion menu | Select the previous suggestion; fall back when unavailable | `lua/plugins/completion.lua` |
| `Ctrl+L` | Insert, active snippet | Jump to the next snippet placeholder; fall back when unavailable | `lua/plugins/completion.lua` |
| `Ctrl+H` | Insert, active snippet | Jump to the previous snippet placeholder; fall back when unavailable | `lua/plugins/completion.lua` |

### Custom commands

| Command | Action | Configuration |
|---|---|---|
| `:Screenshot` | Save the Windows clipboard image to a timestamped PNG in `./screenshots/` | `init.lua` |
| `:CopyMatches` | Copy every occurrence of the current search pattern in the current buffer to the clipboard | `init.lua` |
| `:MarkdownPreview` | Open the current Markdown file's browser preview | `lua/plugins/markdown-preview.lua` |
| `:MarkdownPreviewStop` | Stop the browser preview | `lua/plugins/markdown-preview.lua` |
| `:MarkdownPreviewToggle` | Toggle the browser preview | `lua/plugins/markdown-preview.lua` |

See [Saving Screenshots](#saving-screenshots), [Copying Search Matches](#copying-search-matches), and [Preview Markdown](#7-preview-markdown) for usage. These commands have no custom keyboard shortcuts assigned. Browser preview commands are available in Markdown buffers.

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

`gd` is a custom LSP go-to-definition mapping. `Ctrl+]` also works when the LSP tag function is available.

### Folding shortcuts

These built-in shortcuts work in normal mode:

| Shortcut | Action |
|---|---|
| `za` | Toggle the fold under the cursor |
| `zc` / `zo` | Close / open the fold under the cursor |
| `zM` / `zR` | Close / open all folds |
| `zj` / `zk` | Move to the next / previous fold |

## Automatic Brackets and Closing Tags

`nvim-autopairs` inserts matching closing brackets and quotes as you type in insert mode. For example, typing `(`, `[`, or `{` inserts `()`, `[]`, or `{}`, leaving the cursor between the pair. Typing the matching closing bracket moves past the existing closer; Backspace between an empty pair removes both characters.

`nvim-ts-autotag` closes HTML and JSX/TSX tags when you type the opening tag's `>`. For example, typing `<div>` adds `</div>` and leaves the cursor between the tags. Automatic tag renaming is disabled. No new shortcut is needed.

Restart Neovim and run `:Lazy sync` to install the plugins. The Tree-sitter setup requests `html`, `javascript`, `typescript`, and `tsx` parsers in addition to the Markdown parsers. Tag closing requires the appropriate parser to finish installing. To install or retry them explicitly:

```vim
:lua require("nvim-treesitter").install({ "html", "javascript", "typescript", "tsx" }):wait(120000)
```

Reopen the file after installation. If tags do not close, check `:set filetype?`: `.html`, `.jsx`, and `.tsx` files should use `html`, `javascriptreact`, and `typescriptreact`, respectively. Use `:checkhealth nvim-treesitter` to investigate parser installation problems.

## Emmet Tag Expansion

In HTML, JSX, or TSX insert mode, type a common HTML tag abbreviation such as `p`, `div`, or `span` and press `Tab` to expand it. `p` becomes `<p></p>` with the cursor inside. Common Emmet combinations such as `div.container` and `ul>li*3` are also supported when they start with a recognized HTML tag.

This uses `mattn/emmet-vim` through the Blink Tab mapping. Markup expansion takes precedence for recognized HTML tag prefixes; other text retains completion acceptance and normal Tab fallback, including `rafce`. Use `Ctrl+Y` to accept completion explicitly when a name also matches a tag. No default Emmet keybindings are installed.

Restart Neovim and run `:Lazy sync` to install the dependency.

## React Component Snippets

The custom `rafce` snippet creates a React arrow function component with a default export in `.tsx` files. Blink loads it from `snippets/typescriptreact.json` using Neovim's built-in snippet engine; no additional snippet plugin is required.

After adding or changing the snippet, restart Neovim. To use it:

1. Open a file such as `MyComponent.tsx`.
2. In insert mode, type `rafce`. If the completion menu does not appear, press `Ctrl+Space`.
3. Select the React component snippet and press `Tab` to expand it.
4. Edit the component name, then press `Ctrl+L` to move into the JSX body. Use `Ctrl+H` to return to the previous placeholder.

The component name defaults to the filename without its extension and is mirrored in the default export. Use a valid PascalCase name such as `MyComponent`.

For `MyComponent.tsx`, the initial expansion is:

```tsx
const MyComponent = () => {
  return (
    <div></div>
  );
};

export default MyComponent;
```

If the snippet is missing, run `:set filetype?` and verify that the filetype is `typescriptreact`. The snippet is currently configured for TSX files only. Add more entries to `snippets/typescriptreact.json` to create additional triggers.

## Code Folding

`init.lua` enables indentation-based folding (`foldmethod = "indent"`). Files open with folds expanded (`foldlevel` and `foldlevelstart` are `99`). Place the cursor inside an indented block and press `za` to collapse or expand it. Use `zM` to collapse all folds and `zR` to expand them.

Folds follow indentation, so flat or unindented code will not produce useful folds. No additional plugin or Tree-sitter parser is required.

## Indentation and Formatting

Press `Space /` in normal mode to comment or uncomment the current line. Select lines in Visual mode and press the same shortcut to toggle comments on the selection. This uses Neovim's built-in `gcc` / `gc` mappings, enhanced by `ts-comments.nvim` to detect JSX/TSX context: JSX tags use `{/* ... */}` while JavaScript/TypeScript statements use `//`. Detection requires the `javascript` parser for JSX or the `tsx` parser for TSX. After installing the plugin with `:Lazy sync`, restart Neovim. If detection fails, check `:set filetype?` for `javascriptreact` or `typescriptreact` and ensure the matching parser is installed.

`init.lua` sets `tabstop`, `shiftwidth`, and `softtabstop` to `2`, with `expandtab` enabled. New indentation uses spaces, with two spaces per level; existing tabs are not automatically converted. Filetype plugins or project settings may override these defaults.

In normal mode, press `Space f` to format the whole file asynchronously using `conform.nvim`. Prettier is configured for JavaScript, JSX, TypeScript, TSX, CSS, SCSS, Less, HTML, JSON, JSONC, YAML, Markdown, and MDX. If no external formatter is available, Conform falls back to an attached LSP with formatting support. Formatter errors can be inspected with `:ConformInfo`.

Restart Neovim and run `:Lazy sync` after adding the plugin. Prettier must also be installed in your project (for example, `pnpm add -D prettier` in the app directory, or `pnpm add -Dw prettier` at a pnpm workspace root). Conform searches for a local `node_modules/.bin/prettier` upward from the file being formatted, then falls back to Prettier on PATH.

Prettier discovers configuration relative to the file being formatted. You can keep `.prettierrc.json` in `apps/admin`: files under that app use it even when Neovim starts at the monorepo root. Files outside the app use their own applicable configuration or Prettier defaults. A root config is optional for shared workspace defaults.

For single-quoted strings and imports while keeping double-quoted JSX attributes, use this in the app's `.prettierrc.json`:

```json
{
  "singleQuote": true,
  "jsxSingleQuote": false
}
```

`Space f` passes `--single-quote` and `--jsx-single-quote` to Prettier, preferring single quotes for strings and JSX attributes even if the project's config specifies double quotes. Other project formatting settings still apply. Prettier may choose double quotes to avoid escaping apostrophes; JSON requires double quotes. Formatting runs only when requested with `Space f`.

### Formatting Markdown

Open a `.md` or `.mdx` file and press `Space f` in normal mode, then save with `:w`. Markdown and MDX use Prettier through Conform, separately from Markdown rendering and browser preview.

For Markdown files outside a project with a local Prettier installation, install Prettier on PATH:

```bash
npm install --global prettier
```

Project-local Prettier takes precedence over the global installation. If formatting does not run, check `:ConformInfo` and verify `:set filetype?` reports `markdown` or `markdown.mdx`. Restart Neovim from a terminal where `prettier --version` works if the executable is not detected.

## Find Files (VS Code Ctrl+P)

Telescope provides a fuzzy file picker, configured in `lua/plugins/telescope.lua`.

Start Neovim from your project directory so the picker searches that directory:

```bash
cd /path/to/project
nvim .
```

In normal mode, press `Ctrl+P` and type part of a filename.

See [Shortcuts](#shortcuts) for file picker navigation.

The picker includes hidden and ignored files, including `.env` files excluded by `.gitignore`. It excludes `.git` and `node_modules` directories at the project root and in nested directories. This affects file discovery only; Git's ignore rules remain unchanged. Project-wide text search still respects ignore rules.

The exclusions are configured in the `find_files` call:

```lua
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

## Copying Search Matches

`:CopyMatches` uses the current search pattern (the `/` register) to find matches throughout the current buffer and copy the matched text to the system clipboard, one match per line.

1. Search for the text or Vim regular expression you want to copy, for example `/TODO`, then press `Enter`.
2. Run:

   ```vim
   :CopyMatches
   ```

The command prints the number of matches copied. It includes multiple occurrences on the same line and preserves duplicates in buffer order. It copies only the matched text, rather than entire matching lines. For example, searching with `/\\vTODO|FIXME` copies each occurrence of `TODO` or `FIXME`.

Matching is performed separately on each line, so patterns spanning multiple lines are not supported. If nothing matches, the clipboard is replaced with an empty string. In this WSL configuration, clipboard copying uses `clip.exe`; ensure Windows clipboard integration is available.

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
  "tailwindcss",
},
automatic_enable = { exclude = { "ts_ls", "tsc", "tsgo" } },
```

| Language server | Supported languages | Mason package |
|---|---|---|
| `ts_ls` | TypeScript 6 and older; JavaScript, TSX, JSX | `typescript-language-server` |
| `tsc` | TypeScript 7 and newer; JavaScript, TSX, JSX | Uses the project’s installed TypeScript |
| `cssls` | CSS, SCSS, Less | `css-lsp` |
| `tailwindcss` | Tailwind CSS, HTML, JSX, TSX and other supported templates | `tailwindcss-language-server` |

The `ensure_installed` configuration requests installation of `ts_ls`, `cssls`, and `tailwindcss` through `mason-lspconfig.nvim`.

`lua/config/typescript.lua` selects the TypeScript server automatically per project. It finds the nearest installed `node_modules/typescript/package.json` upward from the file being edited. TypeScript 7 and newer use that installation’s `node_modules/.bin/tsc --lsp --stdio`; older versions use `ts_ls`. Only the matching server attaches, and the TypeScript installation directory separates clients for packages using different versions. Deno projects are excluded using the upstream root checks.

Install project dependencies before opening files. After changing a project’s TypeScript version, restart Neovim so the server is selected again. If the native executable is missing, run your package manager’s install command. Projects without a local TypeScript installation retain the legacy server’s bundled fallback. This addresses the TypeScript 7 `provides no tsserver.js` warning without downgrading project dependencies; unrelated server errors still need investigation.

Run `:LspInfo` to verify the selected server. If `tsc` is unavailable as an LSP configuration, update `nvim-lspconfig` with `:Lazy update nvim-lspconfig` and restart Neovim.

Installing a server manually through Mason does not update `lsp.lua`. Add new language servers to `ensure_installed` when you want them included in future installations.

## Tailwind CSS Support

Mason installs the Tailwind CSS language server automatically. Restart Neovim and allow installation to finish; if needed, run `:MasonInstall tailwindcss-language-server`. Reopen a Tailwind project and use `:LspInfo` to check that `tailwindcss` attaches.

The project must have Tailwind installed and an entry point the server can detect: typically a Tailwind CSS import in a CSS file for v4, or a Tailwind configuration file for v3. Class completion uses the existing Blink completion menu; `K` shows hover information and `Space e` shows diagnostics.

`css-data/tailwind.json` registers known Tailwind directives such as `@apply`, `@theme`, and `@source` with `cssls`. This removes unknown-at-rule warnings for those names while keeping CSS validation and warnings for unrecognized directives enabled. The custom data applies to CSS, SCSS, and Less buffers, including outside Tailwind projects; it recognizes directive names rather than validating their Tailwind semantics. Tailwind's language server supplies additional Tailwind checks where it attaches.

## WSL Clipboard Configuration

This configuration integrates Neovim with the Windows clipboard using:

- `clip.exe`
- `powershell.exe`

It is designed for WSL on Windows and will require changes for native Linux or macOS.

## Saving Screenshots

The `:Screenshot` command in `init.lua` saves an image already present in the Windows clipboard. It does not capture the screen itself.

1. Take a screenshot with Windows Snipping Tool (for example, `Win+Shift+S`) or copy an image to the Windows clipboard.
2. In Neovim, check the destination directory with `:pwd`. Use `:cd /path/to/project` if needed.
3. Run:

   ```vim
   :Screenshot
   ```

The command creates a `screenshots/` directory under Neovim's current working directory and saves a PNG named `screenshot-YYYYMMDD-HHMMSS.png`, for example:

```text
screenshots/screenshot-20261018-143025.png
```

It converts the destination to a Windows path using `wslpath -w`, then runs `powershell.exe` to read and save the clipboard image. On success, a notification shows the saved file's full path. The command does not insert an image link into the current buffer.

If saving fails, the notification reports a WSL path conversion error, a PowerShell error (including an empty or non-image clipboard), or that the PNG was not created. Ensure the clipboard contains an image and that `wslpath` and `powershell.exe` are available from WSL. Native Linux and macOS require a different implementation.

## Plugin Version Management

The repository includes `lazy-lock.json`, which records plugin revisions.

Plugin update checking is enabled automatically. Run `:Lazy sync` to synchronize installed plugins with the configuration and lockfile, or `:Lazy update` to intentionally upgrade plugins.

External tools and Mason-managed language servers are not pinned by `lazy-lock.json`.

`.nvimlog` is a generated Neovim runtime log and is excluded by `.gitignore`. Keep it out of version control; share relevant excerpts separately when troubleshooting. Configuration files and `lazy-lock.json` are the useful files to commit.
