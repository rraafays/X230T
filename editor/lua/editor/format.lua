local conform = require("conform")
local tools = require("editor.tools")
local overrides = require("editor.overrides")
local nix = require("editor.nix")

local INDENT = 4

local by_ft = vim.tbl_extend("force", tools.formatters, overrides.formatters)

local function base_command(name, config, ctx)
    local command = require("conform.formatters." .. name).command
    if type(command) == "function" then
        command = command(config, ctx)
    end
    return command
end

local function has_project_config(dirname, markers)
    return vim.fs.root(dirname, markers) ~= nil
end

local rubocop_config_path
local function default_rubocop_config()
    if rubocop_config_path and vim.fn.filereadable(rubocop_config_path) == 1 then
        return rubocop_config_path
    end
    rubocop_config_path = vim.fn.stdpath("cache") .. "/editor-rubocop-4space.yml"
    if vim.fn.filereadable(rubocop_config_path) == 0 then
        vim.fn.writefile({
            "AllCops:",
            "  NewCops: enable",
            "Layout/IndentationWidth:",
            "  Width: 4",
        }, rubocop_config_path)
    end
    return rubocop_config_path
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
        if has_project_config(ctx.dirname, { ".stylua.toml", "stylua.toml", ".editorconfig" }) then
            return {}
        end
        return { "--indent-type", "Spaces", "--indent-width", tostring(INDENT) }
    end,
})

configs.prettier = vim.tbl_extend("force", configs.prettier or {}, {
    prepend_args = function(_, ctx)
        if has_project_config(ctx.dirname, {
            ".prettierrc",
            ".prettierrc.json",
            ".prettierrc.yaml",
            ".prettierrc.yml",
            "prettier.config.js",
            "prettier.config.cjs",
            "prettier.config.mjs",
        }) then
            return {}
        end
        return { "--tab-width", tostring(INDENT), "--use-tabs", "false" }
    end,
})

configs["google-java-format"] = vim.tbl_extend("force", configs["google-java-format"] or {}, {
    prepend_args = { "--aosp" },
})

configs["clang-format"] = vim.tbl_extend("force", configs["clang-format"] or {}, {
    prepend_args = function(_, ctx)
        if has_project_config(ctx.dirname, { ".clang-format", "_clang-format" }) then
            return {}
        end
        local style = string.format("{IndentWidth: %d, TabWidth: %d, UseTab: Never}", INDENT, INDENT)
        return { "-style", style }
    end,
})

configs.ruff_format = vim.tbl_extend("force", configs.ruff_format or {}, {
    prepend_args = function(_, ctx)
        if has_project_config(ctx.dirname, { "pyproject.toml", "ruff.toml", ".ruff.toml" }) then
            return {}
        end
        return { "--config", string.format("indent-width=%d", INDENT) }
    end,
})

configs.taplo = vim.tbl_extend("force", configs.taplo or {}, {
    prepend_args = function(_, ctx)
        if has_project_config(ctx.dirname, { "taplo.toml", ".taplo.toml" }) then
            return {}
        end
        return { "--option", "indent_string=" .. string.rep(" ", INDENT) }
    end,
})

configs.shfmt = vim.tbl_extend("force", configs.shfmt or {}, {
    args = function(_, ctx)
        local args = { "-filename", "$FILENAME" }
        if not has_project_config(ctx.dirname, { ".editorconfig" }) then
            vim.list_extend(args, { "-i", tostring(INDENT) })
        end
        return args
    end,
})

configs.rubocop = vim.tbl_extend("force", configs.rubocop or {}, {
    prepend_args = function(_, ctx)
        if has_project_config(ctx.dirname, { ".rubocop.yml", ".rubocop.yaml" }) then
            return {}
        end
        return { "--config", default_rubocop_config() }
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
