return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "j-hui/fidget.nvim"
  },
  config = function()
    -- import cmp-nvim-lsp plugin
    local cmp = require("cmp")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      cmp_nvim_lsp.default_capabilities()
    )

    require("fidget").setup()
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = {
        "bashls",
        "dockerls",
        "docker_compose_language_service",
        "gopls",
        "lua_ls",
        "terraformls",
        "yamlls",
    },
      handlers = {
        function(server_name)

          require("lspconfig")[server_name].setup {
            capabilities = capabilities,
          }
        end,

      ["solargraph"] = function ()
        local lspconfig = require("lspconfig")
        lspconfig.solargraph.setup {
          capabilities = capabilities,
        }
      end,
      },
      settings = {
        Lua = {
          diagnostics = { globals = {'vim'} }
        },
      },
    })
  end
}
