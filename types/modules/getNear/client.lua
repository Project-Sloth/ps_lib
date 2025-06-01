---@meta

---@class PS
local ps = {}

--- getNearestPed
---@param coords vector
---@param distance number
---@return ped, closestDistance
function ps.getNearestPed(coords, distance) end

--- getNearestVehicle
---@param coords vector
---@param distance number
---@return veh, closestDistance
function ps.getNearestVehicle(coords, distance) end

--- getNearestPlayers
---@param coords vector
---@param distance number
---@return closestPlayer, closestDistance
function ps.getNearestVehicle(coords, distance) end

--- getNearestObject
---@param coords vector
---@param distance number
---@return obj, closestDistance
function ps.getNearestObject(coords, distance) end

--- getNearestObjectOfType
---@param type string
---@param distance number
---@param coords vector
---@return table
function ps.getNearestObjectOfType(type, distance, coords) end

--- getNearbyVehicles
---@param coords vector
---@param distance number
---@return table
function ps.getNearbyVehicles(coords, distance) end

--- getNearbyObjects
---@param coords vector
---@param distance number
---@return table
function ps.getNearbyObjects(coords, distance) end