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
        "ruby_lsp",
        "terraformls",
        "yamlls",
    },
      handlers = {
        function(server_name)

          require("lspconfig")[server_name].setup {
            capabilities = capabilities,
            -- on_attach = require("custom.plugins.lsp.opts").on_attach
          }
        end,

      ["lua_ls"] = function ()
        local lspconfig = require("lspconfig")
        lspconfig.lua_ls.setup {
          capabilities = capabilities
        }
      end,

      ["terraformls"] = function ()
        local lspconfig = require("lspconfig")
        lspconfig.terraformls.setup {
          capabilities = capabilities
        }
      end,
      }
    })

    -- local cmp_select = { behavior = cmp.SelectBehavior.Select }

    -- cmp.setup({
    --   snippet = {
    --     expand = function(args)
    --       require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    --     end,
    --   },
    --   mapping = cmp.mapping.preset.insert({
    --     ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    --     ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    --     ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    --     ["<C-Space>"] = cmp.mapping.complete(),
    --   }),
    --   sources = cmp.config.sources({
    --     { name = 'nvim_lsp' },
    --     { name = 'luasnip' }, -- For luasnip users.
    --   }, {
    --     { name = 'buffer' },
    --   })
    -- })

    -- vim.diagnostic.config({
    --   -- update_in_insert = true,
    --   float = {
    --     focusable = false,
    --     style = "minimal",
    --     border = "rounded",
    --     source = "always",
    --     header = "",
    --     prefix = "",
    --   },
    -- })
  end
}
    -- local keymap = vim.keymap -- for conciseness

    -- local opts = { noremap = true, silent = true }
    -- local on_attach = function(client, bufnr)
    --   opts.buffer = bufnr
    --
    --   -- set keybinds
    --   opts.desc = "Show LSP references"
    --   keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references
    --
    --   opts.desc = "Go to declaration"
    --   keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration
    --
    --   opts.desc = "Show LSP definitions"
    --   keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions
    --
    --   opts.desc = "Show LSP implementations"
    --   keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations
    --
    --   opts.desc = "Show LSP type definitions"
    --   keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions
    --
    --   opts.desc = "See available code actions"
    --   keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection
    --
    --   opts.desc = "Smart rename"
    --   keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename
    --
    --   opts.desc = "Show buffer diagnostics"
    --   keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file
    --
    --   opts.desc = "Show line diagnostics"
    --   keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line
    --
    --   opts.desc = "Go to previous diagnostic"
    --   keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer
    --
    --   opts.desc = "Go to next diagnostic"
    --   keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer
    --
    --   opts.desc = "Show documentation for what is under cursor"
    --   keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor
    --
    --   opts.desc = "Restart LSP"
    --   keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
    -- end
-- }
