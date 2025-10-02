
function ps.requestModel(model, timeout)
    timeout = timeout or 15000
    local startTime = GetGameTimer()
    RequestModel(model)
    while not HasModelLoaded(model) do
        if GetGameTimer() - startTime > timeout then
            ps.debug('requestModel timed out', model, GetGameTimer() - startTime)
            return false
        end
        Wait(0)
    end
    return true
end

function ps.requestAnim(dict, timeout)
    timeout = timeout or 15000
    local startTime = GetGameTimer()
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        if GetGameTimer() - startTime > timeout then
             ps.debug('requestAnim timed out', dict, GetGameTimer() - startTime)
            return false
        end
        Wait(0)
    end
    return true
end

function ps.requestPTFX(dict, timeout)
    timeout = timeout or 15000
    local startTime = GetGameTimer()
    RequestNamedPtfxAsset(dict)
    while not HasNamedPtfxAssetLoaded(dict) do
        if GetGameTimer() - startTime > timeout then
            ps.debug('requestPTFX timed out', dict, GetGameTimer() - startTime)
            return false
        end
        Wait(0)
    end
    return true
end

exports('requestModel', ps.requestModel)
exports('requestAnim', ps.requestAnim)
exports('requestPTFX', ps.requestPTFX)