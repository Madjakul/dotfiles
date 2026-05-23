-- lua/madjakul/plugins/telescope.lua
-- Fuzzy finder with ripgrep ignore patterns for SSHFS-mounted ML projects.
-- Prevents crawling checkpoints/, wandb/, logs/, __pycache__/, etc.

return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        "nvim-tree/nvim-web-devicons",
        "folke/todo-comments.nvim",
    },
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")

        telescope.setup({
            defaults = {
                path_display = { "smart" },
                -- Ignore heavy dirs that SSHFS would crawl slowly
                file_ignore_patterns = {
                    "%.git/",
                    "__pycache__/",
                    "%.pyc$",
                    "node_modules/",
                    "checkpoints/",
                    "logs/",
                    "tmp/",
                    "wandb/",
                    "outputs/",
                    "%.egg%-info/",
                    "%.mypy_cache/",
                    "%.ruff_cache/",
                    "%.pytest_cache/",
                    "%.so$",
                    "%.o$",
                    "%.bin$",
                    "%.pt$",           -- PyTorch checkpoints
                    "%.ckpt$",         -- Lightning checkpoints
                    "%.safetensors$",  -- HF model files
                },
                mappings = {
                    i = {
                        ["<C-k>"] = actions.move_selection_previous,
                        ["<C-j>"] = actions.move_selection_next,
                        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                    },
                },
                -- Use ripgrep for live_grep (respects .gitignore + our patterns)
                vimgrep_arguments = {
                    "rg",
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                    "--smart-case",
                    "--hidden",
                    "--glob=!.git/",
                    "--glob=!__pycache__/",
                    "--glob=!checkpoints/",
                    "--glob=!wandb/",
                    "--glob=!logs/",
                    "--glob=!tmp/",
                    "--glob=!outputs/",
                },
            },
        })

        telescope.load_extension("fzf")

        local keymap = vim.keymap
        keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files in cwd" })
        keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Find recent files" })
        keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
        keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor" })
        keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
        keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find open buffers" })
    end,
}
