Config = {}
Config.Framework = "qbx" -- QBCore or ESX
Config.Notify = "ox" -- QBCore or ESX or ox
Config.Progressbar = "oxbar" -- QBCore or ESX or ox
Config.Target = "ox" -- QBCore or ESX or ox or interact 
Config.Inventory = "ox" -- QBCore or ESX or ox
ps = {}
if Config.Framework == "qb" then
    QBCore = exports['qb-core']:GetCoreObject()
elseif Config.Framework == "esx" then
    ESX = exports['es_extended']:getSharedObject()
elseif Config.Framework == "qbx" then
    qbx = exports.qbx_core
end