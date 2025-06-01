---@meta

---@class PS
local ps = {}

---@class JobGrade
---@field name string
---@field payment number

---@class Job
---@field name string
---@field type string
---@field onduty boolean
---@field isboss boolean
---@field grade JobGrade
---@field [string] any

---@class CharInfo
---@field firstname string
---@field lastname string
---@field [string] any

---@class PlayerData
---@field citizenid string
---@field charinfo CharInfo
---@field metadata table<string, any>
---@field job Job
---@field [string] any

-- Core player access
---@param source number
---@return table
function ps.getPlayer(source) end

---@param identifier string
---@return table
function ps.getPlayerByIdentifier(identifier) end

---@param identifier string
---@return table
function ps.getOfflinePlayer(identifier) end

---@param source number
---@return string
function ps.getIdentifier(source) end

---@param source number
---@return string
function ps.getPlayerName(source) end

---@param source number
---@return PlayerData
function ps.getPlayerData(source) end

---@param source number
---@param meta string
---@return any
function ps.getMetadata(source, meta) end

---@param source number
---@param info string
---@return any
function ps.getCharInfo(source, info) end

-- Job / Gang access
---@param source number
---@return Job
function ps.getJob(source) end

---@param source number
---@return string
function ps.getJobName(source) end

---@param source number
---@return string
function ps.getJobType(source) end

---@param source number
---@return boolean
function ps.getJobDuty(source) end

---@param source number
---@param data string
---@return any
function ps.getJobData(source, data) end

---@param source number
---@return number
function ps.getJobGrade(source) end

---@param source number
---@return string
function ps.getJobGradeName(source) end

---@param source number
---@return number
function ps.getJobGradePay(source) end

---@param source number
---@return boolean
function ps.isBoss(source) end

-- All players
---@return number[]
function ps.getAllPlayers() end

---@param source number
---@param location vector3 | {x: number, y: number, z: number}
---@return number
function ps.getDistance(source, location) end

---@param source number
---@param distance number
---@return table[]
function ps.getNearbyPlayers(source, distance) end

---@param jobName string
---@return number
function ps.getJobCount(jobName) end

---@param jobType string
---@return number
function ps.getJobTypeCount(jobType) end

---@param item string
---@param func fun(source: number, item: table)
function ps.createUseable(item, func) end
