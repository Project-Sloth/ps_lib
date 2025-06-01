---@meta

---@class PS
local ps = {}

---Get full player data table (depends on framework)
---@return table
function ps.getPlayerData() end

---Get unique player identifier (e.g., citizenid or identifier)
---@return string
function ps.getIdentifier() end

---Get specific metadata field
---@param meta string
---@return any
function ps.getMetadata(meta) end

---Get specific character info field (e.g., firstname, lastname)
---@param info string
---@return any
function ps.getCharInfo(info) end

---Get player's full name (e.g., "John Doe")
---@return string
function ps.getPlayerName() end

---Get the player's ped (entity ID)
---@return number
function ps.getPlayer() end

---Get display name for a vehicle (based on model or entity)
---@param model number
---@return string|false
function ps.getVehicleLabel(model) end

---Check if the player is dead or in a "laststand" state
---@return boolean
function ps.isDead() end

---Get current job data table
---@return table
function ps.getJob() end

---Get player's job name
---@return string
function ps.getJobName() end

---Get player's job type
---@return string
function ps.getJobType() end

---Check if the player is a job boss
---@return boolean
function ps.isBoss() end

---Check if the player is on job duty
---@return boolean
function ps.getJobDuty() end

---Get specific job data field
---@param data string
---@return any
function ps.getJobData(data) end

---Get current gang data table
---@return table
function ps.getGang() end

---Get player's gang name
---@return string
function ps.getGangName() end

---Check if the player is a gang boss
---@return boolean
function ps.isLeader() end

---Check if the player is on gang duty
---@return boolean
function ps.getGangDuty() end

---Get specific gang data field
---@param data string
---@return any
function ps.getGangData(data) end
