-- lua/madlakul/plugins/lsp/mason.lua
return {
    {
        "mason-org/mason.nvim",
        opts = {
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        },
    },

    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = {
            "mason-org/mason.nvim",
            "neovim/nvim-lspconfig",
            "hrsh7th/cmp-nvim-lsp",
            "folke/neodev.nvim",
        },
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            ensure_installed = {
                "bashls",
                "clangd",
                "cssls",
                "dockerls",
                "gopls",
                "graphql",
                "html",
                "jsonls",
                "lua_ls",
                "pyright",
                "rust_analyzer",
                "sqlls",
                "yamlls",
            },
            automatic_installation = true,
            -- Let mason-lspconfig auto-enable all installed servers (uses vim.lsp.enable)
            automatic_enable = true, -- default, but explicit for clarity

            -- Optional: Custom handlers ONLY for servers needing overrides
            -- (for defaults, mason-lspconfig skips this and uses vim.lsp.enable)
            handlers = {
                -- lua_ls custom settings
                function(server_name)
                    if server_name == "lua_ls" then
                        local capabilities = require("cmp_nvim_lsp").default_capabilities()
                        vim.lsp.config(server_name, {
                            capabilities = capabilities,
                            settings = {
                                Lua = {
                                    diagnostics = { globals = { "vim" } },
                                    completion = { callSnippet = "Replace" },
                                    workspace = { checkThirdParty = false },
                                    telemetry = { enable = false },
                                },
                            },
                        })
                    -- graphql custom filetypes
                    elseif server_name == "graphql" then
                        vim.lsp.config(server_name, {
                            filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
                        })
                    -- For all other servers: let mason-lspconfig use defaults via vim.lsp.enable
                    else
                        vim.lsp.enable(server_name)
                    end
                end,
            },
        },
    },

    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = "mason-org/mason.nvim",
        opts = {
            ensure_installed = {
                "prettier",
                "stylua",
                "black",
                "isort",
                "shfmt",
                "clang-format",
                "eslint_d",
                "debugpy",
                "cmakelang",
                "docformatter",
            },
        },
    },
}
