-- Play an emote
---@param emote string Play an emote by its name
---@param variant string? Optional variant for the emote
function ps.playEmote(emote, variant)
    return exports["rpemotes"]:EmoteCommandStart(emote, variant)
end

-- Cancel an emote
---@param skipReset? boolean
function ps.cancelEmote(skipReset)
    return exports["rpemotes"]:EmoteCancel()
    -- exports["rpemotes-reborn"]:EmoteCancel(forceCancel) – forceCancel is optional
end