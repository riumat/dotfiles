-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/dap/core.lua
---@param config {args?:string[]|fun():string[]?}
local function get_args(config)
    local args = type(config.args) == "function" and (config.args() or {}) or config.args or {}
    config = vim.deepcopy(config)
    ---@cast args string[]
    config.args = function()
        local new_args = vim.fn.input({
            prompt = "Run with args: ",
            default = table.concat(args, " "),
            completions = "file",
        })
        return vim.split(vim.fn.expand(new_args), " ")
    end
    return config
end

return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "mason.nvim",
            "jay-babu/mason-nvim-dap.nvim",
            "theHamsta/nvim-dap-virtual-text",
        },

        -- TODO: modify keys
        -- stylua: ignore
        keys = {
            { "<F5>", function() require("dap").continue() end, desc = "Dap: Continue" },
            { "<F10>", function() require("dap").step_over() end, desc = "Dap: Step Over" },
            { "<F11>", function() require("dap").step_into() end, desc = "Dap: Step Into" },
            { "<leader><F11>", function() require("dap").step_out() end, desc = "Dap: Step Out" },

            { "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Dap: Run with Args" },
            { "<leader>dc", function() require("dap").set_breakpoint(vim.fn.input('Dap: Condition: ')) end, desc = "Dap: Conditional Breakpoint" },
            { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Dap: Breakpoint" },
            { "<leader>dk", function() require("dap").terminate() end, desc = "Dap: Kill" },
        },

        config = function()
            vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio",
        },
        opts = {},
        config = function(_, opts)
            local dap = require("dap")
            local dapui = require("dapui")
            dapui.setup(opts)
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open({})
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close({})
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close({})
            end
        end,
    },
    {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = {
            "williamboman/mason.nvim",
        },
        cmd = { "DapInstall", "DapUninstall" },
        opts = {
            automatic_installation = true,
            handlers = {},
            ensure_installed = {},
        },
    },
}
