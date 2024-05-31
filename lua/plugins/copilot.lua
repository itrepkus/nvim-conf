return {
    "zbirenbaum/copilot.lua",
    dependancies = {
        "zbirenbaum/copilot-cmp"
    },
    config = function ()
        require("copilot").setup({
            panel = {
                enabled = false,
                auto_refresh = true
            },
            suggestion = { enabled = false },
            filetypes = {
                ["*"] = true,
            }
        })
    end,
        cmd = "Copilot",
        event = "InsertEnter",
}
