return {
  "nvimtools/none-ls.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = "BufReadPre",
  config = function()
    local null_ls = require("null-ls")

    local formatting = null_ls.builtins.formatting
    local diagnostics = null_ls.builtins.diagnostics
    local code_actions = null_ls.builtins.code_actions

    -- Helper function to check if command exists
    local function has_command(cmd)
      return vim.fn.executable(cmd) == 1
    end

    -- Build sources list based on available commands
    local sources = {}

    -- Essential formatters
    if has_command("stylua") then
      table.insert(sources, formatting.stylua)
    end

    if has_command("terraform") then
      table.insert(sources, formatting.terraform_fmt)
    end

    -- Code actions
    table.insert(sources, code_actions.gitsigns)

    -- Only setup if we have sources
    if #sources > 0 then
      null_ls.setup({
        sources = sources,
        debug = false,
      })
    end
  end,
} 