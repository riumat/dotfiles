return {
    "stevearc/conform.nvim",
    dependencies = {
        "williamboman/mason.nvim",
    },
    opts = {
        format_on_save = {
            lsp_fallback = true,
            timeout_ms = 1000,
        },
    },
    cmd = { "ConformInfo" },
    event = { "BufWritePre" },
    -- stylua: ignore
    keys = {
        { "<leader>cf", function() require("conform").format({ lsp_fallback = true }) end, desc = "Format Code" },
    },
}
