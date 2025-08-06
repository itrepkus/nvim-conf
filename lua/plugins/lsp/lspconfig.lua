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
    -- Import required modules
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local lspconfig = require("lspconfig")
    local lsp_remap = require("ignas.lsp_remap")

    -- Setup capabilities with completion support
    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      cmp_nvim_lsp.default_capabilities()
    )

    -- Get the on_attach function from lsp_remap
    local on_attach = lsp_remap.on_attach

    -- Initialize UI components
    require("fidget").setup()
    require("mason").setup()

    -- Define LSP servers to auto-install
    local servers = {
      "bashls",
      "dockerls", 
      "docker_compose_language_service",
      "gopls",
      "lua_ls",
      "terraformls",
      "yamlls",
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
    }

    -- Setup Mason LSP configuration
    require("mason-lspconfig").setup({
      ensure_installed = servers,
      handlers = {
        -- Default handler for most servers
        function(server_name)
          local config = server_configs[server_name] or {}
          config.capabilities = capabilities
          config.on_attach = on_attach

          local ok, _ = pcall(lspconfig[server_name].setup, config)
          if not ok then
            vim.notify("Failed to setup " .. server_name, vim.log.levels.ERROR)
          end
        end,
      }
    })

    -- Setup Lua LSP with custom configuration
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

    -- Configure Ruby LSP server manually (not through Mason)
    -- Using only rubocop as the default Ruby LSP as preferred
    -- Temporarily disabled due to LSP errors - using null-ls instead
    -- lspconfig.rubocop.setup({
    --   capabilities = capabilities,
    --   on_attach = on_attach,
    --   -- Use bundle exec if available, otherwise fallback to system
    --   cmd = function()
    --     if vim.fn.filereadable("Gemfile") == 1 and vim.fn.filereadable("Gemfile.lock") == 1 then
    --       return { "bundle", "exec", "rubocop", "lsp" }
    --     end
    --     return { "rubocop", "lsp" }
    --   end,
    --   -- Add error handling to prevent LSP crashes
    --   init_options = {
    --     -- Suppress configuration warnings
    --     suppressConfigWarnings = true,
    --   },
    -- })
  end
}
