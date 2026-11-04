local ok, diffview = pcall(require, "diffview")
if not ok then return end

diffview.setup()

vim.keymap.set('n', '<leader>gd', '<cmd>DiffviewOpen<CR>', { desc = 'Diff working tree' })
vim.keymap.set('n', '<leader>gm', '<cmd>DiffviewOpen origin/master...HEAD<CR>', { desc = 'Diff branch vs master' })
vim.keymap.set('n', '<leader>gh', '<cmd>DiffviewFileHistory %<CR>', { desc = 'File history' })
vim.keymap.set('n', '<leader>gH', '<cmd>DiffviewFileHistory<CR>', { desc = 'Repo history' })
vim.keymap.set('n', '<leader>gq', '<cmd>DiffviewClose<CR>', { desc = 'Close diffview' })

-- ===============================
-- Diff against the parent branch
-- ===============================
-- For stacked branches (dev -> feature -> master), show only what this branch adds
-- on top of the branch it was cut from, instead of everything back to master.

local function git(args)
  local res = vim.system(vim.list_extend({ "git" }, args), { text = true }):wait()
  if res.code ~= 0 then return nil end
  return vim.trim(res.stdout)
end

-- Local branches that HEAD was built on, sorted by how many commits HEAD has
-- since forking from each one (closest first).
local function candidate_bases()
  local current = git({ "rev-parse", "--abbrev-ref", "HEAD" })
  local head = git({ "rev-parse", "HEAD" })
  local refs = git({ "for-each-ref", "--format=%(refname:short)", "refs/heads" }) or ""
  local out = {}
  for ref in refs:gmatch("[^\n]+") do
    if ref ~= current then
      local base = git({ "merge-base", "HEAD", ref })
      -- Skip branches that already contain HEAD (descendants or the same commit).
      if base and base ~= head then
        local n = tonumber(git({ "rev-list", "--count", base .. "..HEAD" }))
        if n then table.insert(out, { ref = ref, ahead = n }) end
      end
    end
  end
  table.sort(out, function(a, b)
    if a.ahead ~= b.ahead then return a.ahead < b.ahead end
    return a.ref < b.ref
  end)
  return out
end

-- The base branch of this branch's open PR, if there is one.
local function pr_base()
  if vim.fn.executable("gh") == 0 then return nil end
  local res = vim.system({ "gh", "pr", "view", "--json", "baseRefName", "-q", ".baseRefName" }, { text = true }):wait()
  if res.code ~= 0 then return nil end
  local base = vim.trim(res.stdout)
  if base == "" then return nil end
  -- Prefer the remote ref so the diff matches GitHub even if the local branch is stale.
  if git({ "rev-parse", "--verify", "--quiet", "origin/" .. base }) then return "origin/" .. base end
  return base
end

local function open_against(base, how)
  vim.notify(("Diffing against %s (%s)"):format(base, how))
  vim.cmd("DiffviewOpen " .. base .. "...HEAD")
end

local function diff_parent()
  local base = pr_base()
  if base then return open_against(base, "PR base") end
  local c = candidate_bases()[1]
  if c then return open_against(c.ref, ("nearest branch, %d commits ahead"):format(c.ahead)) end
  vim.notify("Couldn't find a parent branch", vim.log.levels.WARN)
end

-- :DiffBase            pick a base branch from a list (closest first)
-- :DiffBase <branch>   diff HEAD against that branch
vim.api.nvim_create_user_command("DiffBase", function(opts)
  if opts.args ~= "" then return open_against(opts.args, "chosen") end
  local cands = candidate_bases()
  if #cands == 0 then return vim.notify("No candidate base branches", vim.log.levels.WARN) end
  vim.ui.select(cands, {
    prompt = "Diff HEAD against:",
    format_item = function(c) return ("%s  (%d commits ahead)"):format(c.ref, c.ahead) end,
  }, function(choice)
    if choice then open_against(choice.ref, "chosen") end
  end)
end, {
  nargs = "?",
  complete = function(lead)
    local refs = git({ "for-each-ref", "--format=%(refname:short)", "refs/heads", "refs/remotes/origin" }) or ""
    return vim.tbl_filter(function(r) return vim.startswith(r, lead) end, vim.split(refs, "\n"))
  end,
  desc = "Diffview HEAD against a base branch",
})

vim.keymap.set('n', '<leader>gp', diff_parent, { desc = 'Diff branch vs parent branch' })
vim.keymap.set('n', '<leader>gP', '<cmd>DiffBase<CR>', { desc = 'Diff branch vs chosen base' })
