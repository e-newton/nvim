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
    ensure_installed = { "rust_analyzer", "lua_ls", "ts_ls", "clangd", "tailwindcss" },
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
-- Intelephense: mirror <root>/.vscode/settings.json
-- ===============================
local function read_vscode_settings(root)
    local path = root and vim.fs.joinpath(root, ".vscode", "settings.json")
    if not path or vim.fn.filereadable(path) == 0 then
        return {}
    end
    local text = table.concat(vim.fn.readfile(path), "\n")
    -- VS Code allows JSONC: line comments and trailing commas
    text = text:gsub("\n%s*//[^\n]*", "\n"):gsub(",%s*([}%]])", "%1")
    local ok, decoded = pcall(vim.json.decode, text)
    return ok and decoded or {}
end

vim.lsp.config("intelephense", {
    before_init = function(_, config)
        local nested = {}
        for key, value in pairs(read_vscode_settings(config.root_dir)) do
            if key:match("^intelephense%.") then
                local node = nested
                local parts = vim.split(key, ".", { plain = true })
                for i = 1, #parts - 1 do
                    node[parts[i]] = node[parts[i]] or {}
                    node = node[parts[i]]
                end
                node[parts[#parts]] = value
            end
        end
        config.settings = config.settings or {}
        config.settings.intelephense = vim.tbl_deep_extend("force", config.settings.intelephense or {}, nested.intelephense or {})
    end,
})
vim.lsp.enable({ "intelephense" })

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
        {
            name = "nvim_lsp",
            entry_filter = function(entry)
                return entry:get_kind() ~= cmp.lsp.CompletionItemKind.Text
            end,
        },
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

