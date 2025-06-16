Config = {}

Config.Notify = "ox" -- qb, ox, ps
Config.Progressbar = "oxcir" -- qb, oxcir, oxbar
Config.Logs = "fivemerr" -- fivemerr or fivemanage 
Config.Language = "en" -- en or de or fr or es or pt or tr
ps = {}

QBCore, ESX, qbx = nil, nil, nil

if GetResourceState('qbx_core') then
    qbx = exports.qbx_core
elseif GetResourceState('es-extended') then
    ESX = exports['es_extended']:getSharedObject()
elseif GetResourceState('qb-core') then
    QBCore = exports['qb-core']:GetCoreObject()
end