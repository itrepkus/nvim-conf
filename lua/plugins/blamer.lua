return {
    "APZelos/blamer.nvim",
    event = { "BufReadPost" },
    keys = {
    {"<leader>bl", "<cmd>BlamerToggle<CR>", desc = "Toggle Blame"},
  },
}
