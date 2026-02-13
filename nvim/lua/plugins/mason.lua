local function ensure_installed(tools)
  -- https://github.com/mason-org/mason-registry
  local registry = require('mason-registry')
  registry.refresh(function(success)
    if not success then return end
    for _, tool in ipairs(tools) do
      local ok, pkg = pcall(registry.get_package, tool)
      if ok and pkg then
        if not pkg:is_installed() and not pkg:is_installing() then pkg:install() end
      else
        vim.notify('Package ' .. tool .. ' not found')
      end
    end
  end)
end

return {
  'williamboman/mason.nvim',
  event = { 'BufWinEnter' },
  config = function()
    local non_lsp_tools = { 'prettierd', 'ruff', 'shfmt', 'stylua' }
    require('mason').setup()
    ensure_installed(non_lsp_tools)
  end,
}
