local tools = require("editor.tools")
local overrides = require("editor.overrides")
local nix = require("editor.nix")

local severity = vim.diagnostic.severity

local sign = {
    [severity.ERROR] = vim.fn.nr2char(0xf057),
    [severity.WARN] = vim.fn.nr2char(0xf071),
    [severity.INFO] = vim.fn.nr2char(0xf05a),
    [severity.HINT] = vim.fn.nr2char(0xf0eb),
}

vim.diagnostic.config({
    virtual_text = {
        spacing = 2,
        prefix = function()
            return "●"
        end,
    },
    severity_sort = true,
    signs = { text = sign },
})

vim.lsp.config("*", { capabilities = require("mini.completion").get_lsp_capabilities() })

vim.lsp.config("lua_ls", {
    on_init = function(client)
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
