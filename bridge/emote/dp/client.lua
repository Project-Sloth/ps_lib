-- Play an emote
---@param emote string Play an emote by its name
---@param variant string? Optional variant for the emote
function ps.playEmote(emote, variant)
    return TriggerEvent('animations:client:EmoteCommandStart', {emote})
end

-- Cancel an emote
---@param skipReset? boolean
function ps.cancelEmote(skipReset)
    return TriggerEvent('animations:client:EmoteCommandStart', {"c"})
end