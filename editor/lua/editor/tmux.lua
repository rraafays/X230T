-- Tmux-aware split navigation; tmux forwards M-arrows when @vim is set on the pane.

local M = {}

local TMUX_SELECT = {
  h = "L",
  j = "D",
  k = "U",
  l = "R",
}

---@type { exe?: string, socket?: string, setup?: boolean }
local cached = {}

---@param args string[]
local function tmux(args)
  if not vim.env.TMUX then
    return
  end

  if not cached.exe then
    cached.exe = vim.fn.exepath("tmux") ~= "" and vim.fn.exepath("tmux") or "tmux"
  end
  if not cached.socket then
    cached.socket = vim.split(vim.env.TMUX, ",")[1]
  end

  vim.system({ cached.exe, "-S", cached.socket, unpack(args) }):wait()
end

---@param enabled boolean
function M.set_vim_pane_flag(enabled)
  if not vim.env.TMUX_PANE then
    return
  end

  tmux({ "set-option", "-p", "-t", vim.env.TMUX_PANE, "@vim", enabled and "1" or "0" })
end

---@param direction "h"|"j"|"k"|"l"
function M.navigate(direction)
  local from_winnr = vim.fn.winnr()
  vim.cmd("wincmd " .. direction)

  if vim.fn.winnr() == from_winnr and vim.env.TMUX then
    local select_flag = TMUX_SELECT[direction]
    if select_flag then
      tmux({ "select-pane", "-t", vim.env.TMUX_PANE, "-" .. select_flag })
    end
  end
end

local function map_nav(mode, lhs, direction, opts)
  vim.keymap.set(mode, lhs, function()
    M.navigate(direction)
  end, opts)
end

function M.setup()
  if cached.setup then
    return
  end
  cached.setup = true

  local opts = { desc = "Tmux navigate" }
  map_nav("n", "<A-Left>", "h", vim.tbl_extend("force", opts, { desc = "Tmux navigate left" }))
  map_nav("n", "<A-Down>", "j", vim.tbl_extend("force", opts, { desc = "Tmux navigate down" }))
  map_nav("n", "<A-Up>", "k", vim.tbl_extend("force", opts, { desc = "Tmux navigate up" }))
  map_nav("n", "<A-Right>", "l", vim.tbl_extend("force", opts, { desc = "Tmux navigate right" }))

  if vim.env.TMUX then
    local term_nav = function(direction)
      return function()
        vim.cmd("stopinsert")
        M.navigate(direction)
      end
    end
    vim.keymap.set("t", "<A-Left>", term_nav("h"), opts)
    vim.keymap.set("t", "<A-Down>", term_nav("j"), opts)
    vim.keymap.set("t", "<A-Up>", term_nav("k"), opts)
    vim.keymap.set("t", "<A-Right>", term_nav("l"), opts)
  end

  local group = vim.api.nvim_create_augroup("TmuxNav", { clear = true })

  vim.api.nvim_create_autocmd({ "VimEnter", "VimResume" }, {
    group = group,
    callback = function()
      M.set_vim_pane_flag(true)
    end,
  })

  vim.api.nvim_create_autocmd("VimLeave", {
    group = group,
    callback = function()
      M.set_vim_pane_flag(false)
    end,
  })

  M.set_vim_pane_flag(true)
end

M.setup()

return M
