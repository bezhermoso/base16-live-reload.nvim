# ⚡ base16-live-reload.nvim

![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/ellisonleao/nvim-plugin-template/lint-test.yml?branch=main&style=for-the-badge)
![Lua](https://img.shields.io/badge/Made%20with%20Lua-blueviolet.svg?style=for-the-badge&logo=lua)

Automatically sync up Neovim colorscheme with your terminal [base16-shell theme](https://github.com/tinted-theming/base16-shell)!

## Installation & Configuration

Via [`lazy.nvim`](https://github.com/folke/lazy.nvim):

```lua
{
  "bezhermoso/base16-live-reload.nvim",
  dependencies = {
    { "RRethy/nvim-base16" },  -- REQUIRED!
    { "rktjmp/fwatch.nvim" },  -- REQUIRED!
  },
  config = function ()
    require("base16-colorscheme").setup(...) -- Setup nvim-base16
    require("base16-live-reload").setup({
      callback = function () -- Optional callback when theme is reloaded.
        vim.notify("base16-shell changed. neovim colorscheme synced!", vim.log.levels.INFO)
      end
    })
  end
}
```
