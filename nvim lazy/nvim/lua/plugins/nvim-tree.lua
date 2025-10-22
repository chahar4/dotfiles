return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
      local nvimtree = require("nvim-tree") 
      vim.g.leaded_netrw = 1
      vim.g.leaded_netrwPlugin = 1


    require("nvim-tree").setup {}

    vim.keymap.set("n" , "<c-n>" , ":NvimTreeFindFileToggle<CR>")
  end,
}
