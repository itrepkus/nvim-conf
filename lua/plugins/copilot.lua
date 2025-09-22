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
                enabled = false,
                auto_refresh = true
            },
            suggestion = { enabled = false },
            filetypes = {
                ["*"] = true,
            }
        })
    end,
}
