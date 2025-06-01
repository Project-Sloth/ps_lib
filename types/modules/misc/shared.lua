---@meta

---@class PS
local ps = {}

---@param tab table
---@param key key
function ps.sorter(tab, key) end

---@param tab table
---@param str string
function ps.concat(tab, str) end

---@param str string
function ps.stringFormat(str, ...) end

---@param num number
---@param decimalPlaces number
function ps.decimalRound(num, decimalPlaces) end

---@param min? number
---@param max? number
function ps.random(min, max) end