return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = { -- extend the plugin options
      diagnostics = {
        -- disable diagnostics virtual text
        virtual_text = false,
      },
    },
  },
  -- schema-companion owns yamlls; stop astrolsp from also setting it up.
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = { handlers = { yamlls = false } },
  },
  -- customize blink.cmp mappings (v6 uses blink.cmp instead of nvim-cmp)
  {
    "saghen/blink.cmp",
    -- pin to v1: `main` is v2, which needs a separate blink.lib plugin + nvim 0.12.
    -- v1 ships prebuilt fuzzy binaries, no build step needed.
    version = "1.*",
    opts = function(_, opts)
      opts.keymap = opts.keymap or {}
      -- <C-x> selects the next completion item
      opts.keymap["<C-x>"] = { "select_next", "fallback" }
    end,
  },

  -- customize the dashboard (v6 uses snacks.dashboard instead of alpha-nvim)
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      local get_icon = require("astroui").get_icon
      opts.dashboard = opts.dashboard or {}
      opts.dashboard.preset = opts.dashboard.preset or {}
      -- custom cat header
      opts.dashboard.preset.header = table.concat({
        [[ ███████████████████████████ ]],
        [[ ███████▀▀▀░░░░░░░▀▀▀███████ ]],
        [[ ████▀░░░░░░░░░░░░░░░░░▀████ ]],
        [[ ███│░░░░░░░░░░░░░░░░░░░│███ ]],
        [[ ██▌│░░░░░░░░░░░░░░░░░░░│▐██ ]],
        [[ ██░└┐░░░░░░░░░░░░░░░░░┌┘░██ ]],
        [[ ██░░└┐░░░░░░░░░░░░░░░┌┘░░██ ]],
        [[ ██░░┌┘▄▄▄▄▄░░░░░▄▄▄▄▄└┐░░██ ]],
        [[ ██▌░│██████▌░░░▐██████│░▐██ ]],
        [[ ███░│▐███▀▀░░▄░░▀▀███▌│░███ ]],
        [[ ██▀─┘░░░░░░░▐█▌░░░░░░░└─▀██ ]],
        [[ ██▄░░░▄▄▄▓░░▀█▀░░▓▄▄▄░░░▄██ ]],
        [[ ████▄─┘██▌░░░░░░░▐██└─▄████ ]],
        [[ █████░░▐█─┬┬┬┬┬┬┬─█▌░░█████ ]],
        [[ ████▌░░░▀┬┼┼┼┼┼┼┼┬▀░░░▐████ ]],
        [[ █████▄░░░└┴┴┴┴┴┴┴┘░░░▄█████ ]],
        [[ ███████▄░░░░░░░░░░░▄███████ ]],
        [[ ██████████▄▄▄▄▄▄▄██████████ ]],
      }, "\n")
      -- custom buttons (action = the keymap to run)
      opts.dashboard.preset.keys = {
        { key = "n", action = "<Leader>n", icon = get_icon("FileNew", 0, true), desc = "New File  " },
        { key = "w", action = "<Leader>Wo", icon = get_icon("FolderOpen", 0, true), desc = "Workspaces  " },
        { key = "o", action = "<Leader>fo", icon = get_icon("DefaultFile", 0, true), desc = "Recents  " },
        { key = "f", action = "<Leader>ff", icon = get_icon("Search", 0, true), desc = "Find File  " },
        { key = "g", action = "<Leader>fw", icon = get_icon("WordFile", 0, true), desc = "Find Word  " },
        { key = "s", action = "<Leader>Sl", icon = get_icon("Refresh", 0, true), desc = "Last Session  " },
      }
    end,
  },
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      -- go = "go",
      disable_defaults = true,
      -- diagnostics = false,
      -- diagnostic = { -- set diagnostic to false to disable vim.diagnostic.config setup,
      --   -- true: default nvim setup
      --   underline = true,
      --   virtual_text = { spacing = 4, prefiex = ":diagnostic:" }, -- prefix = "" }, -- virtual text setup
      --   signs = { "", "", "", "" }, -- set to true to use default signs, an array of 4 to specify custom signs
      --   update_in_insert = false,
      -- },
      diagnostic = { -- set diagnostic to false to disable vim.diagnostic setup
        hdlr = true, -- hook lsp diag handler and send diag to quickfix
        underline = true,
        -- virtual text setup
        virtual_text = { spacing = 0, prefix = "■" },
        signs = true,
        update_in_insert = false,
      },
    },
    config = function() require("go").setup() end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    -- Prevents Neovim from freezing on plugin installation/update.
    -- See: <https://github.com/ray-x/go.nvim/issues/433>
    build = function() require("go.install").update_all() end,
  },
}
