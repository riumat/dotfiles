-- OPTIONS --

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.g.autoformat = true

vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.cindent = false
vim.opt.expandtab = true
vim.opt.formatoptions = "jcqlnt"
vim.opt.mouse = "a"
vim.opt.grepprg = "rg --vimgrep"
vim.opt.ignorecase = true
vim.opt.linebreak = true
vim.opt.list = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 10
vim.opt.shiftround = true
vim.opt.shiftwidth = 4
vim.opt.sidescrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.smartcase = true
vim.opt.smartindent = false
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.timeoutlen = 300
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.virtualedit = "block"

-- vim.opt.autowrite = true
-- vim.opt.completeopt = "menu,menuone,noselect"
-- vim.opt.conceallevel = 0
-- vim.opt.confirm = true -- Confirm to save changes before exiting modified buffer
-- vim.opt.cursorline = true -- Enable highlighting of the current line
-- vim.opt.formatoptions = "jcqlnt"
-- vim.opt.grepformat = "%f:%l:%c:%m"
-- vim.opt.inccommand = "nosplit" -- preview incremental substitute
-- vim.opt.laststatus = 3 -- global statusline
-- vim.opt.pumblend = 10 -- Popup blend
-- vim.opt.pumheight = 10 -- Maximum number of entries in a popup
-- vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
-- vim.opt.shortmess:append({ W = true, I = true, c = true, C = true })
-- vim.opt.showmode = false -- Dont show mode since we have a statusline
-- vim.opt.smartindent = true -- Insert indents automatically
-- vim.opt.spelllang = { "en" }
-- vim.opt.splitkeep = "screen"

-- if not vim.g.vscode then
--   vim.opt.timeoutlen = 300 -- Lower than default (1000) to quickly trigger which-key
-- end

-- vim.opt.updatetime = 200 -- Save swap file and trigger CursorHold
-- vim.opt.wildmode = "longest:full,full" -- Command-line completion mode
-- vim.opt.winminwidth = 5 -- Minimum window width
-- vim.opt.wrap = false -- Disable line wrap
-- vim.opt.fillchars = {
--   foldopen = "",
--   foldclose = "",
--   fold = " ",
--   foldsep = " ",
--   diff = "╱",
--   eob = " ",
-- }

-- KEYMAPS --

-- better up/down
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- buffers
vim.keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })

-- Clear search with <esc>
vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>")

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true })
vim.keymap.set("x", "n", "'Nn'[v:searchforward]", { expr = true })
vim.keymap.set("o", "n", "'Nn'[v:searchforward]", { expr = true })
vim.keymap.set("n", "N", "'nN'[v:searchforward].'zv'", { expr = true })
vim.keymap.set("x", "N", "'nN'[v:searchforward]", { expr = true })
vim.keymap.set("o", "N", "'nN'[v:searchforward]", { expr = true })

-- Add undo break-points
vim.keymap.set("i", ",", ",<c-g>u")
vim.keymap.set("i", ".", ".<c-g>u")
vim.keymap.set("i", ";", ";<c-g>u")

-- better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- quickfix list
vim.keymap.set("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
vim.keymap.set("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })
vim.keymap.set("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
vim.keymap.set("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })

-- diagnostic
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
vim.keymap.set("n", "]d", function()
    vim.diagnostic.goto_next()
end, { desc = "Next Diagnostic" })
vim.keymap.set("n", "[d", function()
    vim.diagnostic.goto_prev()
end, { desc = "Prev Diagnostic" })
vim.keymap.set("n", "]e", function()
    vim.diagnostic.goto_next({ severity = "ERROR" })
end, { desc = "Next Error" })
vim.keymap.set("n", "[e", function()
    vim.diagnostic.goto_prev({ severity = "ERROR" })
end, { desc = "Prev Error" })
vim.keymap.set("n", "]w", function()
    vim.diagnostic.goto_next({ severity = "WARN" })
end, { desc = "Next Warning" })
vim.keymap.set("n", "[w", function()
    vim.diagnostic.goto_prev({ severity = "WARN" })
end, { desc = "Prev Warning" })

-- AUTOCOMMANDS --

vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "c", "cpp" },
    callback = function()
        vim.bo.commentstring = "//%s"
    end,
})

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
    callback = function()
        if vim.o.buftype ~= "nofile" then
            vim.cmd("checktime")
        end
    end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function(event)
        local exclude = { "gitcommit" }
        local buf = event.buf
        if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
            return
        end
        vim.b[buf].lazyvim_last_loc = true
        local mark = vim.api.nvim_buf_get_mark(buf, '"')
        local lcount = vim.api.nvim_buf_line_count(buf)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "gitcommit", "markdown" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
        vim.opt_local.spell = true
    end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    callback = function(event)
        if event.match:match("^%w%w+:[\\/][\\/]") then
            return
        end
        local file = vim.uv.fs_realpath(event.match) or event.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end,
})
