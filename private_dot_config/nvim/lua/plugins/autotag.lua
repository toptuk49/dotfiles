return {
  "windwp/nvim-ts-autotag",
  event = "VeryLazy",
  config = function()
    require("nvim-ts-autotag").setup({
      filetypes = {
        "html",
        "javascript",
        "javascriptreact",
        "typescriptreact",
        "vue",
        "tsx",
        "jsx",
        "xml",
      },
    })
  end,
}
