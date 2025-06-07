-- FX Information
fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
lua54 'yes'
game 'gta5'

-- Resource Information
name 'ps_lib'
version '1.0.0'
description 'Project Sloth Library'
author 'Project Sloth'

-- Manifest
client_scripts {
    --'@qbx_core/modules/playerdata.lua',
    'startFirst/client/**.lua',
    'bridge/framework/client.lua',
    'inventory/client.lua',
    'bridge/emote/client.lua',
    'modules/**/client/**.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'startFirst/server/**.lua',
    'bridge/framework/server.lua',
    'inventory/server.lua',
    'modules/**/server/**.lua',
    'orm.lua',
}

shared_scripts {
    'Config.lua',
    'startFirst/shared/**.lua',
    '@ox_lib/init.lua',
    'modules/**/shared/**.lua',
    'init.lua'
}


files {
  'web/build/index.html',
  'web/build/**/*',
  'bridge/**/*',
  'inventory/**/*',
}

ui_page 'web/build/index.html'