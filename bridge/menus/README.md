# ox_lib Menu Bridge

The ox_lib menu bridge provides a unified API layer for creating context menus and input dialogs using the ox_lib library. This bridge abstracts ox_lib-specific implementations behind consistent `ps.*` function calls.

## Features

- Context menu creation and management
- Input dialog creation with various field types
- Menu closing functionality
- Event handling (client and server events)
- Flexible menu option configuration
- Input validation and type checking

## Location

- **Client**: `bridge/menus/ox.lua`

## Dependencies

- **ox_lib**: Required for menu and input functionality
- Must have ox_lib properly installed and configured

## Functions

### ps.menu(name, label, data)

Creates and displays a context menu using ox_lib.

**Parameters:**
- `name` (string): Unique identifier for the menu
- `label` (string, optional): Menu title (default: 'Context Menu')
- `data` (table): Array of menu options

**Menu Option Structure:**
```lua
{
    title = "Option Title",           -- Display text for the option
    description = "Option description", -- Subtitle/description text
    icon = "fas fa-icon",            -- Font Awesome icon
    disabled = false,                -- Whether option is disabled
    action = function() end,         -- Direct function to execute
    event = "client:event",          -- Client event to trigger
    isServer = false,                -- If true, triggers server event
    args = {data = "value"}          -- Arguments to pass with event
}
```

**Example:**
```lua
ps.menu('main_menu', 'Main Menu', {
    {
        title = 'Police Actions',
        description = 'Access police menu',
        icon = 'fas fa-shield-alt',
        event = 'police:client:openMenu'
    },
    {
        title = 'Check ID',
        description = 'Check nearby player ID',
        icon = 'fas fa-id-card',
        isServer = true,
        event = 'police:server:checkId',
        args = {playerId = GetPlayerServerId(PlayerId())}
    },
    {
        title = 'Close Menu',
        description = 'Close this menu',
        icon = 'fas fa-times',
        action = function()
            ps.closeMenu()
        end
    }
})
```

### ps.closeMenu()

Closes the currently open context menu.

**Example:**
```lua
ps.closeMenu()
```

### ps.input(label, data)

Creates and displays an input dialog with various field types.

**Parameters:**
- `label` (string): Dialog title
- `data` (table): Array of input fields

**Input Field Structure:**
```lua
{
    title = "Field Label",           -- Display label for the field
    type = "input",                  -- Field type (input, number, select, checkbox, etc.)
    description = "Field description", -- Help text for the field
    placeholder = "Enter text...",   -- Placeholder text
    options = {                      -- Options for select type
        {value = 'option1', label = 'Option 1'},
        {value = 'option2', label = 'Option 2'}
    },
    required = true,                 -- Whether field is required
    min = 1,                        -- Minimum value (for number type)
    max = 100                       -- Maximum value (for number type)
}
```

**Returns:**
- `table|nil`: Array of input values or nil if cancelled

**Example:**
```lua
local result = ps.input('Player Information', {
    {
        title = 'First Name',
        type = 'input',
        placeholder = 'Enter first name',
        required = true
    },
    {
        title = 'Age',
        type = 'number',
        min = 18,
        max = 100,
        required = true
    },
    {
        title = 'Department',
        type = 'select',
        options = {
            {value = 'police', label = 'Police Department'},
            {value = 'ems', label = 'Emergency Medical'},
            {value = 'fire', label = 'Fire Department'}
        },
        required = true
    },
    {
        title = 'On Duty',
        type = 'checkbox',
        description = 'Are you currently on duty?'
    }
})

if result then
    local firstName = result[1]
    local age = result[2]
    local department = result[3]
    local onDuty = result[4]
    
    print("Name:", firstName, "Age:", age, "Dept:", department, "Duty:", onDuty)
else
    print("Input cancelled")
end
```

## Input Field Types

### text/input
Basic text input field.

```lua
{
    title = 'Player Name',
    type = 'input',
    placeholder = 'Enter player name',
    required = true
}
```

### number
Numeric input with min/max validation.

```lua
{
    title = 'Amount',
    type = 'number',
    min = 1,
    max = 999999,
    placeholder = 'Enter amount',
    required = true
}
```

### select
Dropdown selection from predefined options.

```lua
{
    title = 'Vehicle Class',
    type = 'select',
    options = {
        {value = 'compact', label = 'Compact Cars'},
        {value = 'sedan', label = 'Sedans'},
        {value = 'suv', label = 'SUVs'},
        {value = 'sports', label = 'Sports Cars'}
    },
    required = true
}
```

### checkbox
Boolean checkbox input.

```lua
{
    title = 'Send Notification',
    type = 'checkbox',
    description = 'Send notification to all players'
}
```

### textarea
Multi-line text input.

```lua
{
    title = 'Description',
    type = 'textarea',
    placeholder = 'Enter detailed description...',
    required = false
}
```

## Usage Examples

