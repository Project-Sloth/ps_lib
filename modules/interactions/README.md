# Interactions Module

The Interactions module provides utility functions for UI interactions in FiveM. This module includes functions for displaying text, notifications, progress bars, and minigames with support for multiple UI frameworks.

## Overview

This module is part of the ps_lib framework and provides client-side functions for user interface interactions. It supports multiple frameworks including QB-Core, ESX, OX, and PS-UI, making it highly compatible across different server setups.

## Functions

### `ps.drawText(text)`

Displays text on the screen using the configured UI framework.

**Parameters:**
- `text` (string): The text to display on screen

**Returns:**
- None

**Supported Frameworks:**
- `qb` - QB-Core ShowText
- `ox` - OX Lib showTextUI
- `ps` - PS-UI drawText (yellow color)

**Example:**
```lua
ps.drawText("Press [E] to interact")
```

### `ps.hideText()`

Hides the currently displayed text from the screen.

**Parameters:**
- None

**Returns:**
- None

**Example:**
```lua
ps.hideText()
```

### `ps.notify(text, type, time)`

Displays a notification to the player using the configured notification system.

**Parameters:**
- `text` (string): The notification message
- `type` (string, optional): Notification type. Defaults to `'info'`
  - Common types: `'info'`, `'success'`, `'error'`, `'warning'`
- `time` (number, optional): Duration in milliseconds. Defaults to `5000`

**Returns:**
- None

**Supported Frameworks:**
- `qb` - QB-Core Functions.Notify
- `esx` - ESX ShowNotification
- `ox` - OX Lib notify
- `ps` - PS-Lib notify

**Example:**
```lua
-- Basic notification
ps.notify("Hello World!")

-- Success notification with custom duration
ps.notify("Task completed successfully!", "success", 3000)

-- Error notification
ps.notify("Something went wrong!", "error")
```

### `ps.progressbar(text, time, emote, disabled)`

Displays a progress bar with optional emote and control restrictions.

**Parameters:**
- `text` (string): The progress bar label/description
- `time` (number): Duration in milliseconds
- `emote` (string, optional): Emote to play during progress
- `disabled` (table, optional): Controls to disable during progress
  - `movement` (boolean): Disable player movement
  - `car` (boolean): Disable car movement
  - `mouse` (boolean): Disable mouse look
  - `combat` (boolean): Disable combat actions

**Returns:**
- `success` (boolean): `true` if completed, `false` if cancelled

**Supported Styles:**
- `qb` - QB-Core Progressbar
- `oxbar` - OX Lib Progress Bar
- `oxcir` - OX Lib Progress Circle

**Example:**
```lua
-- Basic progress bar
local success = ps.progressbar("Picking lock...", 10000)
if success then
    print("Lock picked successfully!")
end

-- With emote and disabled controls
local disabled = {
    movement = true,
    combat = true,
    mouse = false,
    car = true
}
local success = ps.progressbar("Repairing engine...", 15000, "mechanic", disabled)

-- Quick progress with default restrictions
local success = ps.progressbar("Searching...", 5000, "search")
```

### `ps.minigame(type, values)`

Executes various minigames and skill checks.

**Parameters:**
- `type` (string): The minigame type to execute
- `values` (table): Configuration values specific to each minigame type

**Returns:**
- `success` (boolean): `true` if minigame was completed successfully, `false` otherwise

**Supported Minigame Types:**

#### `'ps-circle'`
Circle progress minigame from PS-UI.
```lua
local values = {
    amount = 3,    -- Number of circles to complete
    speed = 15     -- Speed of the circle
}
local success = ps.minigame('ps-circle', values)
```

#### `'ps-maze'`
Maze navigation minigame from PS-UI.
```lua
local values = {
    timeLimit = 20  -- Time limit in seconds
}
local success = ps.minigame('ps-maze', values)
```

#### `'ps-scrambler'`
Word scramble minigame from PS-UI.
```lua
local values = {
    type = "alphabet",  -- Type of scrambler
    timeLimit = 30      -- Time limit in seconds
}
local success = ps.minigame('ps-scrambler', values)
```

