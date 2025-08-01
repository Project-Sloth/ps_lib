# QBCore Framework Bridge - Server

The QBCore server bridge provides a unified API layer for interacting with QBCore framework functions on the server side. This bridge abstracts QBCore-specific implementations behind consistent `ps.*` function calls.

## Features

- Player data retrieval and manipulation
- Job and gang management
- Money operations
- Vehicle ownership checking
- Permission and distance utilities
- Shared data access (vehicles, weapons, jobs, gangs)
- Duty toggle system

## Location

- **Server**: `bridge/framework/qb/server.lua`

## Player Functions

### Basic Player Getters

#### ps.getPlayer(source)

Returns the player object for the given source.

**Parameters:**
- `source` (number): Player server ID

**Returns:**
- `table|nil`: QBCore player object or nil if not found

**Example:**
```lua
local player = ps.getPlayer(source)
if player then
    print("Player found:", player.PlayerData.name)
end
```

#### ps.getPlayerByIdentifier(identifier)

Returns the player object for the given citizen ID (online or offline).

**Parameters:**
- `identifier` (string): Citizen ID

**Returns:**
- `table|nil`: QBCore player object or nil if not found

**Example:**
```lua
local player = ps.getPlayerByIdentifier('ABC12345')
if player then
    print("Player data:", player.PlayerData.charinfo.firstname)
end
```

#### ps.getOfflinePlayer(identifier)

Returns the offline player object for the given citizen ID.

**Parameters:**
- `identifier` (string): Citizen ID

**Returns:**
- `table|nil`: QBCore offline player object or nil if not found

**Example:**
```lua
local offlinePlayer = ps.getOfflinePlayer('ABC12345')
if offlinePlayer then
    print("Offline player found")
end
```

### Identifier Functions

#### ps.getLicense(source)

Returns the GTA license identifier for the given source.

**Parameters:**
- `source` (number): Player server ID

**Returns:**
- `string|nil`: License identifier or nil if not found

**Example:**
```lua
local license = ps.getLicense(source)
print("Player license:", license)
```

#### ps.getIdentifier(source)

Returns the citizen identifier for the given source.

**Parameters:**
- `source` (number): Player server ID

**Returns:**
- `string|nil`: Citizen ID or nil if not found

**Example:**
```lua
local citizenId = ps.getIdentifier(source)
print("Citizen ID:", citizenId)
```

#### ps.getSource(identifier)

Returns the source ID for the given citizen identifier.

**Parameters:**
- `identifier` (string): Citizen ID

**Returns:**
- `number|nil`: Player source or nil if not online

**Example:**
```lua
local source = ps.getSource('ABC12345')
if source then
    print("Player is online with source:", source)
end
```

### Player Information

#### ps.getPlayerName(source)

Returns the full name of the player for the given source.

**Parameters:**
- `source` (number): Player server ID

**Returns:**
- `string`: Full name (firstname + lastname)

**Example:**
```lua
local name = ps.getPlayerName(source)
print("Player name:", name)
```

#### ps.getPlayerNameByIdentifier(identifier)

Returns the full name of the player for the given identifier.

**Parameters:**
- `identifier` (string): Citizen ID

**Returns:**
- `string`: Full name or "Unknown Person" if not found

**Example:**
```lua
local name = ps.getPlayerNameByIdentifier('ABC12345')
print("Player name:", name)
```

#### ps.getPlayerData(source)

Returns the complete PlayerData for the given source.

**Parameters:**
- `source` (number): Player server ID

**Returns:**
- `table`: Complete PlayerData object

**Example:**
```lua
local playerData = ps.getPlayerData(source)
print("Player job:", playerData.job.name)
```

#### ps.getMetadata(source, meta)

Returns specific metadata for the given source.

**Parameters:**
- `source` (number): Player server ID
- `meta` (string): Metadata key

**Returns:**
- `any`: Metadata value

**Example:**
```lua
local bloodType = ps.getMetadata(source, 'bloodtype')
print("Blood type:", bloodType)
```

#### ps.getCharInfo(source, info)

Returns specific character info for the given source.

**Parameters:**
- `source` (number): Player server ID
- `info` (string): Character info key

**Returns:**
- `any`: Character info value

**Example:**
```lua
local age = ps.getCharInfo(source, 'age')
print("Character age:", age)
```

## Job Functions

### Basic Job Information

#### ps.getJob(source)

Returns the complete job object for the given source.

**Parameters:**
- `source` (number): Player server ID

**Returns:**
- `table`: Job object with name, grade, payment, etc.

