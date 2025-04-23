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
  -- customize cmp mappings
  {
    "hrsh7th/nvim-cmp",
    -- override the options table that is used
    -- in the `require("cmp").setup()` call
    opts = function(_, opts)
      -- opts parameter is the default options table
      -- the function is lazy loaded so cmp is able to be required
      local cmp = require "cmp"
      -- modify the mapping part of the table
      opts.mapping["<C-x>"] = cmp.mapping.select_next_item()
    end,
  },

  -- customize alpha-nvim
  {
    "goolord/alpha-nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },

    opts = function(_, opts)
      opts.section.header.val = {
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
      }
      opts.section.header.opts.hl = "DashboardHeader"
      local get_icon = require("astroui").get_icon
      local button = require("alpha.themes.dashboard").button
      opts.section.buttons.val = {
        button("LDR n  ", get_icon("FileNew", 2, true) .. "New File  "),
        button("LDR W o", get_icon("FolderOpen", 2, true) .. "Workspaces  "),
        button("LDR f o", get_icon("DefaultFile", 2, true) .. "Recents  "),
        button("LDR f f", get_icon("Search", 2, true) .. "Find File  "),
        button("LDR f w", get_icon("WordFile", 2, true) .. "Find Word  "),
        button("LDR S l", get_icon("Refresh", 2, true) .. "Last Session  "),
      }
      -- opts.section.header.opts.hl = "DashboardFooter"
      -- local excuse = require "alpha.excuse"
      -- opts.section.footer.val = excuse()
      -- opts.config.layout[1].val = vim.fn.max { 2, vim.fn.floor(vim.fn.winheight(0) * 0.2) }
      -- opts.config.layout[3].val = 5
      -- opts.config.opts.noautocmd = true
      return opts
    end,
    -- config = function(_, opts) require("alpha").setup(opts.config) end,
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
