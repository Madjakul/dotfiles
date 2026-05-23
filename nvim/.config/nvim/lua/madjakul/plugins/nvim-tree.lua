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
            -- Reduce filesystem watches on SSHFS
            filesystem_watchers = {
                enable = false, -- disable for SSHFS; manual refresh with <leader>er
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
