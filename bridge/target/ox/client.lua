local zones = {}

function ps.boxTarget(name, location, size, options)
    if not name then return end
    local resource = GetInvokingResource() or 'ps_lib'
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
    zones[resource][name] = exports.ox_target:addBoxZone({
        name = name,
        coords = location,
        size = vec3(size.length, size.width, size.height),
        rotation = size.rotation,
        options = compat,
        debug = false
    })
    ps.debug('Creating target: ' .. name)
end

function ps.circleTarget(name, location, size, options)
    if not name then return end
    local compat = {}
    local resource = GetInvokingResource() or 'ps_lib'
    if not zones[resource] then
        zones[resource] = {}
    end
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
    zones[resource][name] = exports.ox_target:addSphereZone({
         name = name,
         coords = location,
         radius = size,
         options = compat,
         debug = false
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
    exports.ox_target:addLocalEntity(entity, compat) 
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
    exports.ox_target:addModel(entity, compat)
end

function ps.destroyAllTargets()
    for resourceName, resourceZones in pairs(zones) do
        ps.debug('Destroying all targets for resource: ' .. resourceName)
        for key, name in pairs(zones[resourceName]) do
            ps.debug('Destroying target: ' .. name)
            exports.ox_target:removeZone(name)
        end
    end
    zones = {}
end

function ps.destroyTarget(name)
    if not name then return end
    exports.ox_target:removeZone(zones[GetInvokingResource() or 'ps_lib'][name])
    ps.debug('Destroying target: ' .. name)
    zones[GetInvokingResource() or 'ps_lib'][name] = nil
end

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() or resourceName == 'ps_lib' then
        ps.destroyAllTargets()
    end
    if zones[resourceName] then
        for k, v in pairs(zones[resourceName]) do
            exports.ox_target:removeZone(v)
        end
        zones[resourceName] = nil
    end
end)