**Example:**
```lua
local job = ps.getJob(source)
print("Job:", job.name, "Grade:", job.grade.name)
```

#### ps.getJobName(source)

Returns the job name for the given source.

**Parameters:**
- `source` (number): Player server ID

**Returns:**
- `string`: Job name

**Example:**
```lua
local jobName = ps.getJobName(source)
if jobName == 'police' then
    print("Player is a police officer")
end
```

#### ps.getJobType(source)

Returns the job type for the given source.

**Parameters:**
- `source` (number): Player server ID

**Returns:**
- `string`: Job type (e.g., "leo", "ems", "mechanic")

#### ps.getJobDuty(source)

Returns the duty status for the given source.

**Parameters:**
- `source` (number): Player server ID

**Returns:**
- `boolean`: True if on duty, false if off duty

**Example:**
```lua
local onDuty = ps.getJobDuty(source)
if onDuty then
    print("Player is on duty")
end
```

### Job Grade Functions

#### ps.getJobGrade(source)

Returns the complete job grade object.

**Parameters:**
- `source` (number): Player server ID

**Returns:**
- `table`: Grade object with level, name, payment

#### ps.getJobGradeLevel(source)

Returns the job grade level (numeric).

**Parameters:**
- `source` (number): Player server ID

**Returns:**
- `number`: Grade level

#### ps.getJobGradeName(source)

Returns the job grade name.

**Parameters:**
- `source` (number): Player server ID

**Returns:**
- `string`: Grade name

#### ps.getJobGradePay(source)

Returns the job grade payment amount.

**Parameters:**
- `source` (number): Player server ID

**Returns:**
- `number`: Payment amount

### Job Management

#### ps.isBoss(source)

Checks if the player is a boss of their job.

**Parameters:**
- `source` (number): Player server ID

**Returns:**
- `boolean`: True if boss, false otherwise

#### ps.setJob(source, jobName, rank)

Sets a player's job and rank.

**Parameters:**
- `source` (number): Player server ID
- `jobName` (string): Job name
- `rank` (number, optional): Job rank (default: 0)

**Example:**
```lua
ps.setJob(source, 'police', 2)
```

#### ps.setJobDuty(source, duty)

Sets a player's duty status.

**Parameters:**
- `source` (number): Player server ID
- `duty` (boolean): Duty status

**Example:**
```lua
ps.setJobDuty(source, true) -- Set on duty
```

## Gang Functions

#### ps.getGang(source)

Returns the complete gang object for the given source.

**Parameters:**
- `source` (number): Player server ID

**Returns:**
- `table`: Gang object

#### ps.getGangName(source)

Returns the gang name for the given source.

**Parameters:**
- `source` (number): Player server ID

**Returns:**
- `string`: Gang name

#### ps.getGangGrade(source)

Returns the gang grade object.

**Parameters:**
- `source` (number): Player server ID

**Returns:**
- `table`: Gang grade object

#### ps.getGangGradeLevel(source)

Returns the gang grade level.

**Parameters:**
- `source` (number): Player server ID

**Returns:**
- `number`: Gang grade level

#### ps.isLeader(source)

Checks if the player is a leader of their gang.

**Parameters:**
- `source` (number): Player server ID

**Returns:**
- `boolean`: True if leader, false otherwise

## Money Functions

#### ps.addMoney(source, type, amount, reason)

Adds money to a player's account.

**Parameters:**
- `source` (number): Player server ID
- `type` (string, optional): Money type ('cash', 'bank', 'crypto') - default: 'cash'
- `amount` (number, optional): Amount to add - default: 0
- `reason` (string, optional): Reason for transaction

**Returns:**
- `boolean`: Always returns true

**Example:**
```lua
ps.addMoney(source, 'bank', 5000, 'Job payment')
```

#### ps.removeMoney(source, type, amount, reason)

Removes money from a player's account.

**Parameters:**
- `source` (number): Player server ID
- `type` (string, optional): Money type - default: 'cash'
- `amount` (number, optional): Amount to remove - default: 0
- `reason` (string, optional): Reason for transaction

**Returns:**
- `boolean`: True if successful, false if insufficient funds

**Example:**
```lua
if ps.removeMoney(source, 'cash', 100, 'Purchase item') then
    print("Payment successful")
else
    print("Insufficient funds")
end
```

#### ps.getMoney(source, type)

Gets the money amount from a player's account.

**Parameters:**
- `source` (number): Player server ID
- `type` (string, optional): Money type - default: 'cash'

**Returns:**
- `number`: Money amount

**Example:**
```lua
local cashAmount = ps.getMoney(source, 'cash')
print("Player has $" .. cashAmount .. " cash")
```

