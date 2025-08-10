
fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
lua54 'yes'
game 'gta5'

name 'ps_lib'
version '0.5.2'
description 'Project Sloth Library'
author 'Project Sloth'

client_scripts {
    '@qbx_core/modules/playerdata.lua',
    'startFirst/client/**.lua',
    'modules/**/client/**.lua',
    'bridge/client.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'startFirst/server/**.lua',
    'modules/**/server/**.lua',
    'bridge/server.lua',
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
  'locales/*.json',
}

ui_page 'web/build/index.html'