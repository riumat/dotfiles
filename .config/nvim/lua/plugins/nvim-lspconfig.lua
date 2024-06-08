return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "folke/neoconf.nvim",
            "folke/neodev.nvim",
        },
        event = { "VeryLazy" },
        opts = {
            servers = {},
        },
        config = function(_, opts)
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(event)
                    vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Lsp Hover" })
                    vim.keymap.set(
                        "n",
                        "gd",
                        require("telescope.builtin").lsp_definitions,
                        { desc = "Go to definition" }
                    )
                    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
                    vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, { desc = "Go to reference" })
                    vim.keymap.set(
                        "n",
                        "gi",
                        require("telescope.builtin").lsp_implementations,
                        { desc = "Go to implementation" }
                    )
                    vim.keymap.set(
                        "n",
                        "<leader>fd",
                        require("telescope.builtin").lsp_type_definitions,
                        { desc = "Telescope type definitions" }
                    )
                    vim.keymap.set(
                        "n",
                        "<leader>fs",
                        require("telescope.builtin").lsp_document_symbols,
                        { desc = "Telescope document symbols" }
                    )
                    vim.keymap.set(
                        "n",
                        "<leader>fws",
                        require("telescope.builtin").lsp_dynamic_workspace_symbols,
                        { desc = "Telescope workspace symbols" }
                    )
                    vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Lsp Rename" })
                    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Lsp Code Action" })
                end,
            })

            local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")

            require("mason-lspconfig").setup({
                automatic_installation = true,
                ensure_installed = vim.tbl_keys(opts.servers),
                handlers = {
                    function(server_name)
                        local server = opts.servers[server_name] or {}
                        server.capabilities = vim.tbl_deep_extend(
                            "force",
                            {},
                            vim.lsp.protocol.make_client_capabilities(),
                            has_cmp and cmp_nvim_lsp.default_capabilities() or {},
                            server.capabilities or {}
                        )
                        require("lspconfig")[server_name].setup(server)
                    end,
                },
            })
        end,
    },
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        build = ":MasonUpdate",
        opts = {
            ensure_installed = {},
        },
        config = function(_, opts)
            require("mason").setup(opts)
            require("mason-registry"):on("package:install:success", function()
                vim.defer_fn(function()
                    require("lazy.core.handler.event").trigger({
                        event = "FileType",
                        bug = vim.api.nvim_get_current_buf(),
                    })
                end, 100)
            end)
        end,
    },
    {
        "folke/neodev.nvim",
        dependencies = {
            "folke/neoconf.nvim",
        },
        opts = {},
    },
    {
        "folke/neoconf.nvim",
        cmd = "Neoconf",
        opts = {},
    },
}
