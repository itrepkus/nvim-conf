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
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      cmp_nvim_lsp.default_capabilities()
    )

    -- Get the on_attach function from lsp_remap
    local lsp_remap = require("ignas.lsp_remap")
    local on_attach = lsp_remap.on_attach

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
        "solargraph",
      },
      handlers = {
        -- Default handler for most servers
        function(server_name)
          local ok, lspconfig = pcall(require, "lspconfig")
          if not ok then
            vim.notify("Failed to load lspconfig", vim.log.levels.ERROR)
            return
          end

          local ok, server = pcall(lspconfig[server_name].setup, {
            capabilities = capabilities,
            on_attach = on_attach,
          })
          if not ok then
            vim.notify("Failed to setup " .. server_name, vim.log.levels.ERROR)
          end
        end,

        -- Custom handlers for specific servers
        ["solargraph"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.solargraph.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
              solargraph = {
                diagnostics = true,
                useBundler = true,
                checkGemVersion = false,
              }
            },
          })
        end,

        ["gopls"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.gopls.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
              gopls = {
                analyses = {
                  unusedparams = true,
                  shadow = true,
                },
                staticcheck = true,
                gofumpt = true,
                usePlaceholders = true,
                hints = {
                  assignVariableTypes = true,
                  compositeLiteralFields = true,
                  compositeLiteralTypes = true,
                  functionTypeParameters = true,
                  parameterNames = true,
                  rangeVariableTypes = true,
                },
              },
            },
          })
        end,
      }
    })

    -- Set up lua_ls separately to ensure our settings are applied
    -- Note: .luarc.json file will handle the globals configuration
    local lspconfig = require("lspconfig")
    
    lspconfig.lua_ls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        Lua = {
          workspace = {
            library = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
            },
          },
          telemetry = { enable = false },
        }
      },
    })
  end
}
