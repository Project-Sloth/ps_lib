function loadLib(filePath)
    local resourceName = 'ps_lib'
    local fullScript = LoadResourceFile(resourceName, filePath)
    if not fullScript then
        ps.error("Error: Failed to load module '" .. filePath .. "' from resource '" .. resourceName .. "'.")
        return false
    end
    local chunk, err = load(fullScript, filePath, "t", _ENV)
    if not chunk then
        ps.error("Error loading Lua chunk from '" .. filePath .. "': " .. tostring(err))
        return false
    end

    local success, execErr = pcall(chunk)
    if not success then
        ps.error("Error executing Lua chunk from '" .. filePath .. "': " .. tostring(execErr))
        return false
    end
    return true
end

-- TODO: test this function
function ps.loadFile(filePath)
    local fileName = GetInvokingResource()
    local fullScript = LoadResourceFile(fileName, filePath)
    if not fullScript then
        ps.error("Error: Failed to load module '" .. filePath .. "' from resource '" .. fileName .. "'.")
        return false
    end
    local chunk, err = load(fullScript, filePath, "t", _ENV)
    if not chunk then
        ps.error("Error loading Lua chunk from '" .. filePath .. "': " .. tostring(err))
        return false
    end

    local success, execErr = pcall(chunk)
    if not success then
        ps.error("Error executing Lua chunk from '" .. filePath .. "': " .. tostring(execErr))
        return false
    end
    return true
end