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
require("mini.snippets").setup()
require("mini.completion").setup()

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

local mini_pairs = require("mini.pairs")
local mini_snippets = require("mini.snippets")
mini_pairs.setup()

local function snippet_session()
    return mini_snippets.session.get()
end

local function cr_action()
    if vim.fn.complete_info({ "selected" }).selected ~= -1 then
        return "\25"
    end
    if snippet_session() then
        mini_snippets.session.jump("next")
        return ""
    end
    if vim.fn.pumvisible() == 1 then
        return "\27"
    end
    return mini_pairs.cr()
end

local ctrl_n = vim.api.nvim_replace_termcodes("<C-n>", true, false, true)
local ctrl_p = vim.api.nvim_replace_termcodes("<C-p>", true, false, true)

local function tab_action()
    if snippet_session() then
        mini_snippets.session.jump("next")
        return ""
    end
    if vim.snippet.active({ direction = 1 }) then
        vim.snippet.jump(1)
        return ""
    end
    return vim.fn.pumvisible() == 1 and ctrl_n or "\t"
end

local function stab_action()
    if snippet_session() then
        mini_snippets.session.jump("prev")
        return ""
    end
    if vim.snippet.active({ direction = -1 }) then
        vim.snippet.jump(-1)
        return ""
    end
    return vim.fn.pumvisible() == 1 and ctrl_p or "\t"
end

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
    return mini_pairs.bs()
end, { expr = true, replace_keycodes = false })

_G.editor_cr_action = cr_action
vim.keymap.set("i", "<CR>", "v:lua.editor_cr_action()", { expr = true })

vim.keymap.set({ "i", "s" }, "<Tab>", function()
    return tab_action()
end, { expr = true })

vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
    return stab_action()
end, { expr = true })

vim.keymap.set("s", "<CR>", "v:lua.editor_cr_action()", { expr = true })

vim.api.nvim_create_autocmd("CompleteDone", {
    callback = function()
        vim.schedule(function()
            if snippet_session() or vim.snippet.active() then
                return
            end
            if vim.fn.mode() == "s" then
                vim.cmd.stopinsert()
                vim.cmd.startinsert(true)
            end
        end)
    end,
})
