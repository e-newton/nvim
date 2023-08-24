require('telescope').setup({
  extensions = {
    advanced_git_search = {
            -- fugitive or diffview
      diff_plugin = "fugitive",
      -- customize git in previewer
      -- e.g. flags such as { "--no-pager" }, or { "-c", "delta.side-by-side=false" }
      git_flags = {},
      -- customize git diff in previewer
      -- e.g. flags such as { "--raw" }
      git_diff_flags = {},
      -- Show builtin git pickers when executing "show_custom_functions" or :AdvancedGitSearch
      show_builtin_git_pickers = false,
      entry_default_author_or_date = "author", -- one of "author" or "date"

      -- Telescope layout setup
      telescope_theme = {
          function_name_1 = {
              -- Theme options
          },
          function_name_2 = "dropdown",
          -- e.g. realistic example
          show_custom_functions = {
              layout_config = { width = 0.4, height = 0.4 },
          },

      }
    }
  }
})
local builtin = require('telescope.builtin')
require("telescope").load_extension("advanced_git_search")
vim.keymap.set('n', '<leader>fa', builtin.find_files, {})
vim.keymap.set('n', '<leader>fo', builtin.oldfiles, {})
vim.keymap.set('n', '<leader>p', builtin.git_files, {})
vim.keymap.set('n', '<leader>bb', builtin.buffers, {})
vim.keymap.set('n', '<leader>r', builtin.lsp_references, {})
vim.keymap.set('n', '<leader>lg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>gl', builtin.grep_string, {})
vim.keymap.set('v', '<leader>gl', builtin.grep_string, {})
vim.keymap.set('n', '<leader>P', builtin.resume, {})
vim.keymap.set('n', '<leader>lag', ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", {})
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>gg', ":AdvancedGitSearch<CR>")
vim.keymap.set('v', '<leader>lh',":AdvancedGitSearch diff_commit_line<CR>")
