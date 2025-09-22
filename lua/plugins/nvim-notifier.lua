return {
  "rcarriga/nvim-notify",
  event = "VeryLazy",
  dependencies = {},
  opts = {},
  config = function()
    vim.notify = require("notify")
  end
}

