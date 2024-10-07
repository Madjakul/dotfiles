return {
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
        -- import mason
        local mason = require("mason")

        -- import mason-lspconfig
        local mason_lspconfig = require("mason-lspconfig")

        local mason_tool_installer = require("mason-tool-installer")

        -- enable mason and configure icons
        mason.setup({
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        })

        mason_lspconfig.setup({
            -- list of servers for mason to install
            ensure_installed = {
                "bashls",
                "clangd",
                "neocmake",
                "cssls",
                "dockerls",
                "gopls",
                "graphql",
                "html",
                "jdtls",
                "jsonls",
                "ltex",
                "lua_ls",
                "grammarly",
                "pyright",
                "rust_analyzer",
                "sqlls",
                "taplo",
                "lemminx",
                "yamlls",
            },
        })

        mason_tool_installer.setup({
            ensure_installed = {
                "eslint_d",
                "prettier", -- prettier formatter
                "stylua", -- lua formatter
                "debugpy", -- python debugger
                "isort", -- python formatter
                "black", -- python formatter
                "ruff", -- python linter
                "docformatter", -- python formatter
                "clang-format", -- C/C++ formatter
                "taplo", -- tom formatter
                "shfmt", -- Shell formatter
                "cmakelang", --CMake formatter
            },
        })
    end,
}
