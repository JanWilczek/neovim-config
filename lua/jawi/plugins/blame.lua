return {
  "FabijanZulj/blame.nvim",
  config = function ()
    require("blame").setup({
      virtual_style = "float",
      merge_consecutive = true,
    })
  end
}

