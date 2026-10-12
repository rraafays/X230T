local terminal_bg = {
    Normal = true,
    NormalNC = true,
    NormalFloat = true,
    EndOfBuffer = true,
    MsgArea = true,
    SignColumn = true,
    FoldColumn = true,
    StatusLine = true,
    StatusLineNC = true,
    TabLine = true,
    TabLineFill = true,
    TabLineSel = true,
    WinBar = true,
    WinBarNC = true,
    FloatTitle = true,
    FloatFooter = true,
}

local function apply()
    if vim.g.colors_name ~= "default" then
        return
    end

    for name, hl in pairs(vim.api.nvim_get_hl(0, {})) do
        if terminal_bg[name] and not hl.link and (hl.bg ~= nil or hl.ctermbg ~= nil) then
            vim.api.nvim_set_hl(0, name, { bg = "NONE", ctermbg = "NONE" })
        end
    end

    vim.api.nvim_set_hl(0, "Visual", {
        fg = "NONE",
        bg = "NONE",
        ctermfg = "NONE",
        ctermbg = "NONE",
        cterm = { reverse = true },
        reverse = vim.o.termguicolors,
    })
    vim.api.nvim_set_hl(0, "VisualNOS", { link = "Visual" })
    vim.api.nvim_set_hl(0, "CurSearch", { cterm = { reverse = true, bold = true }, reverse = vim.o.termguicolors })
    vim.api.nvim_set_hl(0, "IncSearch", { link = "CurSearch" })
    vim.api.nvim_set_hl(0, "Search", { cterm = { underline = true, bold = true } })
    vim.api.nvim_set_hl(0, "MatchParen", { cterm = { bold = true, underline = true } })
    vim.api.nvim_set_hl(0, "CursorLine", { cterm = { bold = true } })
    vim.api.nvim_set_hl(0, "MiniPickMatchCurrent", { cterm = { reverse = true }, reverse = vim.o.termguicolors })
    vim.api.nvim_set_hl(0, "MiniPickPreviewLine", { cterm = { reverse = true }, reverse = vim.o.termguicolors })
    vim.api.nvim_set_hl(0, "MiniFilesCursorLine", { cterm = { reverse = true }, reverse = vim.o.termguicolors })

    vim.api.nvim_set_hl(0, "Pmenu", { reverse = false })
    vim.api.nvim_set_hl(0, "PmenuKind", { reverse = false })
    vim.api.nvim_set_hl(0, "PmenuExtra", { reverse = false })
    vim.api.nvim_set_hl(0, "PmenuSbar", { reverse = false })
    vim.api.nvim_set_hl(0, "PmenuThumb", { reverse = false })
    vim.api.nvim_set_hl(0, "PmenuSel", {
        fg = "NONE",
        bg = "NONE",
        ctermfg = "NONE",
        ctermbg = "NONE",
        cterm = { reverse = true },
        reverse = vim.o.termguicolors,
    })
end

apply()
vim.api.nvim_create_autocmd("ColorScheme", { callback = apply })
