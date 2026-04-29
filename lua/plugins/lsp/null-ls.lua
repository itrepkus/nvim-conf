return {
  "nvimtools/none-ls.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = "BufReadPre",
  config = function()
    -- Import required modules with error handling
    local ok, null_ls = pcall(require, "null-ls")
    if not ok then
      vim.notify("Failed to load null-ls", vim.log.levels.ERROR)
      return
    end

    local formatting = null_ls.builtins.formatting
    local diagnostics = null_ls.builtins.diagnostics
    local code_actions = null_ls.builtins.code_actions

    -- Build sources with conditional loading
    local sources = {}

    -- Check if executables are available using vim.fn.executable
    if vim.fn.executable("stylua") == 1 then
      table.insert(sources, formatting.stylua)
    end

    if vim.fn.executable("terraform") == 1 then
      table.insert(sources, formatting.terraform_fmt)
    end

    -- Prefer bundle exec rubocop when inside a Bundler project
    if vim.fn.executable("bundle") == 1 then
      table.insert(sources, diagnostics.rubocop.with({
        command = "bundle",
        args = { "exec", "rubocop", "--format", "json", "--stdin", "$FILENAME" },
        timeout = 10000,
        condition = function(utils)
          return utils.root_has_file("Gemfile")
        end,
      }))
    end

    -- Fallback to system rubocop when available
    if vim.fn.executable("rubocop") == 1 then
      table.insert(sources, diagnostics.rubocop.with({
        args = { "--format", "json", "--stdin", "$FILENAME" },
        condition = function(utils)
          return not utils.root_has_file("Gemfile")
        end,
      }))
    end

    table.insert(sources, code_actions.gitsigns)

    -- Only setup if we have sources
    null_ls.setup({
      sources = sources,
      debug = false,
      -- Add performance optimizations
      update_in_insert = false,
      on_attach = function(_client, _bufnr) end,
    })
  end,
}
