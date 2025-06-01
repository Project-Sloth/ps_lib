---@meta

---@class PS
local ps = {}

---Check if the player can carry a specific item
---@param source number
---@param item string
---@param amount? number
---@return boolean
function ps.CanCarryItem(source, item, amount) end

---Remove an item from a player
---@param identifier string|number
---@param item string
---@param amount? number
---@param slot? number|false
---@param reason? string
---@return boolean
function ps.removeItem(identifier, item, amount, slot, reason) end

---Add an item to a player's inventory
---@param identifier string|number
---@param item string
---@param amount? number
---@param metadata? table
---@param slot? number|false
---@param reason? string
---@return boolean
function ps.addItem(identifier, item, amount, metadata, slot, reason) end

---Open a stash for the player
---@param source number
---@param identifier string
---@param data { label?: string, maxweight?: number, slots?: number }
function ps.openStash(source, identifier, data) end

---Check if the player has the item
---@param identifier string|number
---@param item string
---@param amount? number
---@return boolean
function ps.hasItem(identifier, item, amount) end

---Opens inventory on ID
---@param source number
---@param playerid? number|false
function ps.openInventoryById(source, playerid) end

---Get Item image
---@param item string
function ps.getImage(item) end

---Get Item label
---@param item string
---@return string
function ps.getLabel(item) end