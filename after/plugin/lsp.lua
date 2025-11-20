-- ===============================
-- LSP / CMP / Diagnostics Config
-- ===============================

local lsp_zero = require("lsp-zero")

-- Extend lspconfig to use new Neovim 0.11 API
lsp_zero.extend_lspconfig()

-- ===============================
-- Mason Setup
-- ===============================
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { "rust_analyzer", "lua_ls" },
    handlers = {
        lsp_zero.default_setup,  -- automatically sets up installed servers
    },
})

-- ===============================
-- Custom Lua LS Settings
-- ===============================
--
vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            diagnostics = { globals = { "vim" } },
        },
    },
})
vim.lsp.enable({ "lua_ls" })

-- ===============================
-- CMP Setup
-- ===============================
local cmp = require("cmp")

cmp.setup({
    mapping = {
        ["<Up>"] = cmp.mapping.select_prev_item(),
        ["<Down>"] = cmp.mapping.select_next_item(),
        ["<Tab>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
    },
    sources = {
        { name = "nvim_lsp" },
        { name = "buffer" },
        { name = "path" },
    },
})

-- ===============================
-- Diagnostic Sign Icons
-- ===============================
vim.fn.sign_define("DiagnosticSignError", { text = "󰽍", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn",  { text = "󰇶", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignHint",  { text = "󰇵", texthl = "DiagnosticSignHint" })
vim.fn.sign_define("DiagnosticSignInfo",  { text = "󰱳", texthl = "DiagnosticSignInfo" })

-- ===============================
-- Keymaps / on_attach
-- ===============================
lsp_zero.on_attach(function(_, bufnr)
    local opts = { buffer = bufnr }

    vim.keymap.set("n", "<C-b>", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>dd", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)
end)

-- ===============================
-- Diagnostics Config
-- ===============================
vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})

-- ===============================
-- Finalize LSP Setup
-- ===============================
lsp_zero.setup()

