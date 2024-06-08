return {
    "ThePrimeagen/git-worktree.nvim",
    dependencies = {
        "nvim-telescope/telescope.nvim",
    },
    opts = {},
    -- stylua: ignore
    keys = {
        { "<leader>fw", function() require("telescope").extensions.git_worktree.git_worktrees() end, desc = "Find Git Worktree" },
        { "<leader>fW", function() require("telescope").extensions.git_worktree.create_git_worktrees() end, desc = "Create Git Worktree" },
    },
    config = function(_, opts)
        require("git-worktree").setup(opts)
        require("telescope").load_extension("git_worktree")
    end,
}
