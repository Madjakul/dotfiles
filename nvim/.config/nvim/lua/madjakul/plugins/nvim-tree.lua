-- lua/madjakul/plugins/nvim-tree.lua
-- File explorer with aggressive filtering for SSHFS-mounted ML projects.
-- Ignores checkpoints, logs, wandb, __pycache__ etc. to keep things snappy.

return {
    "nvim-tree/nvim-tree.lua",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
        local nvimtree = require("nvim-tree")

        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        -- Mount points of SSHFS/FUSE filesystems (Linux: "type fuse.sshfs",
        -- macOS: "(macfuse, ..."), resolved once at startup.
        local sshfs_mounts = {}
        for _, line in ipairs(vim.fn.systemlist("mount")) do
            if line:find("sshfs") or line:find("fuse") then
                local mount = line:match(" on (/.-) type ") or line:match(" on (/.-) %(")
                if mount then
                    table.insert(sshfs_mounts, mount)
                end
            end
        end

        nvimtree.setup({
            view = {
                width = 35,
                relativenumber = true,
            },
            renderer = {
                indent_markers = { enable = true },
                icons = {
                    glyphs = {
                        folder = {
                            arrow_closed = "",
                            arrow_open = "",
                        },
                    },
                },
            },
            actions = {
                open_file = {
                    window_picker = { enable = false },
                },
            },
            -- SSHFS performance: filter out heavy directories
            filters = {
                custom = {
                    ".DS_Store",
                    "__pycache__",
                    "*.pyc",
                    ".mypy_cache",
                    ".ruff_cache",
                    "*.egg-info",
                    ".pytest_cache",
                },
            },
            git = {
                ignore = false,
                timeout = 2000, -- generous timeout for SSHFS latency
            },
            -- Live refresh on local disks; skipped on SSHFS mounts (inotify can't
            -- see remote changes there) and on dirs that churn during ML runs.
            -- Use <leader>er to refresh manually inside SSHFS mounts.
            filesystem_watchers = {
                enable = true,
                debounce_delay = 100,
                ignore_dirs = function(path)
                    for _, mount in ipairs(sshfs_mounts) do
                        if path == mount or vim.startswith(path, mount .. "/") then
                            return true
                        end
                    end
                    return path:match("/node_modules$") ~= nil
                        or path:match("/%.git$") ~= nil
                        or path:match("/wandb$") ~= nil
                        or path:match("/checkpoints$") ~= nil
                        or path:match("/outputs$") ~= nil
                        or path:match("/logs$") ~= nil
                end,
            },
            -- Diagnostics in tree (optional, can slow SSHFS)
            diagnostics = {
                enable = false,
            },
        })

        local keymap = vim.keymap
        keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
        keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle explorer on current file" })
        keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" })
        keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" })
    end,
}
