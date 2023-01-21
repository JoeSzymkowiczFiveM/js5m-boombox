fx_version 'cerulean'
game 'gta5'

author 'Joe Szymkowicz'
description 'js5m-boombox'
version '1.0.0'

lua54 'yes'

shared_scripts {
	'@ox_lib/init.lua',
    'shared/config.lua',
}

client_scripts{
    'client/client.lua',
}

server_scripts{
    'server/server.lua',
}
