-- lua/madjakul/plugins/lualine.lua
-- Statusline with gruvbox-material theme, conda environment display,
-- active LSP name, and lazy.nvim update count.

return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local lualine = require("lualine")
        local lazy_status = require("lazy.status")

        -- Helper: show current conda env or virtualenv name
        local function python_env()
            if vim.env.CONDA_DEFAULT_ENV and vim.env.CONDA_DEFAULT_ENV ~= "base" then
                return " " .. vim.env.CONDA_DEFAULT_ENV
            end
            if vim.env.VIRTUAL_ENV then
                return " " .. vim.fn.fnamemodify(vim.env.VIRTUAL_ENV, ":t")
            end
            return ""
        end

        -- Helper: show attached LSP server names
        local function lsp_status()
            local clients = vim.lsp.get_clients({ bufnr = 0 })
            if #clients == 0 then
                return ""
            end
            local names = {}
            for _, client in ipairs(clients) do
                table.insert(names, client.name)
            end
            return " " .. table.concat(names, ", ")
        end

        lualine.setup({
            options = {
                theme = "gruvbox-material",
            },
            sections = {
                lualine_b = {
                    "branch",
                    "diff",
                    "diagnostics",
                },
                lualine_c = {
                    "filename",
                    { python_env, color = { fg = "#a9b665" } },
                },
                lualine_x = {
                    {
                        lazy_status.updates,
                        cond = lazy_status.has_updates,
                        color = { fg = "#e78a4e" },
                    },
                    { lsp_status, color = { fg = "#7daea3" } },
                    "encoding",
                    "fileformat",
                    "filetype",
                },
            },
        })
    end,
}
