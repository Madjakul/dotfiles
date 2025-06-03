return {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = { "windwp/nvim-ts-autotag" },
    config = function()
        local treesitter = require("nvim-treesitter.configs")

        treesitter.setup({
            -- these four to satisfy the TSConfig signature:
            modules = {}, -- for any extra modules you might load
            sync_install = false, -- install parsers synchronously?
            ignore_install = {}, -- list of parsers to NEVER install
            auto_install = true, -- install missing parsers on-the-fly?

            -- now all your old settings
            ensure_installed = {
                "bash",
                "bibtex",
                "c",
                "cmake",
                "comment",
                "cpp",
                "css",
                "csv",
                "cuda",
                "dockerfile",
                "git_config",
                "git_rebase",
                "gitattributes",
                "gitcommit",
                "gitignore",
                "go",
                "graphql",
                "html",
                "http",
                "ini",
                "java",
                "javascript",
                "json",
                "lua",
                "make",
                "markdown",
                "markdown_inline",
                "python",
                "regex",
                "rst",
                "rust",
                "scheme",
                "sparql",
                "sql",
                "ssh_config",
                "tmux",
                "toml",
                "tsv",
                "typescript",
                "vim",
                "xml",
                "yaml",
            },

            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
                custom_captures = {
                    ["type"] = "Type",
                },
            },

            indent = { enable = true },

            autotag = { enable = true },

            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<C-space>",
                    node_incremental = "<C-space>",
                    scope_incremental = false,
                    node_decremental = "<bs>",
                },
            },
        })
    end,
}
