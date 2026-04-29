return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = "BufReadPost",
  config = function()
    require("nvim-treesitter.configs").setup({
      -- A list of parser names, or "all"
      ensure_installed = {
      "bash", "dockerfile", "gomod", "markdown",
      "json", "lua", "ruby", "terraform", "yaml"
      },

      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = false,

      -- Automatically install missing parsers when entering buffer
      -- Recommendation: set to false if you don"t have `tree-sitter` CLI installed locally
      auto_install = true,

      indent = {
        enable = true
      },

      highlight = {
        -- `false` will disable the whole extension
        enable = true,

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on "syntax" being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = { "markdown" },
      },
    })

    local treesitter_parser_config = require("nvim-treesitter.parsers").get_parser_configs()
    treesitter_parser_config.templ = {
      install_info = {
        url = "https://github.com/vrischmann/tree-sitter-templ.git",
        files = {"src/parser.c", "src/scanner.c"},
        branch = "master",
      },
    }

    vim.treesitter.language.register("templ", "templ")

    -- Neovim 0.12 changed treesitter query-match shape: `match[id]` is now a
    -- list of TSNodes instead of a single node. nvim-treesitter's master
    -- branch is archived and won't be patched, so re-register the directive
    -- used by the markdown injection query (fenced code-block language
    -- detection) to handle both shapes. Without this, opening any .md file
    -- spams `decor_provider_error: attempt to call method 'range'` in
    -- ~/.local/state/nvim/nvim.log.
    local alias_map = {
      ex = "elixir", pl = "perl", sh = "bash", uxn = "uxntal", ts = "typescript",
    }
    pcall(vim.treesitter.query.add_directive, "set-lang-from-info-string!",
      function(match, _, bufnr, pred, metadata)
        local node = match[pred[2]]
        if type(node) == "table" then node = node[#node] end
        if not node then return end
        local alias = vim.treesitter.get_node_text(node, bufnr):lower()
        local ft = vim.filetype.match({ filename = "a." .. alias })
        metadata["injection.language"] = ft or alias_map[alias] or alias
      end,
      { force = true, all = false }
    )
  end
}
