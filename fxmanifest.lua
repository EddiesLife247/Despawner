fx_version 'cerulean'
game 'gta5'
-- Resource Metadata
author 'EddiesLife247'
description 'Despawner Script'
version '1.0.0'
lua54 'yes' -- This ensures the asset is compatible with Lua 5.4



shared_script 'config.lua'

client_scripts {
    'client.lua',
}

server_scripts {
    'server.lua',
}


escrow_ignore {
    'config.lua', -- Ignoring the main configuration file

}

dependency 'qb-core'