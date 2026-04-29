local keymap = vim.keymap -- for conciseness
local opts = { noremap = true, silent = true }

-- Global diagnostic keymaps (always available)
keymap.set('n', '<leader>rd', vim.diagnostic.goto_next, opts) -- go to next diagnostic
keymap.set('n', '<leader>ru', vim.diagnostic.goto_prev, opts) -- go to previous diagnostic
keymap.set('n', '<leader>dl', vim.diagnostic.setloclist, opts) -- show diagnostics in location list
keymap.set('n', '<leader>dq', vim.diagnostic.setqflist, opts) -- show diagnostics in quickfix list

-- Use LspAttach autocmd for buffer-specific mappings (works with Neovim 0.11+)
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
  callback = function(ev)
    local bufnr = ev.buf
    local bufopts = { noremap = true, silent = true, buffer = bufnr }

    -- Basic LSP keymaps
    keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
    keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
    keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
    keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
    keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
    keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
    keymap.set("n", "<leader>f", vim.lsp.buf.format, bufopts)

    -- Telescope integration (only if telescope is available)
    local ok, _ = pcall(require, "telescope.builtin")
    if ok then
      keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", bufopts)
    end

    -- Additional mappings
    keymap.set("n", "gt", vim.lsp.buf.type_definition, bufopts)
    keymap.set("n", "<leader>sh", vim.lsp.buf.signature_help, bufopts)
    keymap.set("v", "<leader>ca", vim.lsp.buf.code_action, bufopts)
    keymap.set("v", "<leader>f", vim.lsp.buf.format, bufopts)

    -- Workspace mappings
    keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
    keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
    keymap.set("n", "<leader>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)

    -- Inlay hints toggle
    if vim.lsp.inlay_hint then
      keymap.set("n", "<leader>ih", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
      end, bufopts)
    end
  end,
})
