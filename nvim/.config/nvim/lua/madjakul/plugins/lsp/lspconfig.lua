-- lua/madlakul/plugins/lsp/lspconfig.lua
return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        { "antosha417/nvim-lsp-file-operations", config = true },
        { "folke/neodev.nvim", opts = {} },
    },
    config = function()
        local keymap = vim.keymap

        -- Global LSP keymaps on LspAttach
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(ev)
                local opts = { buffer = ev.buf, silent = true }

                opts.desc = "Show LSP references"
                keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

                opts.desc = "Go to declaration"
                keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

                opts.desc = "Go to definition"
                keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

                opts.desc = "Go to implementation"
                keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

                opts.desc = "Go to type definition"
                keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

                opts.desc = "Code action"
                keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

                opts.desc = "Rename symbol"
                keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

                opts.desc = "Show buffer diagnostics"
                keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

                opts.desc = "Show line diagnostics"
                keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

                opts.desc = "Hover documentation"
                keymap.set("n", "K", vim.lsp.buf.hover, opts)

                opts.desc = "Restart LSP"
                keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
            end,
        })

        -- Capabilities (shared by all servers)
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        -- Store them globally so mason-lspconfig handlers can access it
        -- (already done inside the handler above, but keeping it here is fine too)
        vim.g.lsp_capabilities = capabilities

        -- Diagnostic appearance
        vim.diagnostic.config({
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = "  ",
                    [vim.diagnostic.severity.WARN] = "  ",
                    [vim.diagnostic.severity.HINT] = "  ",
                    [vim.diagnostic.severity.INFO] = "  ",
                },
            },
            virtual_text = { spacing = 4, prefix = "■" },
            float = { source = true },
        })

        -- At the end of config function in lspconfig.lua
        vim.g.lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
    end,
}
