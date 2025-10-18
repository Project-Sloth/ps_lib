Config = {}
ps = {}

Config.Inventory = "auto" -- auto, ox_inventory, qb-inventory, ps-inventory, lj-inventory, tgiann-inventory, jpr-inventory
Config.Target = "auto" -- auto, ox_target, qb-target, interact
Config.EmoteMenu = "rpemotes" -- rpemotes, dpemotes, scully, anything else for custom
Config.Notify = "ox" -- qb, ox, ps, esx, mad_thoughts, okok, lation, v42
Config.Menus = "ox" -- qb, ox, ps, lation
Config.DrawText = "ox" -- qb, ox, ps, lation, okok 
Config.Banking = "qb" -- qb, okok, Renewed, none
Config.VehicleKeys = "qb" -- qb, mrnewb, none
Config.ConvertQBMenu = false -- Convert qb-menu to ps-ui context menu and qb-input to ps-ui input

Config.Progressbar = { -- these are DEFAULT values, you can override them in the progressbar function
    style = "oxcircle", -- qb, oxbar, oxcircle, keep
    Movement = true, -- Disable movement
    CarMovement = true, -- Disable car movement
    Mouse = true, -- Disable mouse
    Combat = true, -- Disable combat
}

Config.Logs = "fivemerr" -- fivemerr or fivemanage

QBCore, ESX, qbx, langs = nil, nil, nil

if GetResourceState('qbx_core') == 'started' then
    qbx = exports.qbx_core
    langs = GetConvar('ox:locale', 'en') or 'en'
elseif GetResourceState('es_extended') == 'started' then
    ESX = exports['es_extended']:getSharedObject()
    langs = GetConvar('esx:locale', 'en') or 'en'
elseif GetResourceState('qb-core') == 'started' then
    QBCore = exports['qb-core']:GetCoreObject()
    langs = GetConvar('qb_locale', 'en') or 'en'
end