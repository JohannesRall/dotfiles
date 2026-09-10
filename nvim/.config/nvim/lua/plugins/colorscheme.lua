local theme = os.getenv("NVIM_THEME") or "latte" -- we’ll just use "latte" or "mocha"

-- Determine Catppuccin flavour
local flavour = theme:match("mocha") and "mocha" or "latte"

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      flavour = flavour, -- latte or mocha
      transparent_background = true,
      integrations = {
        bufferline = true,
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd("colorscheme catppuccin") -- always "catppuccin"
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin", -- always catppuccin
    },
  },
}
