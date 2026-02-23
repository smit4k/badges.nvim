<h1 align='center'>
    badges.nvim
</h1>
<p align='center'>
  <b>Insert markdown badges, directly inside Neovim!</b>
</p>

<p align='center'>
        <img src= https://img.shields.io/badge/Lua-2C2D72?style=for-the-badge&logo=lua&logoColor=white>
</p>

## Features

- Insert badges from a built-in catalog
- Choose different badge styles & set a default style

## Installation

Prerequisites: Neovim >= 0.8

Use your favorite plugin manager!

```lua
{
    "smit4k/badges.nvim"
    config = function()
        require("badges").setup()
    end
}
```
