-- local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })

-- vim.schedule(function()
--   vim.keymap.del("n", '"')
-- end)

vim.schedule(function()
  vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
  -- default oil.nvim keymap
  --   ["g?"] = "actions.show_help",
  --   ["<CR>"] = "actions.select",
  --   ["<C-s>"] = "actions.select_vsplit",
  --   ["<C-h>"] = "actions.select_split",
  --   ["<C-t>"] = "actions.select_tab",
  --   ["<C-p>"] = "actions.preview",
  --   ["<C-c>"] = "actions.close",
  --   ["<C-l>"] = "actions.refresh",
  --   ["-"] = "actions.parent",
  --   ["_"] = "actions.open_cwd",
  --   ["`"] = "actions.cd",
  --   ["~"] = "actions.tcd",
  --   ["gs"] = "actions.change_sort",
  --   ["gx"] = "actions.open_external",
  --   ["g."] = "actions.toggle_hidden",
end)
