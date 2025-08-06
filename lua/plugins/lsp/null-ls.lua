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

    -- Helper function to check if Ruby project has bundle setup
    local function has_bundle_setup()
      return vim.fn.filereadable("Gemfile") == 1 and 
             has_command("bundle") and 
             vim.fn.filereadable("Gemfile.lock") == 1
    end

    -- Helper function to test if bundle exec works
    local function bundle_exec_works()
      local handle = io.popen("bundle exec rubocop --version 2>/dev/null")
      if handle then
        local result = handle:read("*a")
        handle:close()
        return result and result ~= "" and not result:match("Could not find")
      end
      return false
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

    -- Ruby linting with Rubocop
    if has_bundle_setup() and bundle_exec_works() then
      -- Use bundle exec for project-specific gems
      local ok, rubocop_source = pcall(function()
        return diagnostics.rubocop.with({
          command = "sh",
          args = { "-c", "bundle exec rubocop --format json --stdin $FILENAME 2>/dev/null" },
          timeout = 10000,
        })
      end)
      
      if ok then
        table.insert(sources, rubocop_source)
      end
    elseif has_command("rubocop") then
      -- Fallback to system rubocop
      local ok, rubocop_source = pcall(function()
        return diagnostics.rubocop.with({
          args = { "--format", "json", "--stdin", "$FILENAME" },
        })
      end)
      
      if ok then
        table.insert(sources, rubocop_source)
      end
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