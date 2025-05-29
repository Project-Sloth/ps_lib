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
    --'@qbx_core/modules/playerdata.lua',
    'startFirst/client/**.lua',
    'framework/**.lua',
    'inventory/**.lua',
    'modules/**/client/**.lua',

}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'startFirst/server/**.lua',
    'framework/**.lua',
    'inventory/**.lua',
    'modules/**/server/**.lua',
    'orm.lua'
}

shared_scripts {
    '@ox_lib/init.lua',
    'Config.lua',
    'startFirst/shared/**.lua',
    'modules/**/shared/**.lua',
    'init.lua'
}


files {
  'web/build/index.html',
  'web/build/**/*'
}

ui_page 'web/build/index.html'