## Utility Functions

### Distance and Location

#### ps.getEntityCoords(source)

Gets the coordinates of a player's ped.

**Parameters:**
- `source` (number): Player server ID

**Returns:**
- `vector3`: Player coordinates

#### ps.getDistance(source, location)

Calculates distance between player and a location.

**Parameters:**
- `source` (number): Player server ID
- `location` (table): Location with x, y, z coordinates

**Returns:**
- `number`: Distance in game units

#### ps.checkDistance(source, location, distance)

Checks if player is within a certain distance of a location.

**Parameters:**
- `source` (number): Player server ID
- `location` (table): Location with x, y, z coordinates
- `distance` (number, optional): Maximum distance - default: 2.5

**Returns:**
- `boolean`: True if within distance

**Example:**
```lua
local bankLocation = {x = 150.0, y = -1040.0, z = 29.0}
if ps.checkDistance(source, bankLocation, 5.0) then
    print("Player is near the bank")
end
```

### Player Groups

#### ps.getAllPlayers()

Gets all online player sources.

**Returns:**
- `table`: Array of player sources

#### ps.getNearbyPlayers(source, distance)

Gets nearby players within a distance.

**Parameters:**
- `source` (number): Player server ID
- `distance` (number, optional): Search distance - default: 10.0

**Returns:**
- `table`: Array of nearby player data

**Example:**
```lua
local nearbyPlayers = ps.getNearbyPlayers(source, 5.0)
for _, player in pairs(nearbyPlayers) do
    print("Nearby player:", player.label)
end
```

### Job Counting

#### ps.getJobCount(jobName)

Gets the count of online players with a specific job who are on duty.

**Parameters:**
- `jobName` (string): Job name to count

**Returns:**
- `number`: Count of players

**Example:**
```lua
local policeCount = ps.getJobCount('police')
print("Police officers on duty:", policeCount)
```

#### ps.getJobTypeCount(jobType)

Gets the count of online players with a specific job type who are on duty.

**Parameters:**
- `jobType` (string): Job type to count

**Returns:**
- `number`: Count of players

## Vehicle Functions

#### ps.vehicleOwner(licensePlate)

Gets the owner of a vehicle by license plate.

**Parameters:**
- `licensePlate` (string): Vehicle license plate

**Returns:**
- `string|boolean`: Citizen ID of owner or false if not found

**Example:**
```lua
local owner = ps.vehicleOwner('ABC123')
if owner then
    print("Vehicle owner:", owner)
end
```

## Permission Functions

#### ps.hasPermission(source, permission)

Checks if a player has a specific permission.

**Parameters:**
- `source` (number): Player server ID
- `permission` (string): Permission to check

**Returns:**
- `boolean`: True if has permission

**Example:**
```lua
if ps.hasPermission(source, 'admin.ban') then
    print("Player has ban permission")
end
```

#### ps.isOnline(identifier)

Checks if a player with the given identifier is online.

**Parameters:**
- `identifier` (string): Citizen ID

**Returns:**
- `boolean`: True if online

## Shared Data Functions

### Vehicles

#### ps.getSharedVehicle(model)

Gets shared vehicle data by model.

**Parameters:**
- `model` (string): Vehicle model name

**Returns:**
- `table|nil`: Vehicle data or nil if not found

#### ps.getSharedVehicleData(model, dataType)

Gets specific shared vehicle data.

**Parameters:**
- `model` (string): Vehicle model name
- `dataType` (string): Data type to retrieve

**Returns:**
- `any|nil`: Requested data or nil

**Example:**
```lua
local vehicleName = ps.getSharedVehicleData('adder', 'name')
local vehiclePrice = ps.getSharedVehicleData('adder', 'price')
```

### Weapons

#### ps.getSharedWeapons(model)

Gets shared weapon data by model.

**Parameters:**
- `model` (string|number): Weapon model name or hash

**Returns:**
- `table|nil`: Weapon data or nil if not found

#### ps.getSharedWeaponData(model, dataType)

Gets specific shared weapon data.

**Parameters:**
- `model` (string|number): Weapon model name or hash
- `dataType` (string): Data type to retrieve

**Returns:**
- `any|nil`: Requested data or nil

### Jobs

#### ps.getJobTable()

Gets the complete jobs table.

**Returns:**
- `table`: All job configurations

#### ps.jobExists(jobName)

Checks if a job exists in the shared configuration.

**Parameters:**
- `jobName` (string): Job name to check

**Returns:**
- `boolean`: True if job exists

#### ps.getSharedJob(job)

Gets shared job data.

