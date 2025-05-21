-- FX Information
fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
lua54 'yes'
game 'gta5'

-- Resource Information
name 'ps_lib'
version '1.0.0'
description 'Project Sloth Library'

-- Manifest
client_scripts {
    '@qbx_core/modules/playerdata.lua',
    'debug.lua',
    'framework/**.lua',
    'inventory/**.lua',
    'requests.lua',
    'raycast.lua',
    'coordGrabber.lua',
    'getnear.lua',
    'commands.lua',
    'interactions.lua',
    'misc.lua',
    'targets.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'debug.lua',
    'framework/**.lua',
    'inventory/**.lua',
    'commands.lua',
    'interactions.lua',
    'misc.lua',
}

shared_scripts {
    '@ox_lib/init.lua',
    'Config.lua',
    'init.lua'
}


files {
  'web/build/index.html',
  'web/build/**/*'
}

ui_page 'web/build/index.html'