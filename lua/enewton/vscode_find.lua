local M = {}

local IGNORE_CASE = 1
local HISTORY_TIER = 2 ^ 30
local LABEL_TIER = 2 ^ 20

local function recent_files(cwd)
    local recent = {}
    local rank = 0
    local function add(path)
        if path ~= "" and path:sub(1, #cwd + 1) == cwd .. "/" and not recent[path] then
            rank = rank + 1
            recent[path] = rank
        end
    end
    local bufs = vim.fn.getbufinfo({ buflisted = 1 })
    table.sort(bufs, function(a, b) return a.lastused > b.lastused end)
    for _, buf in ipairs(bufs) do
        add(buf.name)
    end
    for _, path in ipairs(vim.v.oldfiles) do
        add(path)
    end
    return recent
end

local function sorter(cwd)
    local fzf = require("fzf_lib")
    local sorters = require("telescope.sorters")

    return sorters.Sorter:new({
        discard = true,

        init = function(self)
            self.state.slab = fzf.allocate_slab()
            self.state.patterns = {}
            self.state.recent = recent_files(cwd)
        end,

        destroy = function(self)
            for _, p in pairs(self.state.patterns) do
                fzf.free_pattern(p)
            end
            self.state.patterns = {}
            if self.state.slab then
                fzf.free_slab(self.state.slab)
                self.state.slab = nil
            end
        end,

        scoring_function = function(self, prompt, line)
            local recency = self.state.recent[cwd .. "/" .. line]
            prompt = vim.trim(prompt)

            if prompt == "" then
                return recency and recency * 1e-6 or 1 + #line * 1e-6
            end

            local pattern = self.state.patterns[prompt]
            if not pattern then
                pattern = fzf.parse_pattern(prompt, IGNORE_CASE, true)
                self.state.patterns[prompt] = pattern
            end

            local score
            if not prompt:find("/", 1, true) then
                local label_score = fzf.get_score(vim.fs.basename(line), pattern, self.state.slab)
                if label_score > 0 then
                    score = LABEL_TIER + label_score
                end
            end
            if not score then
                score = fzf.get_score(line, pattern, self.state.slab)
                if score <= 0 then
                    return -1
                end
            end
            if recency then
                score = score + HISTORY_TIER
            end
            -- shorter paths win ties, like VS Code's compareItemsByFuzzyScore
            return 1 / score + #line * 1e-12
        end,

        highlighter = function(self, prompt, display)
            local pattern = self.state.patterns[vim.trim(prompt)]
            return pattern and fzf.get_pos(display, pattern, self.state.slab) or {}
        end,
    })
end

function M.find_files()
    local builtin = require("telescope.builtin")
    local ok = pcall(require, "fzf_lib")
    if not ok then
        vim.notify("telescope-fzf-native not built; run :Lazy build telescope-fzf-native.nvim", vim.log.levels.WARN)
        return builtin.find_files()
    end

    local cwd = vim.uv.cwd()
    builtin.find_files({
        cwd = cwd,
        -- VS Code shows dotfiles but honours .gitignore and its default files.exclude
        find_command = {
            "rg", "--files", "--hidden", "--color", "never",
            "--glob", "!**/.git",
            "--glob", "!**/.svn",
            "--glob", "!**/.hg",
            "--glob", "!**/.DS_Store",
            "--glob", "!**/Thumbs.db",
        },
        path_display = { "filename_first" },
        sorter = sorter(cwd),
    })
end

return M
