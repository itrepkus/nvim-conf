return {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    dependencies = {
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
}
