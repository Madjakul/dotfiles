-- lua/madjakul/plugins/debugging-python.lua
-- Python-specific DAP with debugpy

return {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
        "mfussenegger/nvim-dap",
        "rcarriga/nvim-dap-ui",
    },
    config = function()
        local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
        require("dap-python").setup(path)
        require("dapui").setup()

        vim.keymap.set("n", "<Leader>br", require("dap-python").test_method, { desc = "Debug test method" })
    end,
}
