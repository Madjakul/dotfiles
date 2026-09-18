-- lua/madjakul/plugins/formatting.lua
-- Ruff replaces black + isort + docformatter for Python.
-- Ruff format uses Black-compatible style by default, so your code looks the same.
-- It's written in Rust and is 10-100x faster than Black.

return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local conform = require("conform")

        conform.setup({
            formatters_by_ft = {
                -- Python: ruff handles import sorting + Black-style formatting
                python = { "ruff_organize_imports", "ruff_format" },

                -- Web / config formats
                json = { "prettier" },
                yaml = { "prettier" },
                markdown = { "prettier" },
                css = { "prettier" },
                html = { "prettier" },

                -- Lua
                lua = { "stylua" },

                -- C/C++
                c = { "clang-format" },
                cpp = { "clang-format" },

                -- Rust (use rustfmt, not clang-format)
                rust = { "rustfmt" },

                -- Shell
                bash = { "shfmt" },
                sh = { "shfmt" },

                -- Build files
                toml = { "taplo" },
                cmake = { "cmakelang" },
            },

            format_on_save = {
                lsp_format = "fallback",
                async = false,
                timeout_ms = 3000,
            },

            -- Ruff reads line-length from ~/.config/ruff/ruff.toml (or the
            -- project's pyproject.toml), so no extra args are needed here.
            formatters = {
                shfmt = {
                    prepend_args = { "-i", "4", "-ci" },
                },
            },
        })

        vim.keymap.set({ "n", "v" }, "<leader>mp", function()
            conform.format({
                lsp_format = "fallback",
                async = false,
                timeout_ms = 3000,
            })
        end, { desc = "Format file or range (in visual mode)" })
    end,
}
