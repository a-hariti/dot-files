local lsp_installer = require("nvim-lsp-installer")
local lsp_signature = require("lsp_signature")
local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

lsp_installer.on_server_ready(
  function(server)
    local opts = {
      on_attach = lsp_signature.on_attach(),
      capabilities = capabilities
    }

    if server.name == "emmet_ls" then
      opts.filetypes = {"html", "css", "scss", "javascriptreact", "typescriptreact", "sass", "stylus", "less"}
    end

    if server.name == "tailwindcss" then
      opts.settings = {
        tailwindCSS = {
          classAttributes = {"class", "className", "classList"}
        }
      }
    end

    -- This setup() function will take the provided server configuration and decorate it with the necessary properties
    -- before passing it onwards to lspconfig.
    -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
    server:setup(opts)
  end
)
