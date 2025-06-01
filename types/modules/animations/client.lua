---@meta

---@class PS
local ps = {}

---Load animation directory
---@param animDict string
---@param timeout number? Timeout in milliseconds (default: 10000)
---@return boolean success Returns true if loaded successfully
function ps.loadAnimDict(animDict, timeout) end

---Play animation
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
function ps.playAnim(ped, animDictionary, animationName, blendInSpeed, blendOutSpeed, duration, animFlags, playbackRate, lockX, lockY, lockZ) end