### Police Menu System
```lua
function OpenPoliceMenu()
    ps.menu('police_menu', 'Police Actions', {
        {
            title = 'Check ID',
            description = 'Check nearby player identification',
            icon = 'fas fa-id-card',
            event = 'police:client:checkId'
        },
        {
            title = 'Handcuff Player',
            description = 'Handcuff the nearest player',
            icon = 'fas fa-handcuffs',
            event = 'police:client:handcuff'
        },
        {
            title = 'Issue Fine',
            description = 'Issue a fine to a player',
            icon = 'fas fa-receipt',
            action = function()
                IssueFineMenu()
            end
        },
        {
            title = 'Vehicle Actions',
            description = 'Vehicle related actions',
            icon = 'fas fa-car',
            action = function()
                OpenVehicleMenu()
            end
        }
    })
end

function IssueFineMenu()
    local result = ps.input('Issue Fine', {
        {
            title = 'Player ID',
            type = 'number',
            min = 1,
            placeholder = 'Enter player server ID',
            required = true
        },
        {
            title = 'Fine Amount',
            type = 'number',
            min = 50,
            max = 10000,
            placeholder = 'Enter fine amount',
            required = true
        },
        {
            title = 'Reason',
            type = 'input',
            placeholder = 'Enter reason for fine',
            required = true
        }
    })
    
    if result then
        local playerId = result[1]
        local amount = result[2]
        local reason = result[3]
        
        TriggerServerEvent('police:server:issueFine', playerId, amount, reason)
    end
end
```

### Vehicle Garage System
```lua
function OpenGarageMenu()
    -- Get player's vehicles from server
    QBCore.Functions.TriggerCallback('garage:getVehicles', function(vehicles)
        local menuOptions = {}
        
        for i, vehicle in ipairs(vehicles) do
            table.insert(menuOptions, {
                title = vehicle.model:upper(),
                description = 'Plate: ' .. vehicle.plate .. ' | Fuel: ' .. vehicle.fuel .. '%',
                icon = 'fas fa-car',
                event = 'garage:client:spawnVehicle',
                args = {
                    plate = vehicle.plate,
                    model = vehicle.model,
                    coords = vehicle.coords
                }
            })
        end
        
        -- Add option to store current vehicle
        table.insert(menuOptions, {
            title = 'Store Vehicle',
            description = 'Store your current vehicle',
            icon = 'fas fa-warehouse',
            event = 'garage:client:storeVehicle'
        })
        
        ps.menu('garage_menu', 'Vehicle Garage', menuOptions)
    end)
end
```

### Business Management System
```lua
function OpenBusinessMenu()
    ps.menu('business_menu', 'Business Management', {
        {
            title = 'Hire Employee',
            description = 'Hire a new employee',
            icon = 'fas fa-user-plus',
            action = function()
                HireEmployeeDialog()
            end
        },
        {
            title = 'Fire Employee',
            description = 'Fire an employee',
            icon = 'fas fa-user-minus',
            action = function()
                FireEmployeeDialog()
            end
        },
        {
            title = 'Set Prices',
            description = 'Update product prices',
            icon = 'fas fa-tag',
            action = function()
                SetPricesDialog()
            end
        },
        {
            title = 'View Finances',
            description = 'Check business finances',
            icon = 'fas fa-chart-line',
            isServer = true,
            event = 'business:server:getFinances'
        }
    })
end

function HireEmployeeDialog()
    local result = ps.input('Hire Employee', {
        {
            title = 'Player ID',
            type = 'number',
            min = 1,
            placeholder = 'Enter player server ID',
            required = true
        },
        {
            title = 'Position',
            type = 'select',
            options = {
                {value = 'employee', label = 'Employee'},
                {value = 'manager', label = 'Manager'},
                {value = 'supervisor', label = 'Supervisor'}
            },
            required = true
        },
        {
            title = 'Starting Salary',
            type = 'number',
            min = 1000,
            max = 50000,
            placeholder = 'Enter starting salary',
            required = true
        }
    })
    
    if result then
        TriggerServerEvent('business:server:hireEmployee', result[1], result[2], result[3])
    end
end
```

### Admin Panel System
```lua
function OpenAdminMenu()
    ps.menu('admin_menu', 'Admin Panel', {
        {
            title = 'Player Management',
            description = 'Manage players on the server',
            icon = 'fas fa-users',
            action = function()
                OpenPlayerManagement()
            end
        },
        {
            title = 'Vehicle Management',
            description = 'Spawn and manage vehicles',
            icon = 'fas fa-car',
            action = function()
                OpenVehicleManagement()
            end
        },
        {
            title = 'Server Settings',
            description = 'Configure server settings',
            icon = 'fas fa-cog',
            action = function()
                OpenServerSettings()
            end
        },
        {
            title = 'Teleport',
            description = 'Teleport to locations',
            icon = 'fas fa-map-marker-alt',
            action = function()
                TeleportDialog()
            end
        }
    })
end

function TeleportDialog()
    local result = ps.input('Teleport', {
        {
            title = 'X Coordinate',
            type = 'number',
            placeholder = 'Enter X coordinate',
            required = true
        },
        {
            title = 'Y Coordinate',
            type = 'number',
            placeholder = 'Enter Y coordinate',
            required = true
        },
        {
            title = 'Z Coordinate',
            type = 'number',
            placeholder = 'Enter Z coordinate',
            required = true
        },
        {
            title = 'Teleport Vehicle',
            type = 'checkbox',
            description = 'Teleport current vehicle with you'
        }
    })
    
    if result then
        local coords = vector3(result[1], result[2], result[3])
        local teleportVehicle = result[4]
        
        if teleportVehicle and IsPedInAnyVehicle(PlayerPedId()) then
            local vehicle = GetVehiclePedIsIn(PlayerPedId())
            SetEntityCoords(vehicle, coords.x, coords.y, coords.z)
        else
            SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z)
        end
    end
end
```

