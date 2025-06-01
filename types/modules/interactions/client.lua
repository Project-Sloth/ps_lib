---@meta

---@class PS
local ps = {}

--- drawText
---@param text string
function ps.drawText(text) end

--- hideText
function ps.hideText() end

--- notify
---@param text string
---@param type? string
---@param time? integer
function ps.notify(text, type, time) end

--- progressbar
---@param text string
---@param time? integer
---@param emote? string
function ps.progressbar(text, time, emote) end


--- minigame
---@param type 'ps-circle' | 'ps-maze' | 'ps-scrambler' | 'ps-varhack' | 'ps-thermite' | 'ox'
---@param values 'amount' | 'speed' | 'timeLimit' | 'type' | 'blocks' | 'gridsize' | 'wrong' | 'input' | 'difficulty'
function ps.minigame(type, values) end