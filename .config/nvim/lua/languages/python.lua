-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/python.lua

return {
    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {
                "ruff",
            },
        },
    },
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                pyright = {},
            },
            {
                "mfussenegger/nvim-lint",
                opts = {
                    linters_by_ft = {
                        python = { "ruff" },
                    },
                },
            },
        },
        {
            "mfussenegger/nvim-dap",
            dependencies = {
                "mfussenegger/nvim-dap-python",
                config = function()
                    local path = require("mason-registry").get_package("debugpy"):get_install_path()
                    require("dap-python").setup(path .. "/venv/bin/python")
                end,
            },
        },
        {
            "linux-cultist/venv-selector.nvim",
            cmd = "VenvSelect",
            opts = {

                ap_enabled = true,
                "venv",
                ".venv",
                "env",
                ".env",
            },
        },
        keys = { { "<leader>cv", "<cmd>:VenvSelect<cr>", desc = "Select VirtualEnv" } },
    },
    -- {
    --     "hrsh7th/nvim-cmp",
    --     opts = function(_, opts)
    --         opts.auto_brackets = opts.auto_brackets or {}
    --         table.insert(opts.auto_brackets, "python")
    --     end,
    -- },
}
