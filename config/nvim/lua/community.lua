-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  -- vim motion
  { import = "astrocommunity.motion.mini-surround" },
  -- pack (base)
  { import = "astrocommunity.pack.html-css" },
  { import = "astrocommunity.pack.yaml" },
  -- pack
  { import = "astrocommunity.pack.bash" },
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.docker" },
  { import = "astrocommunity.pack.go" },
  { import = "astrocommunity.pack.ruby" },
  { import = "astrocommunity.pack.typescript" },
  -- code runner
  { import = "astrocommunity.code-runner.sniprun" },
  -- editing support
  { import = "astrocommunity.editing-support.neogen" },
  -- markdown & latex
  { import = "astrocommunity.markdown-and-latex.peek-nvim" },
  -- completion
  { import = "astrocommunity.completion.copilot-lua" },
}
