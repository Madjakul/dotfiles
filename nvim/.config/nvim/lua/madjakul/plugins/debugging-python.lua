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
        local dappython = require("dap-python")

        vim.keymap.set("n", "<Leader>br", dappython.test_method, {})
    end,
}
