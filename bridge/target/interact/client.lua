local zones = {}

function ps.boxTarget(name, location, size, options)
    if not name then return end
    local resource = GetInvokingResource()
    if not zones[resource] then
        zones[resource] = {}
    end
    size = {
        length = size.length or 1.0,
        width = size.width or 1.0,
        height = size.height or 1.0,
        rotation = size.rotation or 180.0,
    }
    local compat = {}
    for k, v in pairs(options) do
        table.insert(compat,{
		    icon = v.icon or "fa-solid fa-eye",
            label = v.label,
            event = v.event or nil,
            action = v.action or nil,
		    onSelect = v.action or nil,
            data = v.data,
            canInteract = v.canInteract or nil,
            distance = 2.0,
	    })
    end
    zones[resource][name] = name
    exports.interact:AddInteraction(
    {
        coords = vector3(location.x, location.y,location.z),
        distance = 8.0,
        interactDst = 2.0,
        id = name,
        name = name
    },
    {
        options = compat,
    })
end

function ps.circleTarget(name, location, size, options)
    if not name then return end
    local resource = GetInvokingResource()
    if not zones[resource] then
        zones[resource] = {}
    end
    local compat = {}
    for k, v in pairs(options) do
        table.insert(compat,{
		    icon = v.icon or "fa-solid fa-eye",
            label = v.label,
            event = v.event or nil,
            action = v.action or nil,
		    onSelect = v.action or nil,
            data = v.data,
            canInteract = v.canInteract or nil,
            distance = 2.0,
	    })
    end
    zones[resource][name] = name
    exports.interact:AddInteraction(
    {
        coords = vector3(location.x, location.y,location.z),
        distance = 8.0,
        interactDst = 2.0,
        id = name,
        name = name
    },
    {
        options = compat,
    })
end

function ps.entityTarget(entity, options)
    local compat = {}
    for k, v in pairs(options) do
        table.insert(compat,{
    	    icon = v.icon or "fa-solid fa-eye",
            label = v.label,
            event = v.event or nil,
            action = v.action or nil,
    	    onSelect = v.action or nil,
            data = v.data,
            canInteract = v.canInteract or nil,
            distance = 2.0,
    	})
    end
    exports.interact:AddLocalEntityInteraction({entity = entity, name = entity, id = entity, distance = 8.0, interactDst = 2.0, options = compat})
end

function ps.targetModel(entity, options)
    local compat = {}
    for k, v in pairs(options) do
        table.insert(compat,{
    	    icon = v.icon or "fa-solid fa-eye",
            label = v.label,
            event = v.event or nil,
            action = v.action or nil,
    	    onSelect = v.action or nil,
            data = v.data,
            canInteract = v.canInteract or nil,
            distance = 2.0,
    	})
    end
    exports.interact:AddTargetModel(entity, {options = compat, distance = 3.5})
end

function ps.destroyAllTargets()
    local resource = GetInvokingResource() or GetCurrentResourceName()
    if zones[resource] then
        for k, v in pairs(zones[resource]) do
            exports.interact:RemoveInteraction(v)
        end
    end
end

function ps.destroyTarget(name)
    if not name then return end
    local resource = GetInvokingResource()
    exports.interact:RemoveInteraction(zones[resource][name])
    zones[resource][name] = nil
end

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        ps.destroyAllTargets()
    end
    if zones[resourceName] then
        for k, v in pairs(zones[resourceName]) do
            exports.interact:RemoveInteraction(v)
        end
        zones[resourceName] = nil
    end
end)

exports('boxTarget', ps.boxTarget)
exports('circleTarget', ps.circleTarget)
exports('entityTarget', ps.entityTarget)
exports('targetModel', ps.targetModel)
exports('destroyAllTargets', ps.destroyAllTargets)
exports('destroyTarget', ps.destroyTarget)
ps.success('Target Module Loaded: Interact Target')