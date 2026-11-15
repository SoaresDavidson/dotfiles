-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "QQ", "<cmd>qa<cr>", { desc = "Quit all" })
vim.keymap.set("n", "<leader>mt", "<cmd>!make test>cr>", { desc = "Run make test" })
vim.keymap.set("n", "<leader>dk", function()
  Snacks.terminal("lazydocker", {
    cwd = LazyVim.root(),
    esc_esc = false,
    ctrl_hjkl = false,
    win = { style = "terminal", border = "rounded", width = 0.9, height = 0.9 },
  })
end, { desc = "Lazydocker" })
