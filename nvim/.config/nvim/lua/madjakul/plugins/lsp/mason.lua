return {
    -- Core Mason installer
    {
        "mason-org/mason.nvim",
        version = "^1.0.0",
        -- lazy.nvim will call require("mason").setup(opts) for you
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

    -- Mason + nvim-lspconfig integration
    {
        "mason-org/mason-lspconfig.nvim",
        version = "^1.0.0",
        dependencies = {
            "mason-org/mason.nvim",
            "neovim/nvim-lspconfig",
        },
        -- lazy.nvim will call require("mason-lspconfig").setup(opts)
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
            -- auto-install any LSP you set up via lspconfig
            automatic_installation = true,
        },
    },

    -- Mason Tool Installer (formatters, linters, debug adapters, etc.)
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        version = "^1.0.0",
        dependencies = { "mason-org/mason.nvim" },
        -- lazy.nvim will call require("mason-tool-installer").setup(opts)
        opts = {
            ensure_installed = {
                "eslint_d", -- JS/TS linter
                "prettier", -- code formatter
                "stylua", -- Lua formatter
                "debugpy", -- Python debugger
                "isort", -- Python import sorter
                "black", -- Python formatter
                "docformatter", -- Python docstring formatter
                "clang-format", -- C/C++ formatter
                "shfmt", -- Shell script formatter
                "cmakelang", -- CMake formatter
            },
        },
    },
}