**Parameters:**
- `job` (string): Job name

**Returns:**
- `table|nil`: Job data or nil if not found

#### ps.getSharedJobData(job, data)

Gets specific shared job data.

**Parameters:**
- `job` (string): Job name
- `data` (string): Data type to retrieve

**Returns:**
- `any|nil`: Requested data or nil

#### ps.getSharedJobRankData(job, rank, data)

Gets specific job rank data.

**Parameters:**
- `job` (string): Job name
- `rank` (number): Job rank
- `data` (string): Data type to retrieve

**Returns:**
- `any|nil`: Requested data or nil

#### ps.getAllJobs()

Gets array of all job names.

**Returns:**
- `table`: Array of job names

### Gangs

#### ps.getSharedGang(gang)

Gets shared gang data.

**Parameters:**
- `gang` (string): Gang name

**Returns:**
- `table|nil`: Gang data or nil if not found

#### ps.getSharedGangData(gang, data)

Gets specific shared gang data.

**Parameters:**
- `gang` (string): Gang name
- `data` (string): Data type to retrieve

**Returns:**
- `any|nil`: Requested data or nil

#### ps.getSharedGangRankData(gang, rank, data)

Gets specific gang rank data.

**Parameters:**
- `gang` (string): Gang name
- `rank` (number): Gang rank
- `data` (string): Data type to retrieve

**Returns:**
- `any|nil`: Requested data or nil

#### ps.getAllGangs()

Gets array of all gang names.

**Returns:**
- `table`: Array of gang names

## Item Functions

#### ps.createUseable(item, func)

Creates a useable item with a callback function.

**Parameters:**
- `item` (string): Item name
- `func` (function): Callback function when item is used

**Example:**
```lua
ps.createUseable('bandage', function(source, item)
    -- Heal player logic
    print("Player used bandage")
end)
```

## Events

### ps_lib:server:toggleDuty

Server event that toggles a player's duty status.

**Usage:**
```lua
TriggerServerEvent('ps_lib:server:toggleDuty')
```

## Usage Examples

### Complete Player Check System
```lua
function HandlePlayerInteraction(source)
    local player = ps.getPlayer(source)
    if not player then
        print("Player not found")
        return
    end
    
    local playerName = ps.getPlayerName(source)
    local jobName = ps.getJobName(source)
    local onDuty = ps.getJobDuty(source)
    local cashAmount = ps.getMoney(source, 'cash')
    
    print(string.format("Player: %s | Job: %s | Duty: %s | Cash: $%d", 
        playerName, jobName, onDuty and "On" or "Off", cashAmount))
end
```

### Job-Based Access Control
```lua
function CheckJobAccess(source, requiredJob, requiredGrade)
    local jobName = ps.getJobName(source)
    local jobGrade = ps.getJobGradeLevel(source)
    local onDuty = ps.getJobDuty(source)
    
    if jobName == requiredJob and jobGrade >= requiredGrade and onDuty then
        return true
    end
    
    return false
end

-- Usage
if CheckJobAccess(source, 'police', 2) then
    print("Player has required police access")
end
```

### Distance-Based Services
```lua
function ProvideService(source, serviceLocation, serviceName)
    if not ps.checkDistance(source, serviceLocation, 3.0) then
        TriggerClientEvent('QBCore:Notify', source, 'You are too far from the ' .. serviceName, 'error')
        return false
    end
    
    print("Player is close enough to use " .. serviceName)
    return true
end
```

### Money Transaction System
```lua
function ProcessPurchase(source, itemName, price, moneyType)
    moneyType = moneyType or 'cash'
    
    local currentMoney = ps.getMoney(source, moneyType)
    
    if currentMoney < price then
        TriggerClientEvent('QBCore:Notify', source, 'Insufficient funds', 'error')
        return false
    end
    
    if ps.removeMoney(source, moneyType, price, 'Purchased ' .. itemName) then
        print("Purchase successful: " .. itemName)
        return true
    end
    
    return false
end
```

## Best Practices

1. **Error Checking**: Always check if player objects exist before using them
2. **Null Safety**: Handle cases where functions return nil
3. **Performance**: Cache player data when doing multiple operations
4. **Consistency**: Use the bridge functions instead of direct QBCore calls
5. **Documentation**: Document custom functions that build on these bridges

## Integration with QBCore

This bridge is specifically designed for QBCore framework and requires:
- QBCore framework to be running
- Proper database setup for player data
- QBCore shared configurations for jobs, gangs, vehicles, and weapons

The bridge automatically handles QBCore-specific implementations while providing a consistent API for resource developers.
