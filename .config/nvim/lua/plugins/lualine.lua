return {
    "nvim-lualine/lualine.nvim",
    event = { "VeryLazy" },
    dependencies = {
        "tpope/vim-fugitive",
        "nvim-tree/nvim-web-devicons",
    },
    opts = {
        extensions = {
            "quickfix",
        },
    },
    init = function()
        vim.opt.showmode = false
    end,
}
