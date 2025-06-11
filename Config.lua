Config = {}

Config.Notify = "qb" -- qb, ox, ps
Config.Progressbar = "qb" -- qb, oxcir, oxbar
Config.Logs = "fivemerr" -- fivemerr or fivemanage 
Config.Language = "en" -- en or de or fr or es or pt or tr
ps = {}

QBCore, ESX, qbx = nil, nil, nil

if GetResourceState('qb-core') == 'started' then
    QBCore = exports['qb-core']:GetCoreObject()
elseif GetResourceState('es-extended') then
    ESX = exports['es_extended']:getSharedObject()
elseif GetResourceState('qbx_core') then
    qbx = exports.qbx_core
end