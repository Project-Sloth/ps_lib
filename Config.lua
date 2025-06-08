Config = {}

Config.Notify = "qb" -- QBCore or ESX or ox
Config.Progressbar = "qb" -- QBCore or ESX or ox
Config.Target = "qb" -- QBCore or ESX or ox or interact 
Config.Inventory = "qb" -- QBCore or ESX or ox
--TODO #14
Config.Logs = "fivemerr" -- fivemerr or fivemanage 

ps = {}

QBCore, ESX, qbx = nil, nil, nil

if GetResourceState('qb-core') == 'started' then
    QBCore = exports['qb-core']:GetCoreObject()
elseif GetResourceState('es-extended') then
    ESX = exports['es_extended']:getSharedObject()
elseif GetResourceState('qbx_core') then
    qbx = exports.qbx_core
end