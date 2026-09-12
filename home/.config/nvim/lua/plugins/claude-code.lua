return {
  "greggh/claude-code.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = { "ClaudeCodeToggle" }, -- Lazy loads the plugin only when called
  keys = {
    { "<leader>ai", "<cmd>ClaudeCodeToggle<cr>", desc = "Toggle Claude Code" },
  },
  opts = {
    -- Inline the alias: shell aliases don't resolve in :terminal
    command = "CLAUDE_CONFIG_DIR=~/.claude-work claude",
    -- window = { position = "right", size = "40%" }
  },
  config = function(_, opts) require("claude-code").setup(opts) end,
}
