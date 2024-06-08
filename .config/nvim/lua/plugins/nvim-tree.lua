local function open_in_current_buffer()
    local winid = vim.api.nvim_get_current_win()
    require("nvim-tree.api").tree.open({ find_file = true, winid = winid })
    require("nvim-tree.api").tree.open({ winid = winid })
end

local function open_node_with_cmd(cmd)
    ---@type Node
    local node = require("nvim-tree.api").tree.get_node_under_cursor()
    vim.cmd(cmd .. " " .. node.absolute_path)
end

return {
    {
        "nvim-tree/nvim-tree.lua",
        lazy = false,
        dependecies = {
            "nvim-tree/nvim-web-devicons",
        },
        keys = {
            { "<leader>sf", open_in_current_buffer, desc = "Open File Tree", silent = true },
        },
        opts = {
            -- Many of the options aim to make it more similar to Netrw by treating it as a normal buffer
            -- https://github.com/Gelio/ubuntu-dotfiles/pull/1/files

            sync_root_with_cwd = true,
            reload_on_bufenter = false,
            respect_buf_cwd = true,

            diagnostics = {
                enable = true,
            },

            actions = {
                use_system_clipboard = false,
                change_dir = {
                    enable = false,
                },
                open_file = {
                    eject = false,
                    resize_window = false,
                },
            },

            on_attach = function(bufnr)
                local opts = function(desc)
                    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
                end

                local api = require("nvim-tree.api")

                api.config.mappings.default_on_attach(bufnr)

                vim.keymap.set("n", "<C-e>", api.node.open.replace_tree_buffer, opts("Open: In Place"))
                vim.keymap.set("n", "o", api.node.open.replace_tree_buffer, opts("Open: In Place"))
                vim.keymap.set("n", "<CR>", api.node.open.replace_tree_buffer, opts("Open: In Place"))
                vim.keymap.set("n", "<2-LeftMouse>", api.node.open.replace_tree_buffer, opts("Open: In Place"))

                vim.keymap.set("n", "<C-v>", function()
                    open_node_with_cmd("leftabove vsplit")
                end, opts("Open: Vertical Split"))

                vim.keymap.set("n", "<C-x>", function()
                    open_node_with_cmd("rightbelow split")
                end, opts("Open: Horizontal Split"))

                vim.keymap.set("n", "<C-t>", function()
                    open_node_with_cmd("tabnew")
                end, opts("Open: New Tab"))
            end,
        },

        init = function()
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1

            require("nvim-tree.view").View.winopts.winfixwidth = false
            require("nvim-tree.view").View.winopts.winfixheight = false
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        opts = {
            extensions = {
                "nvim_tree",
            },
        },
    },
}
