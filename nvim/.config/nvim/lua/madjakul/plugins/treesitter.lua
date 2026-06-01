-- lua/madjakul/plugins/treesitter.lua
-- nvim-treesitter 1.0: setup() does NOT install parsers.
-- Parsers are pre-installed by the install script (headless TSInstall).
-- auto_install = true handles new filetypes opened after first setup.
-- Requires: tree-sitter-cli (npm install -g tree-sitter-cli)

return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    dependencies = {
        {
            "windwp/nvim-ts-autotag",
            config = function()
                require("nvim-ts-autotag").setup({
                    opts = {
                        enable_close = true,
                        enable_rename = true,
                        enable_close_on_slash = false,
                    },
                })
            end,
        },
    },
    config = function()
        -- auto_install: builds parser on first open of an unknown filetype
        require("nvim-treesitter").setup({
            auto_install = true,
        })

        -- Enable treesitter highlighting for every buffer with a parser
        local function enable_ts(buf)
            local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > 512 * 1024 then return end
            if pcall(vim.treesitter.start, buf) then
                vim.bo[buf].syntax = ""
            end
        end

        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("TreesitterEnable", { clear = true }),
            callback = function(args) enable_ts(args.buf) end,
        })

        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype ~= "" then
                enable_ts(buf)
            end
        end
    end,
}
