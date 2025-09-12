Config = {}
ps = {}

Config.Notify = "ps" -- qb, ox, ps, mad_thoughts
Config.Menus = "ps" -- qb, ox, ps
Config.DrawText = "ps" -- qb, ox, ps
Config.ConvertQBMenu = false -- Convert qb-menu to ps-ui context menu and qb-input to ps-ui input

Config.Progressbar = { -- these are DEFAULT values, you can override them in the progressbar function
    style = "oxbar", -- qb, oxbar, ps
    Movement = true, -- Disable movement
    CarMovement = true, -- Disable car movement
    Mouse = true, -- Disable mouse
    Combat = true, -- Disable combat
}

Config.Logs = "fivemerr" -- fivemerr or fivemanage 


QBCore, ESX, qbx, langs = nil, nil, nil

if GetResourceState('qbx_core') == 'started' then
    qbx = exports.qbx_core
    langs = GetConvar('ox:locale', 'en')
elseif GetResourceState('es_extended') == 'started' then
    ESX = exports['es_extended']:getSharedObject()
    langs = GetConvar('esx:locale', 'en')
elseif GetResourceState('qb-core') == 'started' then
    QBCore = exports['qb-core']:GetCoreObject()
    langs = GetConvar('qb_locale', 'en')
end