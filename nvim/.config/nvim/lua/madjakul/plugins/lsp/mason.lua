-- lua/madjakul/plugins/lsp/mason.lua
-- Trimmed to LSPs you actually use. Removed: gopls, graphql, cssls, html, sqlls.
-- Tools: ruff replaces black + isort + docformatter (faster, Black-compatible).

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
            "folke/lazydev.nvim",
        },
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            ensure_installed = {
                "bashls",           -- Bash
                "clangd",           -- C/C++
                "dockerls",         -- Dockerfiles
                "jsonls",           -- JSON
                "lua_ls",           -- Lua
                "pyright",          -- Python (type checking)
                "ruff",             -- Python (linting + formatting LSP)
                "rust_analyzer",    -- Rust
                "yamlls",           -- YAML
            },
            automatic_installation = true,
            automatic_enable = true,
        },
        config = function(_, opts)
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- Apply capabilities globally to all servers
            vim.lsp.config("*", {
                capabilities = capabilities,
            })

            -- Lua: recognize vim global
            vim.lsp.config("lua_ls", {
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" } },
                        completion = { callSnippet = "Replace" },
                        workspace = { checkThirdParty = false },
                        telemetry = { enable = false },
                    },
                },
            })

            -- Python: detect conda or virtualenv for Pyright
            local function get_python_path()
                if vim.env.CONDA_PREFIX then
                    return vim.env.CONDA_PREFIX .. "/bin/python"
                end
                if vim.env.VIRTUAL_ENV then
                    return vim.env.VIRTUAL_ENV .. "/bin/python"
                end
                return vim.fn.exepath("python3")
            end

            vim.lsp.config("pyright", {
                settings = {
                    python = {
                        pythonPath = get_python_path(),
                        analysis = {
                            diagnosticSeverityOverrides = {
                                ["reportPrivateImportUsage"] = "none",
                            },
                            typeCheckingMode = "basic",
                            autoSearchPaths = true,
                            useLibraryCodeForTypes = true,
                        },
                    },
                },
            })

            -- Ruff LSP: let it handle linting + import sorting,
            -- but disable its hover in favor of Pyright's
            vim.lsp.config("ruff", {
                init_options = {
                    settings = {
                        lineLength = 89,
                    },
                },
            })

            -- Disable Ruff hover so Pyright's hover takes priority
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("ruff_lsp_disable_hover", {}),
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if client and client.name == "ruff" then
                        client.server_capabilities.hoverProvider = false
                    end
                end,
            })

            require("mason-lspconfig").setup(opts)
        end,
    },

    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = "mason-org/mason.nvim",
        opts = {
            ensure_installed = {
                -- Formatters
                "prettier",         -- JSON, YAML, Markdown
                "stylua",           -- Lua
                "shfmt",            -- Shell
                "clang-format",     -- C/C++
                "taplo",            -- TOML

                -- Linters
                "ruff",             -- Python lint + format (replaces black, isort, flake8)
                "eslint_d",         -- JS/TS (kept for occasional web work)

                -- Debuggers
                "debugpy",          -- Python DAP

                -- Build tools
                "cmakelang",        -- CMake formatting
            },
        },
    },
}
