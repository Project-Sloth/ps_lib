function loadLib(filePath)
    local resourceName = 'ps_lib'
    local fullScript = LoadResourceFile(resourceName, filePath)

    if not fullScript then
        ps.error("Error: Failed to load module '" .. filePath .. "' from resource '" .. resourceName .. "'.")
        return false
    end
    return true
end

-- TODO: test this function
function ps.loadFile(filePath)
    local fileName = GetInvokingResource()
    local fullScript = LoadResourceFile(fileName, filePath)
    if not fullScript then
        ps.error("Error: Failed to load file '" .. filePath .. "' from resource '" .. fileName .. "'.")
        return false
    end
    return true
end