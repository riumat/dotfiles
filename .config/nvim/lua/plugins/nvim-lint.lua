return {
    "mfussenegger/nvim-lint",
    opts = {
        linters_by_ft = {},
    },
    config = function(_, opts)
        require("lint").linters_by_ft = opts.linters_by_ft

        vim.api.nvim_create_autocmd({ "BufWritePost" }, {
            callback = function()
                require("lint").try_lint()

                -- You can call `try_lint` with a linter name or a list of names to always
                -- run specific linters, independent of the `linters_by_ft` configuration
                -- require("lint").try_lint("cspell")
            end,
        })
    end,
}
