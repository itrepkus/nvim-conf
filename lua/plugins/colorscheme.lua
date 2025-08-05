return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	opts = function()
		return {
		}
	end,
	config = function(_, opts)
		local tokyonight = require("tokyonight")
		tokyonight.setup(opts)
		tokyonight.load()
	end,
}