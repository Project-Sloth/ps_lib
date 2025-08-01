
local props = {}
local IsInEmote = false
local emotes = {
    ["tablet2"] = {
        dict = "amb@code_human_in_bus_passenger_idles@female@tablet@idle_a",
        anim = "idle_a",
        AnimationOptions = {
            Prop = "prop_cs_tablet",
            PropBone = 28422,
            PropPlacement = {
                -0.05,
                0.0,
                0.0,
                0.0,
                -90.0,
                0.0
            },
            EmoteLoop = true,
            EmoteMoving = true
        }
    },
    ['openDoor'] = {
        dict = "anim@heists@keycard@",
        anim = 'exit',
    },
    ['uncuff'] = {
        dict = "mp_arresting",
        anim = "a_uncuff",
        
    },
   
}


-- Play an emote
---@param emote string Play an emote by its name
---@param variant string? Optional variant for the emote

function ps.playEmote(emote, variant)
    if emotes[emote] then
        ps.playAnims(emote)
        IsInEmote = true
        return
    end
    return exports["rpemotes"]:EmoteCommandStart(emote, variant)
end

-- Cancel an emote
function ps.cancelEmote()
    if IsInEmote then
        if #props > 0 then
            for emote, prop in pairs(props) do
                if DoesEntityExist(prop) then
                    DeleteEntity(prop)
                    props[emote] = nil
                    IsInEmote = false
                    ClearPedTasks(PlayerPedId())
                    return
                end
            end
        else
            IsInEmote = false
            ClearPedTasks(PlayerPedId())
            return
        end
    end
    return exports["rpemotes"]:EmoteCancel()
end


local function listener()
    CreateThread(function()
        while IsInEmote do
            local ped = PlayerPedId()
            if IsControlPressed(0, 73) or IsControlPressed(0, 177) then
                ps.cancelEmote()
            end
            Wait(0)
        end
    end)
end

function ps.playAnims(emote)
    if not emotes[emote] then
        ps.warn('Emote not found: ' .. emote)
        return
    end
    local anim = emotes[emote]
    if not ps.requestAnim(anim.dict) then
        ps.warn('Failed to load animation dictionary: ' .. anim.dict)
        return
    end
    if anim.AnimationOptions and anim.AnimationOptions.Prop then
        if not ps.requestModel(GetHashKey(anim.AnimationOptions.Prop)) then
            ps.warn('Failed to load prop model: ' .. anim.AnimationOptions.Prop)
            return
        end
        IsInEmote = true
        props[emote] = CreateObject(
            GetHashKey(anim.AnimationOptions.Prop),
            0.0, 0.0, 0.0,
            true, true, true
        )
        AttachEntityToEntity(
            props[emote],
            PlayerPedId(),
            GetPedBoneIndex(PlayerPedId(), anim.AnimationOptions.PropBone or 28422),
            anim.AnimationOptions.PropPlacement[1] or 0.0,
            anim.AnimationOptions.PropPlacement[2] or 0.0,
            anim.AnimationOptions.PropPlacement[3] or 0.0,
            anim.AnimationOptions.PropPlacement[4] or 0.0,
            anim.AnimationOptions.PropPlacement[5] or 0.0,
            anim.AnimationOptions.PropPlacement[6] or 0.0,
            true, true, false, true, 1, true
        )
        listener()
        TaskPlayAnim(
            PlayerPedId(),
            anim.dict,
            anim.anim,
            8.0, -8.0, -1, 49, 0, false, false, false
        )
    else
        IsInEmote = true
        listener()
        TaskPlayAnim(
            PlayerPedId(),
            anim.dict,
            anim.anim,
            8.0, -8.0, -1, 49, 0, false, false, false
        )
    end
end
