return {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    dependencies = {
        "nvim-tree/nvim-web-devicons"
    },
    keys={{"<leader>pt", "<cmd>NvimTreeToggle<cr>", desc = "Toggle tree"},},
    config = function()
        require("nvim-tree").setup({
            disable_netrw = true,
            hijack_netrw = true,
        })
    end
}
