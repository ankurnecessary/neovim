# Neo Vim configuration

1. Find the Neovim configuration directory

   Run this directly in your WSL terminal:

   ```bash
   nvim --headless +'lua print(vim.fn.stdpath("config"))' +qa
   ```

   Expected output:
   /home/something/.config/nvim i.e. ~/.config/nvim

2. Copy the content of this repo at the path found in last step.

3. Run `nvim` in termnal and then `:Lazy sync` inside the nvim editor. This will Install plugins from your configuration.

4. Mason installs TypeScript LSP. May require a restart.

5. IntelliSense ready

## One important detail: Your WSL clipboard configuration

Your init.lua currently contains:
vim.g.clipboard = {
name = "WslClipboard",
-- uses clip.exe and powershell.exe
}

This works in WSL on Windows, but won't work unchanged on native Linux or macOS. If your second machine also uses WSL, you can keep it as-is.

For cross-platform use, you can later make this configuration conditional on the operating environment.

## Copying content of this repo

```bash 
git clone <your-repository-url> ~/.config/nvim
nvim
```
