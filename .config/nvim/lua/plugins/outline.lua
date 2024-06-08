return {
    {
        "hedyhli/outline.nvim",
        cmd = { "Outline", "OutlineOpen" },
        keys = {
            { "<leader>so", "<cmd>Outline!<CR>", desc = "Show Outline" },
        },
        opts = {
            position = "right",
            split_command = nil,
            relative_width = false,
            width = 36,
        },
    },
}
