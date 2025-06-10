Emote = {}

local GetResourceState = GetResourceState
local ipairs = ipairs

--local emotes = {
--    {name = 'rpemotes-reborn', bridge = 'rp'},
--    {name = 'rpemotes', bridge = 'rp'},
--    {name = 'dpemotes', bridge = 'dp'},
--    {name = 'scully_emotemenu', bridge = 'skully'},
--}
--
local emotesFound = false

--for _, resource in ipairs(emotes) do
--    if GetResourceState(resource.name) == 'started' then
--        loadLib(('bridge/emote/%s/client.lua'):format(resource.bridge))
--        ps.debug(('Emote resource found: %s'):format(resource.name))
--        emotesFound = true
--        break
--    end
--end
--
if not emotesFound then
    loadLib(('bridge/emote/%s/client.lua'):format('custom'))
    ps.warn('No emote resource found: falling back to custom')
end