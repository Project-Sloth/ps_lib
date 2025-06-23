-- Credit:
-- https://github.com/Manason/mana_audio

---@param src number
---@param data PlaySoundParams
local function playSound(src, data)
    TriggerClientEvent('ps_lib:client:playSound', src, data)
end

exports('PlaySound', playSound)

local function playSoundFromEntity(data)
    TriggerClientEvent('ps_lib:client:playSoundFromEntity', -1, {
        audioBank = data.audioBank,
        audioName = data.audioName,
        audioRef = data.audioRef,
        netId = data.netId or NetworkGetNetworkIdFromEntity(data.entity),
    })
end

---@param data PlaySoundFromEntityParams
exports('PlaySoundFromEntity', playSoundFromEntity)

local function playSoundFromCoords(data)
    TriggerClientEvent('ps_lib:client:playSoundFromCoords', -1, data)
end

exports('PlaySoundFromCoords', playSoundFromCoords)