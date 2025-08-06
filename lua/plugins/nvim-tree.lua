return {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
        "nvim-tree/nvim-web-devicons"
    },
    keys={{"<leader>pt", "<cmd>NvimTreeToggle<cr>", desc = "Toggle tree"},},
    config = function()
        -- Fix for FileExplorer error - disable netrw completely
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1
        
        require("nvim-tree").setup {
            -- Disable the FileExplorer integration that causes errors
            disable_netrw = true,
            hijack_netrw = false,
        }
    end
}
