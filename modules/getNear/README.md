# GetNear Module

The GetNear module provides utility functions for finding nearby entities in FiveM. This module includes functions to locate the nearest players, vehicles, peds, and objects within specified distances.

## Overview

This module is part of the ps_lib framework and provides client-side functions for proximity detection. All functions are optimized for performance and include fallback values for missing parameters.

## Functions

### `ps.getNearestPed(coords, distance)`

Finds the nearest NPC ped within the specified distance.

**Parameters:**
- `coords` (vector3, optional): The coordinates to search from. Defaults to player's current position.
- `distance` (number, optional): Maximum search distance in units. Defaults to 10.0.

**Returns:**
- `ped` (entity): The nearest ped entity, or `'no nearby ped'` if none found
- `distance` (number): Distance to the nearest ped, or `'no nearby ped'` if none found

**Example:**
```lua
local nearestPed, pedDistance = ps.getNearestPed()
if nearestPed ~= 'no nearby ped' then
    print("Found ped at distance: " .. pedDistance)
end

-- With custom parameters
local coords = vector3(100.0, 200.0, 30.0)
local ped, dist = ps.getNearestPed(coords, 15.0)
```

### `ps.getNearestVehicle(coords, distance)`

Finds the nearest vehicle within the specified distance.

**Parameters:**
- `coords` (vector3, optional): The coordinates to search from. Defaults to player's current position.
- `distance` (number, optional): Maximum search distance in units. Defaults to 10.0.

**Returns:**
- `vehicle` (entity): The nearest vehicle entity, or `'no nearby vehicle'` if none found
- `distance` (number): Distance to the nearest vehicle, or `'no nearby vehicle'` if none found

**Example:**
```lua
local nearestVehicle, vehicleDistance = ps.getNearestVehicle()
if nearestVehicle ~= 'no nearby vehicle' then
    local model = GetEntityModel(nearestVehicle)
    print("Found vehicle model: " .. model)
end
```

### `ps.getNearestPlayers(coords, distance)`

Finds the nearest player within the specified distance.

**Parameters:**
- `coords` (vector3, optional): The coordinates to search from. Defaults to player's current position.
- `distance` (number, optional): Maximum search distance in units. Defaults to 10.0.

**Returns:**
- `player` (number): The nearest player ID, or `nil` if none found
- `distance` (number): Distance to the nearest player

**Example:**
```lua
local nearestPlayer, playerDistance = ps.getNearestPlayers()
if nearestPlayer then
    local playerName = GetPlayerName(nearestPlayer)
    print("Nearest player: " .. playerName .. " at distance: " .. playerDistance)
end
```

### `ps.getNearestObject(coords, distance)`

Finds the nearest object within the specified distance.

**Parameters:**
- `coords` (vector3, optional): The coordinates to search from. Defaults to player's current position.
- `distance` (number, optional): Maximum search distance in units. Defaults to 10.0.

**Returns:**
- `object` (entity): The nearest object entity, or `'no nearby object'` if none found
- `distance` (number): Distance to the nearest object, or `'no nearby object'` if none found

**Example:**
```lua
local nearestObject, objectDistance = ps.getNearestObject()
if nearestObject ~= 'no nearby object' then
    local model = GetEntityModel(nearestObject)
    print("Found object model: " .. model)
end
```

### `ps.getNearestObjectOfType(type, distance, coords)`

Finds the nearest object of a specific type/model.

**Parameters:**
- `type` (hash): The model hash of the object type to search for
- `distance` (number, optional): Maximum search distance in units. Defaults to 10.0.
- `coords` (vector3, optional): The coordinates to search from. Defaults to player's current position.

**Returns:**
- `object` (entity): The nearest object of the specified type, or `0` if none found

**Example:**
```lua
local propHash = GetHashKey("prop_atm_01")
local atm = ps.getNearestObjectOfType(propHash, 5.0)
if atm ~= 0 then
    print("Found ATM nearby")
end
```

### `ps.getNearbyPed(coords, distance)`

Gets all peds within the specified distance.

**Parameters:**
- `coords` (vector3, optional): The coordinates to search from. Defaults to player's current position.
- `distance` (number, optional): Maximum search distance in units. Defaults to 25.0.

**Returns:**
- `peds` (table): Array of tables containing `{ped = entity, distance = number}`, or empty table if none found

**Example:**
```lua
local nearbyPeds = ps.getNearbyPed(nil, 30.0)
for i, pedData in ipairs(nearbyPeds) do
    print("Ped " .. i .. " at distance: " .. pedData.distance)
end
```

### `ps.getNearbyVehicles(coords, distance)`

Gets all vehicles within the specified distance.

**Parameters:**
- `coords` (vector3, optional): The coordinates to search from. Defaults to player's current position.
- `distance` (number, optional): Maximum search distance in units. Defaults to 25.0.

**Returns:**
- `vehicles` (table): Array of tables containing `{vehicle = entity, distance = number}`, or empty table if none found

**Example:**
```lua
local nearbyVehicles = ps.getNearbyVehicles()
for i, vehicleData in ipairs(nearbyVehicles) do
    local model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicleData.vehicle))
    print("Vehicle: " .. model .. " at distance: " .. vehicleData.distance)
end
```

### `ps.getNearbyObjects(coords, distance)`

Gets all objects within the specified distance.

**Parameters:**
- `coords` (vector3, optional): The coordinates to search from. Defaults to player's current position.
- `distance` (number, optional): Maximum search distance in units. Defaults to 25.0.

**Returns:**
- `objects` (table): Array of tables containing `{object = entity, distance = number}`, or empty table if none found

**Example:**
```lua
local nearbyObjects = ps.getNearbyObjects(nil, 20.0)
print("Found " .. #nearbyObjects .. " objects nearby")
```

## Usage Notes

### Performance Considerations
- These functions iterate through game pools, so use reasonable distance values
- For frequent calls, consider caching results or using longer intervals
- The "nearby" functions (returning arrays) are more expensive than "nearest" functions

### Distance Units
- All distances are in GTA units (approximately meters)
- Default distances are conservative for performance
- Increase distances cautiously as this affects performance

### Error Handling
- Functions return descriptive strings when no entities are found
- Always check return values before using entities
- Some functions show notifications when no entities are found

### Common Use Cases

**Interaction Systems:**
```lua
-- Check for nearby vehicle to enter
local vehicle, distance = ps.getNearestVehicle()
if vehicle ~= 'no nearby vehicle' and distance < 3.0 then
    -- Show interaction prompt
end
```

**AI/NPC Systems:**
```lua
-- Get all nearby players for NPC reactions
local nearbyPlayers = {}
local player, distance = ps.getNearestPlayers()
if player and distance < 50.0 then
    -- NPC can see player
end
```

**Environment Interaction:**
```lua
-- Find specific prop type
local vendingMachine = ps.getNearestObjectOfType(GetHashKey("prop_vend_soda_01"), 2.0)
if vendingMachine ~= 0 then
    -- Player can use vending machine
end
```

## Dependencies

- FiveM Client
- ps_lib framework
- Requires client-side execution context

## File Location

`modules/getNear/client/getNear.lua`
