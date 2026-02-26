local builtin = require("telescope.builtin")

-- ========================
-- Telescope keybindings
-- ========================
vim.keymap.set("n", "<C-p>", function()
  require("telescope.builtin").find_files({ hidden = true })
end, { desc = "Find files"})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })

-- ========================
-- Neo-tree keybindings
-- ========================
vim.keymap.set("n", "<C-e>", ":Neotree filesystem reveal left<CR>", { desc = "Toggle file tree" })
vim.keymap.set("n", "<leader>o", ":Neotree focus<CR>", { desc = "Focus file tree" })
vim.keymap.set("n", "<leader>hh", ":Neotree toggle show_hidden_files<CR>", { desc = "Toggle hidden files" })

-- ========================
-- Treesitter incremental selection
-- ========================
vim.keymap.set("n", "gnn", ":TSNodeUnderCursor<CR>", { desc = "Init node selection" })
vim.keymap.set("v", "grn", ":TSIncrementalSelectionNode<CR>", { desc = "Increment selection" })
vim.keymap.set("v", "grc", ":TSIncrementalSelectionScope<CR>", { desc = "Increment scope" })
vim.keymap.set("v", "grm", ":TSDecrementSelectionNode<CR>", { desc = "Decrement selection" })

-- ========================
-- Basic Vim convenience
-- ========================
vim.keymap.set("n", "<C-s>", ":w<CR>", { desc = "Save file" })
vim.keymap.set("n", "<C-q>", ":q<CR>", { desc = "Quit" })
vim.keymap.set("n", "<C-S-q>", ":q!<CR>", { desc = "Force Quit"})
vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>", { desc = "Clear search highlight" })

-- ========================
-- Window navigation (like VS Code splits)
-- ========================
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })
