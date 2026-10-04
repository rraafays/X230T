local tools = require("editor.tools")
local overrides = require("editor.overrides")
local nix = require("editor.nix")
local notify = require("mini.notify")

local severity = vim.diagnostic.severity

local init_progress = {}

local function mark_lsp_ready(client)
    if client._editor_ready then
        return
    end
    client._editor_ready = true

    local progress_id = init_progress[client.id]
    if progress_id then
        notify.remove(progress_id)
        init_progress[client.id] = nil
    end

    local id = notify.add(("%s initialized"):format(client.name), "INFO")
    vim.defer_fn(function()
        notify.remove(id)
    end, 1500)
end

local default_progress = vim.lsp.handlers["$/progress"]
vim.lsp.handlers["$/progress"] = function(err, result, ctx, config)
    default_progress(err, result, ctx, config)
    if err or type(result) ~= "table" or type(result.value) ~= "table" then
        return
    end

    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if not client or client._editor_ready then
        return
    end

    local value = result.value
    local info = init_progress[client.id .. "_info"] or { title = "", pct = 0 }
    if value.kind == "begin" and value.title then
        info.title = value.title
    end
    info.pct = (value.kind == "end" and 100 or value.percentage) or info.pct
    init_progress[client.id .. "_info"] = info

    local msg = string.format(
        "%s: %s%s%s(%s%%)",
        client.name,
        info.title,
        info.title == "" and "" or " ",
        value.message or "",
        info.pct
    )

    local notif_id = init_progress[client.id]
    if notif_id then
        notify.update(notif_id, { msg = msg })
    else
        init_progress[client.id] = notify.add(msg, "INFO", "MiniNotifyLspProgress")
    end

    if value.kind == "end" then
        init_progress[client.id .. "_info"] = nil
    end
end

local default_show_message = vim.lsp.handlers["window/showMessage"]
vim.lsp.handlers["window/showMessage"] = function(err, params, ctx, config)
    local level = vim.lsp.protocol.MessageType
    if params.type ~= level.Error and params.type ~= level.Warning then
        return params
    end
    return default_show_message(err, params, ctx, config)
end

local sign = {
    [severity.ERROR] = vim.fn.nr2char(0xf057),
    [severity.WARN] = vim.fn.nr2char(0xf071),
    [severity.INFO] = vim.fn.nr2char(0xf05a),
    [severity.HINT] = vim.fn.nr2char(0xf0eb),
}

vim.diagnostic.config({
    virtual_text = {
        current_line = false,
        spacing = 2,
        prefix = function()
            return "●"
        end,
    },
    severity_sort = true,
    signs = { text = sign },
})

local lsp_capabilities = require("mini.completion").get_lsp_capabilities({
    resolve_additional_text_edits = true,
})

vim.lsp.config("*", {
    capabilities = lsp_capabilities,
    on_init = function(client)
        mark_lsp_ready(client)
    end,
})

vim.lsp.config("lua_ls", {
    on_init = function(client)
        mark_lsp_ready(client)
        local folder = client.workspace_folders and client.workspace_folders[1]
        local root = folder and folder.name
        if root and (vim.uv.fs_stat(root .. "/.luarc.json") or vim.uv.fs_stat(root .. "/.luarc.jsonc")) then
            return
        end
        client.config.settings = client.config.settings or {}
        client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua or {}, {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME } },
        })
        client:notify("workspace/didChangeConfiguration", { settings = client.config.settings })
    end,
})

require("editor.java").configure_lsp()

for name, config in pairs(overrides.lsp_config) do
    vim.lsp.config(name, config)
end

local index
local enabled = {}

local function command(name)
    local config = vim.lsp.config[name]
    if config and type(config.cmd) == "table" then
        return config.cmd
    end
    return tools.commands[name]
end

local function build_index()
    index = {}
    local seen = {}
    for _, file in ipairs(vim.api.nvim_get_runtime_file("lsp/*.lua", true)) do
        local name = vim.fn.fnamemodify(file, ":t:r")
        if not seen[name] then
            seen[name] = true
            local ok, config = pcall(function()
                return vim.lsp.config[name]
            end)
            if ok and config.filetypes and command(name) then
                for _, ft in ipairs(config.filetypes) do
                    index[ft] = index[ft] or {}
                    table.insert(index[ft], name)
                end
            end
        end
    end
end

local function servers_for(ft)
    local override = overrides.lsp[ft]
    if override then
        return override, true
    end

    local found = {}
    for _, name in ipairs(index[ft] or {}) do
        if vim.fn.executable(command(name)[1]) == 1 then
            table.insert(found, name)
        end
    end
    if #found > 0 then
        return found, false
    end

    return tools.lsp[ft] or {}, false
end

local function enable(name, explicit)
    if enabled[name] then
        return
    end

    local cmd = command(name)
    if not cmd then
        enabled[name] = true
        vim.lsp.enable(name)
        return
    end

    local available = nix.ensure(cmd[1], function(path)
        if enabled[name] then
            return
        end
        enabled[name] = true
        if vim.fn.executable(cmd[1]) == 0 then
            nix.expose(path)
        end
        vim.lsp.enable(name)
    end)

    if not available and explicit then
        vim.notify(("editor: %s is not on PATH and has no nixpkgs fallback"):format(cmd[1]), vim.log.levels.WARN)
    end
end

vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        if not index then
            build_index()
        end
        local names, explicit = servers_for(args.match)
        for _, name in ipairs(names) do
            enable(name, explicit)
        end
    end,
})
