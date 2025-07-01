-- Get game time in 24-hour format
---@return string
function ps.getGameTime24()
    local time = string.format("%02d:%02d", GetClockHours(), GetClockMinutes())
    return time
end

-- Get game time in 12-hour format with AM/PM
---@return string
function ps.getGameTime12()
    local hours = GetClockHours()
    local minutes = GetClockMinutes()
    local ampm = "AM"

    if hours >= 12 then
        ampm = "PM"
        if hours > 12 then
            hours = hours - 12
        end
    end

    if hours == 0 then
        hours = 12
    end

    local time = string.format("%d:%02d %s", hours, minutes, ampm)
    return time
end
