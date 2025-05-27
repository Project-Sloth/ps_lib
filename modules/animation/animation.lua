---@param animDict string
---@param timeout number? Timeout in milliseconds (default: 10000)
---@return boolean success Returns true if loaded successfully
function ps.loadAnimDict(animDict, timeout)
    if type(animDict) ~= 'string' then
        error(("ps.loadAnimDict: Expected animDict to be string, got %s^0"):format(type(animDict)))
        return false
    end

    if HasAnimDictLoaded(animDict) then
        return true
    end

    if not DoesAnimDictExist(animDict) then
        error(("ps.loadAnimDict: Animation dictionary '%s' does not exist^0"):format(animDict))
        return false
    end

    timeout = timeout or 10000
    local startTime = GetGameTimer()

    RequestAnimDict(animDict)

    while not HasAnimDictLoaded(animDict) do
        if GetGameTimer() - startTime > timeout then
            print(("ps.loadAnimDict: Timeout loading animation dictionary '%s'^0"):format(animDict))
            return false
        end
        Wait(0)
    end

    return true
end

---@param ped number
---@param animDictionary string
---@param animationName string
---@param blendInSpeed number
---@param blendOutSpeed number
---@param duration integer
---@param animFlags integer
---@param playbackRate number
---@param lockX boolean
---@param lockY boolean
---@param lockZ boolean
function ps.playAnim(ped, animDictionary, animationName, blendInSpeed, blendOutSpeed, duration, animFlags, playbackRate, lockX, lockY, lockZ)
    -- as far as I can tell, TaskPlayAnim already requests the animDict?
    TaskPlayAnim(
	    ped,
        animDictionary,
        animationName,
        blendInSpeed or 8.0,
        blendOutSpeed or -8.0,
        duration or -1,
        animFlags or 0,
        playbackRate or 0,
        lockX or false,
        lockY or false,
        lockZ or false
    )
    RemoveAnimDict(animDictionary)
end