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
            suggestion = { enabled = true },
            filetypes = {
                ["*"] = true,
            }
        })
    end,
        cmd = "Copilot",
        event = "InsertEnter",
}
