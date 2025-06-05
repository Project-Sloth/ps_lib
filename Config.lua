Config = {}

Config.Notify = "ox" -- qb, ox, ps 
Config.Progressbar = "oxbar" -- qb, oxbar, oxcircle
Config.Target = "qb" -- QBCore or ESX or ox or interact 
Config.Logs = "fivemerr" -- fivemerr
ps = {}

QBCore, ESX, qbx = nil, nil, nil

if GetResourceState('qb-core') == 'started' then
    QBCore = exports['qb-core']:GetCoreObject()
elseif GetResourceState('es-extended') then
    ESX = exports['es_extended']:getSharedObject()
elseif GetResourceState('qbx_core') then
    qbx = exports.qbx_core
end