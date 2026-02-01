require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "ts_ls",
    "rust_analyzer",
    "clangd",
    "tailwindcss",
  },
  automatic_installation = true,
});
