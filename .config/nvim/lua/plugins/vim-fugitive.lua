return {
    {
        "tpope/vim-fugitive",
        cmd = {
            "G",
            "Git",
            "Gedit",
            "Gsplit",
            "Gdiffsplit",
            "Gvdiffsplit",
            "Gread",
            "Gwrite",
            "Ggrep",
            "Glgrep",
            "GMove",
            "GRename",
            "GDelete",
            "GRemove",
            "GBrowse",
        },
    },
    {
        "nvim-lualine/lualine.nvim",
        opts = {
            extensions = {
                "fugitive",
            },
        },
    },
}
