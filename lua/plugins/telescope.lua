return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		{ "nvim-telescope/telescope-ui-select.nvim" },
	},
	keys = {

		{ "<leader>pf", "<cmd>lua require('telescope.builtin').find_files()<cr>" },
		{
			"<C-M-p>",
			"<cmd>lua require('telescope.builtin').builtin(require('telescope.themes').get_dropdown({}))<cr>",
		},
		{ "<C-g>", "<cmd>lua require('telescope.builtin').live_grep()<cr>" },
		{ "<leader>pb", "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>" },
	},
  opts = function()
		local actions = require("telescope.actions")
		local theme = require("telescope.themes")
    return {
      pickers = {
        find_files = {
          find_command = {
            "rg",
            "--files",
            "--hidden",
            "-L",
            "--glob", "!.git/*",
            "--glob", "!node_modules/*",
            "--glob", "!vendor/bundle/*",
            "--glob", "!.next/*",
            "--glob", "!dist/*",
            "--glob", "!build/*",
            "--glob", "!target/*",
            "--glob", "!tmp/*",
            "--glob", "!.cache/*",
          },
        },
        live_grep = {
          additional_args = function(_)
            return {
              "--hidden",
              "--glob", "!.git/*",
              "--glob", "!node_modules/*",
              "--glob", "!vendor/bundle/*",
              "--glob", "!.next/*",
              "--glob", "!dist/*",
              "--glob", "!build/*",
              "--glob", "!target/*",
              "--glob", "!tmp/*",
              "--glob", "!.cache/*",
            }
          end,
        },
      },
      defaults = {
        mappings = { i = { ["<esc>"] = actions.close } },
        file_ignore_patterns = {
          "%.git/",
          "node_modules/",
          "vendor/bundle/",
          "%.next/",
          "dist/",
          "build/",
          "target/",
          "tmp/",
          "%.cache/",
        },
      },

      extensions = {
        fzf = {
					fuzzy = true, -- false will only do exact matching
					override_generic_sorter = true, -- override the generic sorter
					override_file_sorter = true, -- override the file sorter
					case_mode = "smart_case", -- or "ignore_case" or "respect_case"
					-- the default case_mode is "smart_case"
				},
        ["ui-select"] = require("telescope.themes").get_dropdown({}),
			},
    }
	end,
  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts)
    pcall(telescope.load_extension, "fzf")
    pcall(telescope.load_extension, "ui-select")
  end,
}
