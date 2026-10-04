local M = {}

local mini_pairs
local mini_snippets

function M.lsp_snippet_insert(snippet)
    if _G.MiniSnippets then
        MiniSnippets.default_insert({ body = snippet }, {
            empty_tabstop = "",
            empty_tabstop_final = "",
        })
        return
    end
    require("mini.completion").default_snippet_insert(snippet)
end

function M.place_info_right(win_id)
    if not vim.api.nvim_win_is_valid(win_id) then
        return
    end

    local pum = vim.fn.pum_getpos()
    if not pum or not pum.col or pum.col < 0 then
        return
    end

    local border = 2
    local pum_right = pum.col + pum.width + (pum.scrollbar and 1 or 0)
    local space_right = vim.o.columns - pum_right - border
    if space_right < 24 then
        return
    end

    local config = vim.api.nvim_win_get_config(win_id)
    local width = math.min(config.width or 72, space_right)

    vim.api.nvim_win_set_config(win_id, vim.tbl_extend("force", config, {
        relative = "editor",
        anchor = "NW",
        row = pum.row,
        col = pum_right,
        width = width,
        height = config.height,
    }))
end

local function snippet_active()
    return mini_snippets.session.get() ~= nil
end

local ctrl_n = vim.api.nvim_replace_termcodes("<C-n>", true, false, true)
local ctrl_p = vim.api.nvim_replace_termcodes("<C-p>", true, false, true)

local function cr_action()
    if vim.fn.pumvisible() == 1 then
        return "\25"
    end
    return mini_pairs.cr()
end

local function tab_action()
    if snippet_active() then
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
    if snippet_active() then
        mini_snippets.session.jump("prev")
        return ""
    end
    if vim.snippet.active({ direction = -1 }) then
        vim.snippet.jump(-1)
        return ""
    end
    local shift_tab = vim.api.nvim_replace_termcodes("<S-Tab>", true, false, true)
    return vim.fn.pumvisible() == 1 and ctrl_p or shift_tab
end

function M.setup_keymaps()
    _G.editor_cr_action = cr_action
    vim.keymap.set("i", "<CR>", "v:lua.editor_cr_action()", { expr = true })
    vim.keymap.set({ "i", "s" }, "<Tab>", function()
        return tab_action()
    end, { expr = true })
    vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
        return stab_action()
    end, { expr = true })
end

function M.setup_info_window()
    vim.api.nvim_create_autocmd("User", {
        group = vim.api.nvim_create_augroup("EditorCompletionInfo", { clear = true }),
        pattern = { "MiniCompletionWindowOpen", "MiniCompletionWindowUpdate" },
        callback = function(ev)
            if ev.data.kind ~= "info" then
                return
            end
            vim.schedule(function()
                M.place_info_right(ev.data.win_id)
            end)
        end,
    })
end

--- All LSP completion UX (snippets, docs pane, accept keys) in one place.
function M.setup()
    mini_snippets = require("mini.snippets")
    mini_pairs = require("mini.pairs")

    mini_snippets.setup({
        mappings = {
            expand = "",
            jump_next = "<C-l>",
            jump_prev = "<C-h>",
        },
    })

    vim.o.completeopt = "menuone,noselect,fuzzy"

    require("mini.completion").setup({
        window = {
            info = { height = 25, width = 72, border = "rounded" },
            signature = { height = 25, width = 72, border = "rounded" },
        },
        lsp_completion = {
            snippet_insert = M.lsp_snippet_insert,
        },
    })

    M.setup_info_window()
    M.setup_keymaps()
end

return M
