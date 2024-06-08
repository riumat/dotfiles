return {
    {
        "mbbill/undotree",
        cmd = { "UndotreeToggle", "UndotreeShow" },
        keys = {
            { "<leader>su", "<cmd>UndotreeToggle<cr>", desc = "Undo Tree" },
        },
        init = function()
            vim.g.undotree_ShortIndicators = 1
            vim.g.undotree_WindowLayout = 1
            vim.g.undotree_SplitWidth = 36
        end,
    },
}
