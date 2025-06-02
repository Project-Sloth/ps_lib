Config = {}

Config.Notify = "ox" -- QBCore or ESX or ox
Config.Progressbar = "oxbar" -- QBCore or ESX or ox
Config.Target = "qb" -- QBCore or ESX or ox or interact 
Config.Inventory = "qb" -- QBCore or ESX or ox
Config.Logs = "discord" -- fivemerr or discord
ps = {}

QBCore, ESX, qbx = nil, nil, nil

if GetResourceState('qb-core') == 'started' then
    QBCore = exports['qb-core']:GetCoreObject()
elseif GetResourceState('es-extended') then
    ESX = exports['es_extended']:getSharedObject()
elseif GetResourceState('qbx_core') then
    qbx = exports.qbx_core
end