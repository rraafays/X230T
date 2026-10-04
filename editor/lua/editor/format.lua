local conform = require("conform")
local tools = require("editor.tools")
local overrides = require("editor.overrides")
local nix = require("editor.nix")

local by_ft = vim.tbl_extend("force", tools.formatters, overrides.formatters)

local function base_command(name, config, ctx)
    local command = require("conform.formatters." .. name).command
    if type(command) == "function" then
        command = command(config, ctx)
    end
    return command
end

local configs = {}
for _, names in pairs(by_ft) do
    for _, name in ipairs(names) do
        if not configs[name] then
            configs[name] = {
                command = function(self, ctx)
                    local command = base_command(name, self, ctx)
                    return nix.bin(command) or command
                end,
            }
        end
    end
end

configs.stylua = vim.tbl_extend("force", configs.stylua or {}, {
    prepend_args = function(_, ctx)
        if vim.fs.root(ctx.dirname, { ".stylua.toml", "stylua.toml", ".editorconfig" }) then
            return {}
        end
        local buf = ctx.buf
        return {
            "--indent-type",
            vim.bo[buf].expandtab and "Spaces" or "Tabs",
            "--indent-width",
            tostring(vim.api.nvim_buf_call(buf, vim.fn.shiftwidth)),
        }
    end,
})

conform.setup({
    formatters_by_ft = by_ft,
    formatters = vim.tbl_deep_extend("force", configs, overrides.formatter_config),
    format_on_save = { timeout_ms = 1000, lsp_format = "fallback" },
    notify_no_formatters = false,
})

vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        for _, name in ipairs(conform.list_formatters_for_buffer(args.buf)) do
            local info = conform.get_formatter_info(name, args.buf)
            if not info.available and vim.fn.executable(info.command) == 0 then
                nix.ensure(info.command, function() end)
            end
        end
    end,
})
