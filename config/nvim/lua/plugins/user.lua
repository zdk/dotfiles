-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- You can also add or configure plugins by creating files in this `plugins/` folder
-- Here are some examples:

---@type LazySpec
return {

  {
    "catppuccin/nvim",
    name = "catppuccin",
    config = function()
      require("catppuccin").setup {
        flavour = "latte",
        integrations = {
          treesitter = true,
          lsp_trouble = true,
          telescope = true,
          which_key = true,
        },
      }
      vim.cmd.colorscheme "catppuccin-latte"
    end,
  },
  { "andweeb/presence.nvim" },
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require("lsp_signature").setup() end,
  },

  -- == Examples of Overriding Plugins ==

  -- customize alpha options
  {
    "goolord/alpha-nvim",
    opts = function(_, opts)
      -- customize the dashboard header
      opts.section.header.val = {
        " █████  ███████ ████████ ██████   ██████",
        "██   ██ ██         ██    ██   ██ ██    ██",
        "███████ ███████    ██    ██████  ██    ██",
        "██   ██      ██    ██    ██   ██ ██    ██",
        "██   ██ ███████    ██    ██   ██  ██████",
        " ",
        "    ███    ██ ██    ██ ██ ███    ███",
        "    ████   ██ ██    ██ ██ ████  ████",
        "    ██ ██  ██ ██    ██ ██ ██ ████ ██",
        "    ██  ██ ██  ██  ██  ██ ██  ██  ██",
        "    ██   ████   ████   ██ ██      ██",
      }
      return opts
    end,
  },

  -- You can disable default plugins as follows:
  { "max397574/better-escape.nvim", enabled = false },

  -- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
  {
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.luasnip"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom luasnip configuration such as filetype extend or custom snippets
      local luasnip = require "luasnip"
      luasnip.filetype_extend("javascript", { "javascriptreact" })
    end,
  },

  {
    "windwp/nvim-autopairs",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom autopairs configuration such as custom rules
      local npairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"
      npairs.add_rules(
        {
          Rule("$", "$", { "tex", "latex" })
            -- don't add a pair if the next character is %
            :with_pair(cond.not_after_regex "%%")
            -- don't add a pair if  the previous character is xxx
            :with_pair(
              cond.not_before_regex("xxx", 3)
            )
            -- don't move right when repeat character
            :with_move(cond.none())
            -- don't delete if the next character is xx
            :with_del(cond.not_after_regex "xx")
            -- disable adding a newline when you press <cr>
            :with_cr(cond.none()),
        },
        -- disable for .vim files, but it work for another filetypes
        Rule("a", "a", "-vim")
      )
    end,
  },
  {
    "copilot.lua",
    opts = {
      suggestion = {
        keymap = {
          accept = "<C-l>",
          accept_word = false,
          accept_line = false,
          next = "<C-.>",
          prev = "<C-,>",
          dismiss = "<C/>",
        },
      },
    },
  },
  {
    "someone-stole-my-name/yaml-companion.nvim",
    requires = {
      { "neovim/nvim-lspconfig" },
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope.nvim" },
    },
    config = function()
      local cfg = require("yaml-companion").setup {
        -- detect k8s schemas based on file content
        builtin_matchers = {
          kubernetes = { enabled = true },
        },

        -- schemas available in Telescope picker
        schemas = {
          -- not loaded automatically, manually select with
          -- :Telescope yaml_schema
          {
            name = "Argo CD Application",
            uri = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json",
          },
          {
            name = "SealedSecret",
            uri = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/bitnami.com/sealedsecret_v1alpha1.json",
          },
          -- schemas below are automatically loaded, but added
          -- them here so that they show up in the statusline
          {
            name = "Kustomization",
            uri = "https://json.schemastore.org/kustomization.json",
          },
          {
            name = "GitHub Workflow",
            uri = "https://json.schemastore.org/github-workflow.json",
          },
        },

        lspconfig = {
          settings = {
            yaml = {
              validate = true,
              schemaStore = {
                enable = false,
                url = "",
              },

              -- schemas from store, matched by filename
              -- loaded automatically
              schemas = require("schemastore").yaml.schemas {
                select = {
                  "kustomization.yaml",
                  "GitHub Workflow",
                },
              },
            },
          },
        },
      }

      require("lspconfig")["yamlls"].setup(cfg)
      require("telescope").load_extension "yaml_schema"
    end,
  },
  -- {
  --   "b0o/SchemaStore.nvim",
  --   lazy = true,
  --   dependencies = {
  --     {
  --       "AstroNvim/astrolsp",
  --       optional = true,
  --       ---@type AstroLSPOpts
  --       opts = {
  --         ---@diagnostic disable: missing-fields
  --         config = {
  --           yamlls = {
  --             on_new_config = function(config)
  --               config.settings.yaml.schemas = vim.tbl_deep_extend(
  --                 "force",
  --                 config.settings.yaml.schemas or {},
  --                 require("schemastore").yaml.schemas()
  --               )
  --             end,
  --             -- settings = { yaml = { schemaStore = { enable = true, url = "" } } },
  --             settings = {
  --               schemaStore = {
  --                 enable = true,
  --                 url = "https://www.schemastore.org/api/json/catalog.json",
  --               },
  --               yaml = {
  --                 format = {
  --                   enable = true,
  --                   singleQuote = true,
  --                   printWidth = 120,
  --                 },
  --                 hover = true,
  --                 completion = true,
  --                 validate = true,
  --                 schemas = {
  --                   ["https://json.schemastore.org/kustomization.json"] = "kustomization.{yml,yaml}",
  --                   ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
  --                   ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
  --                   ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
  --                   ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
  --                   ["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
  --                   ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
  --                   ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-compose*.{yml,yaml}",
  --                   ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] = "*flow*.{yml,yaml}",
  --                   ["https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json"] = "/*argocd_app.yaml",
  --                   ["https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/applicationset_v1alpha1.json"] = "/*argocd_appset.yaml",
  --                   ["https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/appproject_v1alpha1.json"] = "/*argocd_project.yaml",
  --                 },
  --               },
  --             },
  --           },
  --         },
  --       },
  --     },
  --   },
  -- },
}
