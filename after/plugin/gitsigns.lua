require("gitsigns").setup({
  current_line_blame = true,
  on_attach = function(bufnr)
    local gs = require("gitsigns")
    local map = function(l, r, desc) vim.keymap.set('n', l, r, { buffer = bufnr, desc = desc }) end
    map(']h', function() gs.nav_hunk('next') end, 'Next hunk')
    map('[h', function() gs.nav_hunk('prev') end, 'Previous hunk')
    map('<leader>hp', gs.preview_hunk_inline, 'Preview hunk')
    map('<leader>hs', gs.stage_hunk, 'Stage hunk')
    map('<leader>hr', gs.reset_hunk, 'Reset hunk')
    map('<leader>hb', function() gs.blame_line({ full = true }) end, 'Blame line')
  end,
})
