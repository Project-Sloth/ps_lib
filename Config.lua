Config = {}

Config.Notify = "ox" -- qb, ox, ps
Config.Progressbar = "oxcir" -- qb, oxcir, oxbar
Config.Logs = "fivemerr" -- fivemerr or fivemanage 
ps = {}

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