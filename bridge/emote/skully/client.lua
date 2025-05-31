-- Play an emote
---@param emote string Play an emote by its name
---@param variant string? Optional variant for the emote
function ps.playEmote(emote, variant)
    return exports.scully_emotemenu:playEmoteByCommand(emote, variant)
end

-- Cancel an emote
function ps.cancelEmote()
    return exports.scully_emotemenu:cancelEmote()
end