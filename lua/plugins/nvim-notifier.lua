return {
  "rcarriga/nvim-notify",
  dependencies = {},
  opts = {},
  config = function()
    vim.notify = require("notify")
  end
}

