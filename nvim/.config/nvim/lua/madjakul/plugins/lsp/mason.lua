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
            -- Update the handlers section in mason.lua to this:
            handlers = {
                -- lua_ls custom settings
                function(server_name)
                    if server_name == "lua_ls" then
                        local capabilities = require("cmp_nvim_lsp").default_capabilities()
                        require("lspconfig")[server_name].setup({
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
                        require("lspconfig")[server_name].setup({
                            filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
                        })
                    -- Pyright custom settings
                    -- elseif server_name == "pyright" then
                    --     local capabilities = require("cmp_nvim_lsp").default_capabilities()
                    --     require("lspconfig")[server_name].setup({
                    --         capabilities = capabilities,
                    --         settings = {
                    --             python = {
                    --                 analysis = {
                    --                     -- This is the key setting for private imports
                    --                     diagnosticSeverityOverrides = {
                    --                         ["reportPrivateImportUsage"] = "none",
                    --                     },
                    --                     -- Keep other diagnostics enabled
                    --                     typeCheckingMode = "basic",
                    --                     autoSearchPaths = true,
                    --                     useLibraryCodeForTypes = true,
                    --                 },
                    --             },
                    --         },
                    --     })
                    -- For all other servers: use default setup with capabilities
                    else
                        local capabilities = require("cmp_nvim_lsp").default_capabilities()
                        require("lspconfig")[server_name].setup({
                            capabilities = capabilities,
                        })
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
