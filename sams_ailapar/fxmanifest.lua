
fx_version 'cerulean'
game 'gta5'
author 'Sams'

version '1.0.0'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'locales/en.lua', 
    'locales/*.lua',
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client.lua',
}

server_scripts {
    'server.lua',
    '@oxmysql/lib/MySQL.lua',
}

ox_lib "locale"

lua54 'yes'
use_experimental_fxv2_oal 'yes'
