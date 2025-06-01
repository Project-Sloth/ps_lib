Config = {}
Config.Framework = "qb" -- qb or esx or qbx Needed for functions to work
Config.Notify = "qb" -- QBCore or ESX or ox
Config.Progressbar = "oxbar" -- QBCore or ESX or ox
Config.Target = "qb" -- QBCore or ESX or ox or interact 
Config.Inventory = "qb" -- QBCore or ESX or ox
Config.Logs = "discord" -- fivemerr or discord
ps = {}
if Config.Framework == "qb" then
    QBCore = exports['qb-core']:GetCoreObject()
elseif Config.Framework == "esx" then
    ESX = exports['es_extended']:getSharedObject()
elseif Config.Framework == "qbx" then
    qbx = exports.qbx_core
end 