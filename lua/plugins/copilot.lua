return {
    "zbirenbaum/copilot.lua",
    dependancies = {
        "zbirenbaum/copilot-cmp"
    },
    config = function ()
        require("copilot").setup({
            panel = {
                enabled = true,
                auto_refresh = true
            },
            filetypes = {
                ["*"] = true,
            }
        })

    end,
        cmd = "Copilot",
}
