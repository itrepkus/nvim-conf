return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    { "j-hui/fidget.nvim", tag = "legacy" }
  },
  config = function()
    -- Import required modules with error handling
    local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    if not ok_cmp then
      vim.notify("Failed to load cmp_nvim_lsp", vim.log.levels.ERROR)
      return
    end

    local ok_lsp, lspconfig = pcall(require, "lspconfig")
    if not ok_lsp then
      vim.notify("Failed to load lspconfig", vim.log.levels.ERROR)
      return
    end

    -- Load lsp_remap to register LspAttach autocmd
    require("ignas.lsp_remap")

    -- Setup capabilities with completion support
    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      cmp_nvim_lsp.default_capabilities()
    )

    -- Initialize UI components
    local ok_fidget, fidget = pcall(require, "fidget")
    if ok_fidget then
      fidget.setup()
    end
    require("mason").setup()

    -- Define LSP servers to auto-install
    local servers = {
      "bashls",
      "dockerls",
      "docker_compose_language_service",
      "gopls",
      "terraformls",
      "yamlls",
      "lua_ls",
      "jsonls",
      "ruby_lsp",
    }

    -- Custom server configurations
    local server_configs = {
      -- Go language server with enhanced settings
      gopls = {
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
      },
      -- Lua language server with custom configuration
      lua_ls = {
        settings = {
          Lua = {
            workspace = {
              library = {
                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
              },
              checkThirdParty = false,
            },
            telemetry = { enable = false },
          }
        },
      },
    }

    -- Setup Mason LSP configuration
    require("mason-lspconfig").setup({
      ensure_installed = servers,
      handlers = {
        -- Default handler for most servers
        function(server_name)
          local config = server_configs[server_name] or {}
          config.capabilities = capabilities

          local ok, _ = pcall(lspconfig[server_name].setup, config)
          if not ok then
            vim.notify("Failed to setup " .. server_name, vim.log.levels.ERROR)
          end
        end,
      }
    })
  end
}
