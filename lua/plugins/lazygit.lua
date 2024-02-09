return {
    "kdheepak/lazygit.nvim",
    dependancies = {
        "nvim-lua/plenary.nvim"
    },
    lazy = false,
    keys = {
        {"<leader>lg", "<cmd>LazyGit<cr>", desc = "Open LazyGitit"}
    },
}