#### `'ps-varhack'`
Variable hacking minigame from PS-UI.
```lua
local values = {
    blocks = 5,      -- Number of blocks
    timeLimit = 30   -- Time limit in seconds
}
local success = ps.minigame('ps-varhack', values)
```

#### `'ps-thermite'`
Thermite cutting minigame from PS-UI.
```lua
local values = {
    timeLimit = 10,  -- Time limit in seconds
    gridsize = 6,    -- Grid size (6x6, 8x8, etc.)
    wrong = 3        -- Number of wrong attempts allowed
}
local success = ps.minigame('ps-thermite', values)
```

#### `'ox'`
OX Lib skill check minigame.
```lua
local values = {
    difficulty = {'easy', 'easy', 'medium'},  -- Difficulty array
    input = {'1', '2', '3', '4'}             -- Input keys (optional)
}
local success = ps.minigame('ox', values)
```

## Configuration

The module behavior is controlled by configuration values:

### DrawText Configuration
```lua
Config.DrawText = 'qb'  -- 'qb', 'ox', or 'ps'
```

### Notify Configuration
```lua
Config.Notify = 'qb'  -- 'qb', 'esx', 'ox', or 'ps'
```

### Progressbar Configuration
```lua
Config.Progressbar = {
    style = 'qb',        -- 'qb', 'oxbar', or 'oxcir'
    Movement = false,    -- Default movement restriction
    CarMovement = false, -- Default car movement restriction
    Mouse = false,       -- Default mouse restriction
    Combat = true        -- Default combat restriction
}
```

## Usage Examples

### Complete Interaction Sequence
```lua
-- Show interaction text
ps.drawText("Press [E] to hack terminal")

-- Wait for input, then hide text
ps.hideText()

-- Show progress bar with emote
local success = ps.progressbar("Hacking terminal...", 8000, "type")

if success then
    -- Run minigame
    local hackSuccess = ps.minigame('ps-varhack', {
        blocks = 4,
        timeLimit = 25
    })
    
    if hackSuccess then
        ps.notify("Terminal hacked successfully!", "success")
    else
        ps.notify("Hack failed!", "error")
    end
else
    ps.notify("Hacking interrupted!", "warning")
end
```

### Lock Picking Sequence
```lua
ps.drawText("Press [E] to pick lock")
-- Player presses E
ps.hideText()

-- Progress bar with lock picking emote
local picking = ps.progressbar("Picking lock...", 12000, "lockpick", {
    movement = true,
    combat = true
})

if picking then
    -- Circle minigame for lock picking
    local picked = ps.minigame('ps-circle', {
        amount = 5,
        speed = 20
    })
    
    if picked then
        ps.notify("Lock picked!", "success")
        -- Open door/container
    else
        ps.notify("Lock pick broke!", "error")
    end
end
```

### Skill Check Example
```lua
-- OX Lib skill check with increasing difficulty
local skillCheck = ps.minigame('ox', {
    difficulty = {'easy', 'medium', 'hard', 'hard'},
    input = {'w', 'a', 's', 'd'}
})

if skillCheck then
    ps.notify("Skill check passed!", "success")
else
    ps.notify("Failed skill check!", "error")
end
```

## Performance Notes

- Progress bars automatically handle emote cleanup
- Minigames return immediately with boolean results
- Text display functions are lightweight and can be called frequently
- Progress bars use promises for proper async handling

## Framework Compatibility

This module is designed to work with:
- **QB-Core** - Full support for all functions
- **ESX** - Notification support
- **OX Lib** - Text UI, notifications, progress bars, and skill checks
- **PS-UI** - Text display, notifications, and minigames

## Error Handling

- Functions safely handle missing parameters with sensible defaults
- Progress bars properly clean up emotes on success or failure
- Minigames return `false` on failure or timeout
- Text functions ignore `nil` input gracefully

## Dependencies

- FiveM Client
- ps_lib framework
- Configured UI framework (QB-Core, OX Lib, PS-UI, etc.)
- Promise library (for QB-Core progress bars)

## File Location

`modules/interactions/client/interactions.lua`
