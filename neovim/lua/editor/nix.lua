local tools = require("editor.tools")

local M = {}

local resolved = {}
local waiting = {}

function M.bin(exe)
    if vim.fn.executable(exe) == 1 then
        return exe
    end
    return resolved[exe]
end

local function locate(output, exe)
    for _, path in ipairs(vim.split(output, "\n", { trimempty = true })) do
        local candidate = path .. "/bin/" .. exe
        if vim.fn.executable(candidate) == 1 then
            return candidate
        end
    end
end

local function run(callbacks, path)
    for _, callback in ipairs(callbacks) do
        local ok, err = pcall(callback, path)
        if not ok then
            vim.notify(("editor: %s"):format(err), vim.log.levels.ERROR)
        end
    end
end

local function provide(exe, callback)
    local found = M.bin(exe)
    if found then
        return callback(found)
    end

    local attr = tools.packages[exe]
    if not attr then
        return callback(nil)
    end

    if waiting[exe] then
        return table.insert(waiting[exe], callback)
    end

    waiting[exe] = { callback }
    vim.system(
        { "nix-build", vim.g.nixpkgs_path, "-A", attr, "--no-out-link" },
        { text = true },
        vim.schedule_wrap(function(result)
            local callbacks = waiting[exe]
            waiting[exe] = nil

            local path = result.code == 0 and locate(result.stdout, exe) or nil
            if path then
                resolved[exe] = path
            else
                vim.notify(("editor: could not fetch %s from nixpkgs"):format(attr), vim.log.levels.WARN)
            end
            run(callbacks, path)
        end)
    )
end

local function expose(path)
    local dir = vim.fs.dirname(path)
    if dir ~= "." and not vim.env.PATH:find(dir, 1, true) then
        vim.env.PATH = vim.env.PATH .. ":" .. dir
    end
end

function M.ensure(exe, callback)
    if not (M.bin(exe) or tools.packages[exe]) then
        return false
    end

    local queue = vim.deepcopy(tools.dependencies[exe] or {})
    table.insert(queue, exe)

    local function step(index)
        provide(queue[index], function(path)
            if not path then
                return
            end
            if index < #queue then
                expose(path)
                return step(index + 1)
            end
            callback(path)
        end)
    end

    step(1)
    return true
end

return M
