local color_map = vim.api.nvim_get_color_map()

local ansi = {}
for index, hue in ipairs({ "Red", "Green", "Yellow", "Blue", "Magenta", "Cyan" }) do
    ansi[color_map["NvimDark" .. hue]] = index
    ansi[color_map["NvimLight" .. hue]] = index + 8
end
ansi[color_map.NvimDarkGrey4] = 8
ansi[color_map.NvimLightGrey4] = 8

local overrides = {
    StatusLine = {},
    StatusLineNC = { ctermfg = 8 },
    MiniStatuslineModeNormal = { cterm = { bold = true } },
    MiniStatuslineModeInsert = { cterm = { bold = true } },
    MiniStatuslineModeVisual = { cterm = { bold = true } },
    MiniStatuslineModeReplace = { cterm = { bold = true } },
    MiniStatuslineModeCommand = { cterm = { bold = true } },
    MiniStatuslineModeOther = { cterm = { bold = true } },
    MiniStatuslineDevinfo = { ctermfg = 8 },
    MiniStatuslineFilename = {},
    MiniStatuslineFileinfo = { ctermfg = 8 },
    MiniStatuslineInactive = { ctermfg = 8 },

    NormalFloat = {},
    FloatBorder = { ctermfg = 8 },
    Pmenu = {},
    PmenuSel = { cterm = { reverse = true } },
    PmenuKind = {},
    PmenuExtra = { ctermfg = 8 },
    PmenuSbar = {},
    PmenuThumb = { ctermbg = 8 },
    PmenuBorder = { ctermfg = 8 },

    MiniFilesCursorLine = { cterm = { reverse = true } },
    MiniPickMatchCurrent = { cterm = { reverse = true } },
    MiniPickPreviewLine = { cterm = { reverse = true } },
}

local function apply()
    if vim.g.colors_name ~= "default" then
        return
    end

    for name, def in pairs(vim.api.nvim_get_hl(0, {})) do
        if not def.link then
            local update = {}
            if def.fg and not def.ctermfg then
                update.ctermfg = ansi[def.fg]
            end
            if def.bg and not def.ctermbg then
                update.ctermbg = ansi[def.bg]
            end
            if next(update) then
                vim.api.nvim_set_hl(0, name, vim.tbl_extend("force", def, update))
            end
        end
    end

    for name, def in pairs(overrides) do
        vim.api.nvim_set_hl(0, name, def)
    end
end

apply()
vim.api.nvim_create_autocmd("ColorScheme", { callback = apply })
