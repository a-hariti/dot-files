local prettier = function()
  return {
    exe = "prettier",
    args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0), "--single-quote --print-width 120 --tab-width 4"},
    stdin = true
  }
end

require("formatter").setup(
  {
    logging = true,
    filetype = {
      html = {prettier},
      javascript = {prettier},
      typescript = {prettier},
      typescriptreact = {prettier},
      css = {prettier},
      json = {prettier},
      rust = {
        function()
          return {exe = "rustfmt", args = {"--emit=stdout"}, stdin = true}
        end
      },
      lua = {
        function()
          return {
            exe = "luafmt",
            args = {"--indent-count", 2, "--stdin"},
            stdin = true
          }
        end
      }
    }
  }
)
