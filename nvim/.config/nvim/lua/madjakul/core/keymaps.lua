-- lua/madjakul/core/keymaps.lua
-- Global keymaps (plugin-specific keymaps live in their own files)

vim.g.mapleader = " "

local keymap = vim.keymap

-- ====== General ======
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })
keymap.set("n", "<C-s>", ":w<esc>", { desc = "Save current file" })

-- ====== Window Management ======
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

-- ====== Tab Management ======
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

-- ====== AI (Copilot + Avante) ======
keymap.set("n", "<leader>cpd", ":Copilot disable<CR>", { silent = true, noremap = true, desc = "Disable Copilot" })
keymap.set("n", "<leader>cpe", ":Copilot enable<CR>", { silent = true, noremap = true, desc = "Enable Copilot" })
-- Avante chat: <leader>aa to toggle, <leader>ae to edit selection (set in avante.lua)
