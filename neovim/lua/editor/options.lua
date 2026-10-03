local o = vim.o

o.number = true
o.tabstop = 4
o.shiftwidth = 4
o.expandtab = true
o.clipboard = "unnamedplus"
o.undofile = true
o.showmode = false
o.cmdheight = 0
o.laststatus = 3
o.winborder = "single"
o.pumborder = "single"
o.termguicolors = false

vim.cmd.colorscheme("default")

require("vim._core.ui2").enable({ msg = { targets = "msg" } })
