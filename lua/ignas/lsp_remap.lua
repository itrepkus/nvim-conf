local keymap = vim.keymap -- for conciseness
local opts = { noremap = true, silent = true }

-- Global diagnostic keymaps (always available)
keymap.set('n', '<leader>rd', vim.diagnostic.goto_next, opts) -- go to next diagnostic
keymap.set('n', '<leader>ru', vim.diagnostic.goto_prev, opts) -- go to previous diagnostic
keymap.set('n', '<leader>dl', vim.diagnostic.setloclist, opts) -- show diagnostics in location list
keymap.set('n', '<leader>dq', vim.diagnostic.setqflist, opts) -- show diagnostics in quickfix list

-- LSP on_attach function for buffer-specific mappings
local on_attach = function(client, bufnr)
  local bufopts = { noremap = true, silent = true, buffer = bufnr }

  -- Basic LSP keymaps (these should always be available)
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

  -- Additional mappings (with safety checks)
  if vim.lsp.buf.type_definition then
    keymap.set("n", "gt", vim.lsp.buf.type_definition, bufopts)
  end

  if vim.lsp.buf.signature_help then
    keymap.set("n", "<leader>sh", vim.lsp.buf.signature_help, bufopts)
  end

  if vim.lsp.buf.range_code_action then
    keymap.set("v", "<leader>ca", vim.lsp.buf.range_code_action, bufopts)
  end

  if vim.lsp.buf.range_formatting then
    keymap.set("v", "<leader>f", vim.lsp.buf.range_formatting, bufopts)
  end

  -- Workspace mappings
  if vim.lsp.buf.add_workspace_folder then
    keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
  end

  if vim.lsp.buf.remove_workspace_folder then
    keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
  end

  if vim.lsp.buf.list_workspace_folders then
    keymap.set("n", "<leader>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
  end

  -- Inlay hints (only if available)
  if vim.lsp.inlay_hint and vim.lsp.inlay_hint.enable then
    keymap.set("n", "<leader>ih", function()
      vim.lsp.inlay_hint.enable(bufnr, not vim.lsp.inlay_hint.is_enabled(bufnr))
    end, bufopts)
  end
end

-- Export the on_attach function for use in LSP config
return {
  on_attach = on_attach
}
