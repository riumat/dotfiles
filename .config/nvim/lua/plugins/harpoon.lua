return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    -- stylua: ignore
    keys = {
        { "<leader>h", function() require("harpoon"):list():add() end, desc = "Harpoon: mark file" },
        { "<leader>sh", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Harpoon: show list" },

        { "<leader>1", function() require("harpoon"):list():select(1) end, desc = "Harpoon: mark 1" },
        { "<leader>2", function() require("harpoon"):list():select(2) end, desc = "Harpoon: mark 2" },
        { "<leader>3", function() require("harpoon"):list():select(3) end, desc = "Harpoon: mark 3" },
        { "<leader>4", function() require("harpoon"):list():select(4) end, desc = "Harpoon: mark 4" },
        { "<leader>5", function() require("harpoon"):list():select(4) end, desc = "Harpoon: mark 5" },
    },
}
