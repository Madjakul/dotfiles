-- lua/madjakul/core/options.lua
-- Core editor options with SSHFS performance tuning

vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

-- ====== Line Numbers ======
opt.relativenumber = true
opt.number = true
opt.colorcolumn = "89"

-- ====== Terminal & Colors ======
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

-- ====== Tabs & Indentation ======
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

-- ====== Line Wrapping ======
opt.wrap = false
opt.linebreak = true

-- ====== Search ======
opt.ignorecase = true
opt.smartcase = true

-- ====== Cursor ======
opt.cursorline = true
opt.visualbell = true

-- ====== Backspace ======
opt.backspace = "indent,eol,start"

-- ====== Clipboard ======
opt.clipboard:append("unnamedplus")

-- ====== Splits ======
opt.splitright = true
opt.splitbelow = true

-- ====== Files ======
opt.swapfile = false

-- ====== Statusline ======
-- Global statusline so splits collapse cleanly
opt.laststatus = 3

-- ====== Performance (critical for SSHFS mounts) ======
-- Reduce file-system polling; SSHFS is high-latency
opt.updatetime = 300
opt.timeoutlen = 500

-- Wildignore: prevents Telescope/find/glob from crawling heavy dirs
opt.wildignore:append({
    "*/tmp/*",
    "*/logs/*",
    "*/checkpoints/*",
    "*/__pycache__/*",
    "*.pyc",
    "*/wandb/*",
    "*/outputs/*",
    "*/.git/*",
    "*/node_modules/*",
    "*.egg-info/*",
    "*/.mypy_cache/*",
    "*/.ruff_cache/*",
    "*.so",
    "*.o",
    "*.a",
})

-- Disable unused built-in plugins for faster startup
local disabled_builtins = {
    "gzip",
    "zip",
    "zipPlugin",
    "tar",
    "tarPlugin",
    "getscript",
    "getscriptPlugin",
    "vimball",
    "vimballPlugin",
    "2html_plugin",
    "logiPat",
    "rrhelper",
    "matchit",
    "tutor",
    "rplugin",
}
for _, plugin in ipairs(disabled_builtins) do
    vim.g["loaded_" .. plugin] = 1
end
