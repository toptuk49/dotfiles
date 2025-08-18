-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.lua" },
  -- frontend
  { import = "astrocommunity.pack.html-css" },
  { import = "astrocommunity.pack.angular" },
  { import = "astrocommunity.pack.tailwindcss" },
  { import = "astrocommunity.pack.typescript" },
  { import = "astrocommunity.pack.vue" },
  -- python
  { import = "astrocommunity.pack.python" },
  -- system
  { import = "astrocommunity.pack.bash" },
  -- csharp
  { import = "astrocommunity.pack.cs-omnisharp" },
  -- import/override with your plugins folder
}
