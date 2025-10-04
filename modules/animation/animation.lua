
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
    ps.requestAnim(animDictionary)
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

exports('playAnim', ps.playAnim)