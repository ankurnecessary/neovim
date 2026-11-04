local M = {}

-- Resolve the nearest installed TypeScript from the file, not Neovim's cwd.
function M.find(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  local dir = name ~= '' and vim.fs.dirname(name) or vim.fn.getcwd()
  while dir do
    local package = dir .. '/node_modules/typescript/package.json'
    if vim.fn.filereadable(package) == 1 then
      local ok, data = pcall(vim.json.decode, table.concat(vim.fn.readfile(package), '\n'))
      if ok and type(data.version) == 'string' then
        return {
          major = tonumber(data.version:match('^(%d+)')),
          root = dir,
          command = dir .. '/node_modules/.bin/tsc',
        }
      end
    end
    local parent = vim.fs.dirname(dir)
    dir = parent ~= dir and parent or nil
  end
end

function M.setup()
  local root_dir = vim.lsp.config.ts_ls.root_dir
  vim.lsp.config('ts_ls', {
    root_dir = function(bufnr, on_dir)
      local ts = M.find(bufnr)
      if not ts or not ts.major or ts.major < 7 then
        root_dir(bufnr, function(root)
          on_dir(ts and ts.root or root)
        end)
      end
    end,
  })
  vim.lsp.config('tsc', {
    -- Use the project's own compiler, avoiding a global TypeScript version.
    cmd = function(dispatchers, config)
      return vim.lsp.rpc.start({ config.root_dir .. '/node_modules/.bin/tsc', '--lsp', '--stdio' }, dispatchers)
    end,
    root_dir = function(bufnr, on_dir)
      local ts = M.find(bufnr)
      if ts and ts.major and ts.major >= 7 then
        -- Reuse ts_ls's Deno checks before selecting the local TS installation.
        root_dir(bufnr, function()
          if vim.fn.executable(ts.command) == 1 then
            on_dir(ts.root)
          else
            vim.notify('TypeScript native executable missing: run your project package manager install', vim.log.levels.WARN)
          end
        end)
      end
    end,
  })
  vim.lsp.enable({ 'ts_ls', 'tsc' })
end

return M