### Shopping System
```lua
function OpenShopMenu(shopData)
    local menuOptions = {}
    
    for category, items in pairs(shopData.categories) do
        table.insert(menuOptions, {
            title = category:gsub("^%l", string.upper),
            description = 'Browse ' .. category .. ' items',
            icon = items.icon or 'fas fa-shopping-bag',
            action = function()
                OpenCategoryMenu(category, items.products)
            end
        })
    end
    
    ps.menu('shop_menu', shopData.name, menuOptions)
end

function OpenCategoryMenu(category, products)
    local menuOptions = {}
    
    for _, product in ipairs(products) do
        table.insert(menuOptions, {
            title = product.label,
            description = 'Price: $' .. product.price .. ' | Stock: ' .. product.stock,
            icon = product.icon or 'fas fa-cube',
            action = function()
                PurchaseItemDialog(product)
            end
        })
    end
    
    -- Add back button
    table.insert(menuOptions, {
        title = 'Back',
        description = 'Return to main shop menu',
        icon = 'fas fa-arrow-left',
        action = function()
            OpenShopMenu(shopData)
        end
    })
    
    ps.menu('category_menu', category:gsub("^%l", string.upper), menuOptions)
end

function PurchaseItemDialog(product)
    local result = ps.input('Purchase ' .. product.label, {
        {
            title = 'Quantity',
            type = 'number',
            min = 1,
            max = math.min(product.stock, 10),
            placeholder = 'Enter quantity',
            required = true
        },
        {
            title = 'Payment Method',
            type = 'select',
            options = {
                {value = 'cash', label = 'Cash'},
                {value = 'bank', label = 'Bank Account'},
                {value = 'crypto', label = 'Cryptocurrency'}
            },
            required = true
        }
    })
    
    if result then
        local quantity = result[1]
        local paymentMethod = result[2]
        local totalCost = product.price * quantity
        
        TriggerServerEvent('shop:server:purchaseItem', product.name, quantity, paymentMethod, totalCost)
    end
end
```

## Integration Examples

### With QBCore Framework
```lua
-- Event handler for menu triggers
RegisterNetEvent('qb-menu:client:openMenu', function(menuData)
    ps.menu(menuData.id, menuData.title, menuData.options)
end)

-- Callback integration
QBCore.Functions.TriggerCallback('getPlayerData', function(data)
    if data then
        ps.menu('player_data', 'Player Information', {
            {
                title = 'Name: ' .. data.name,
                description = 'Character information',
                icon = 'fas fa-user'
            },
            {
                title = 'Job: ' .. data.job.label,
                description = 'Current employment',
                icon = 'fas fa-briefcase'
            }
        })
    end
end)
```

### With Custom Events
```lua
-- Custom event handling
AddEventHandler('customMenu:open', function(menuType, data)
    if menuType == 'police' then
        OpenPoliceMenu()
    elseif menuType == 'admin' then
        OpenAdminMenu()
    elseif menuType == 'shop' then
        OpenShopMenu(data)
    end
end)
```

## Best Practices

1. **Menu Structure**: Keep menus organized with clear titles and descriptions
2. **Icon Usage**: Use Font Awesome icons for better visual appeal
3. **Input Validation**: Always validate input results before processing
4. **Error Handling**: Check if results exist before using them
5. **Menu Navigation**: Provide back buttons for nested menus
6. **Event Organization**: Use consistent event naming conventions
7. **User Experience**: Provide clear descriptions and helpful placeholders

## ox_lib Integration

This bridge requires ox_lib to be properly installed and configured:

```lua
-- In your fxmanifest.lua
shared_scripts {
    '@ox_lib/init.lua',
    -- your other scripts
}
```

The bridge automatically handles:
- Context menu registration and display
- Input dialog creation and validation
- Event routing (client/server)
- Menu closing and cleanup

## Common Issues

1. **ox_lib Not Found**: Ensure ox_lib is installed and started before your resource
2. **Menu Not Showing**: Check console for ox_lib errors
3. **Events Not Triggering**: Verify event names and registration
4. **Input Validation**: Ensure required fields are properly configured
5. **Menu Overlap**: Close previous menus before opening new ones
