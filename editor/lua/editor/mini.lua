require("mini.icons").setup()
require("mini.git").setup()
require("mini.diff").setup({
    view = {
        style = "sign",
        signs = { add = "▎", change = "▎", delete = "▎" },
    },
})
require("mini.statusline").setup({ use_icons = true })
require("mini.surround").setup()

local notify = require("mini.notify")
notify.setup({ lsp_progress = { enable = false } })
vim.notify = notify.make_notify()

local ai = require("mini.ai")
ai.setup({
    custom_textobjects = {
        F = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
        c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
    },
})

local clue = require("mini.clue")
clue.setup({
    window = { config = { width = "auto" } },
    triggers = {
        { mode = "n", keys = "g" },
        { mode = "x", keys = "g" },
        { mode = "n", keys = "z" },
        { mode = "x", keys = "z" },
        { mode = "n", keys = "[" },
        { mode = "n", keys = "]" },
        { mode = "n", keys = "'" },
        { mode = "n", keys = "`" },
        { mode = "x", keys = "'" },
        { mode = "x", keys = "`" },
        { mode = "n", keys = '"' },
        { mode = "x", keys = '"' },
        { mode = "i", keys = "<C-r>" },
        { mode = "c", keys = "<C-r>" },
        { mode = "i", keys = "<C-x>" },
        { mode = "n", keys = "<C-w>" },
    },
    clues = {
        clue.gen_clues.builtin_completion(),
        clue.gen_clues.g(),
        clue.gen_clues.marks(),
        clue.gen_clues.registers(),
        clue.gen_clues.windows(),
        clue.gen_clues.z(),
    },
})

local pick = require("mini.pick")
pick.setup()
vim.ui.select = pick.ui_select

local files = require("mini.files")
files.setup()

vim.keymap.set("n", "<C-p>", function()
    pick.builtin.files()
end)
vim.keymap.set("n", "<M-f>", function()
    pick.builtin.grep_live()
end)
vim.keymap.set("n", "<M-b>", function()
    pick.builtin.buffers()
end)
vim.keymap.set("n", "<M-e>", function()
    local name = vim.api.nvim_buf_get_name(0)
    files.open(vim.uv.fs_stat(name) and name or nil)
end)

require("mini.pairs").setup()
require("editor.completion").setup()

local function around(before, after)
    local col = vim.api.nvim_win_get_cursor(0)[2]
    local line = vim.api.nvim_get_current_line()
    return line:sub(col - before + 1, col) .. "|" .. line:sub(col + 1, col + after)
end

vim.keymap.set("i", "<Space>", function()
    if around(1, 1) == "{|}" then
        return "<Space><Space><Left>"
    end
    return "<Space>"
end, { expr = true })

vim.keymap.set("i", "<BS>", function()
    if around(2, 2) == "{ | }" then
        return vim.keycode("<BS><Del>")
    end
    return require("mini.pairs").bs()
end, { expr = true, replace_keycodes = false })
