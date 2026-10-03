local o = vim.o

o.number = true
o.signcolumn = "yes"
o.tabstop = 4
o.shiftwidth = 4
o.expandtab = true
o.clipboard = "unnamedplus"
o.undofile = true
o.showmode = false
o.cmdheight = 0
o.laststatus = 3
o.winborder = "rounded"
o.pumborder = "rounded"
o.termguicolors = false
o.wildmode = "noselect:lastused,full"
o.wildoptions = "pum,tagfile"

vim.cmd.colorscheme("default")

vim.api.nvim_create_autocmd("CmdlineChanged", {
    pattern = { ":", "/", "?" },
    callback = function()
        vim.fn.wildtrigger()
    end,
})

for _, key in ipairs({ "<Up>", "<Down>" }) do
    vim.keymap.set("c", key, function()
        return vim.fn.wildmenumode() == 1 and "<C-e>" .. key or key
    end, { expr = true })
end

require("vim._core.ui2").enable({ msg = { targets = "msg" } })
