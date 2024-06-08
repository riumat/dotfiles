-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/tailwind.lua
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/yaml.lua
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/json.lua
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/typescript.lua

return {
    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {
                "js-debug-adapter",
                "prettierd",
                "prettier",
            },
        },
    },
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {

                tailwindcss = {
                    filetypes_exclude = { "markdown" },
                    filetypes_include = {},
                },

                yamlls = {
                    capabilities = {
                        textDocument = {
                            foldingRange = {
                                dynamicRegistration = false,
                                lineFoldingOnly = true,
                            },
                        },
                    },
                    -- lazy-load schemastore when needed
                    on_new_config = function(new_config)
                        new_config.settings.yaml.schemas = vim.tbl_deep_extend(
                            "force",
                            new_config.settings.yaml.schemas or {},
                            require("schemastore").yaml.schemas()
                        )
                    end,
                    settings = {
                        redhat = { telemetry = { enabled = false } },
                        yaml = {
                            keyOrdering = false,
                            format = {
                                enable = true,
                            },
                            validate = true,
                            schemaStore = {
                                -- Must disable built-in schemaStore support to use
                                -- schemas from SchemaStore.nvim plugin
                                enable = false,
                                -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
                                url = "",
                            },
                        },
                    },
                },

                jsonls = {
                    -- lazy-load schemastore when needed
                    on_new_config = function(new_config)
                        new_config.settings.json.schemas = new_config.settings.json.schemas or {}
                        vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
                    end,
                    settings = {
                        json = {
                            format = {
                                enable = true,
                            },
                            validate = { enable = true },
                        },
                    },
                },

                tsserver = {
                    keys = {
                        {
                            "<leader>co",
                            function()
                                vim.lsp.buf.code_action({
                                    apply = true,
                                    context = {
                                        only = { "source.organizeImports.ts" },
                                        diagnostics = {},
                                    },
                                })
                            end,
                            desc = "Organize Imports",
                        },
                        {
                            "<leader>cR",
                            function()
                                vim.lsp.buf.code_action({
                                    apply = true,
                                    context = {
                                        only = { "source.removeUnused.ts" },
                                        diagnostics = {},
                                    },
                                })
                            end,
                            desc = "Remove Unused Imports",
                        },
                    },
                    ---@diagnostic disable-next-line: missing-fields
                    settings = {
                        completions = {
                            completeFunctionCalls = true,
                        },
                    },
                },
            },

            setup = {

                tailwindcss = function(_, opts)
                    local tw = require("lspconfig.server_configurations.tailwindcss")
                    opts.filetypes = opts.filetypes or {}
                    vim.list_extend(opts.filetypes, tw.default_config.filetypes)
                    opts.filetypes = vim.tbl_filter(function(ft)
                        return not vim.tbl_contains(opts.filetypes_exclude or {}, ft)
                    end, opts.filetypes)
                    vim.list_extend(opts.filetypes, opts.filetypes_include or {})
                end,
            },
        },
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            { "roobert/tailwindcss-colorizer-cmp.nvim", config = true },
        },
        opts = {},
    },
    {
        "b0o/SchemaStore.nvim",
        lazy = true,
        version = false, -- last release is way too old
    },
    {
        "mfussenegger/nvim-dap",
        opts = function()
            local dap = require("dap")
            if not dap.adapters["pwa-node"] then
                require("dap").adapters["pwa-node"] = {
                    type = "server",
                    host = "localhost",
                    port = "${port}",
                    executable = {
                        command = "node",
                        -- 💀 Make sure to update this path to point to your installation
                        args = {
                            require("mason-registry").get_package("js-debug-adapter"):get_install_path()
                                .. "/js-debug/src/dapDebugServer.js",
                            "${port}",
                        },
                    },
                }
            end
            for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
                if not dap.configurations[language] then
                    dap.configurations[language] = {
                        {
                            type = "pwa-node",
                            request = "launch",
                            name = "Launch file",
                            program = "${file}",
                            cwd = "${workspaceFolder}",
                        },
                        {
                            type = "pwa-node",
                            request = "attach",
                            name = "Attach",
                            processId = require("dap.utils").pick_process,
                            cwd = "${workspaceFolder}",
                        },
                    }
                end
            end
        end,
    },
    {
        "stevearc/conform.nvim",
        opts = function(_, opts)
            for _, lang in pairs({
                "javascript",
                "javascriptreact",
                "typescript",
                "typescriptreact",
                "vue",
                "css",
                "scss",
                "less",
                "html",
                "json",
                "jsonc",
                "yaml",
                "markdown",
                -- "['markdown.mdx']" ,
                "graphql",
                -- "handlebars" ,
            }) do
                opts.formatters_by_ft[lang] = { { "prettierd", "prettier" } }
            end
        end,
    },
}
