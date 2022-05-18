fx_version  'adamant'
game 'gta5'

author 'Yanis'
description 'Mecano RageUI V2'
version '2.0.0'

shared_scripts {
    "shared/config.lua",
}

client_scripts {
    "RageUI/RMenu.lua",
    "RageUI/menu/RageUI.lua",
    "RageUI/menu/Menu.lua",
    "RageUI/menu/MenuController.lua",
    "RageUI/components/*.lua",
    "RageUI/menu/elements/*.lua",
    "RageUI/menu/items/*.lua",
    "RageUI/menu/panels/*.lua",
    "RageUI/menu/windows/*.lua",
}

client_scripts {
    '@es_extended/locale.lua',
    'client/yns_cl_garage.lua',
    'client/yns_cl_menu.lua',
    'client/yns_cl_boss.lua',
    'client/yns_cl_coffre.lua',
    'client/yns_cl_ped.lua',
    'client/yns_cl_accueil.lua',
    'client/yns_cl_blips.lua',
    'client/yns_cl_vestiare.lua'
}

server_script {
    '@mysql-async/lib/MySQL.lua',
    '@es_extended/locale.lua',
    'server/yns_sv_mecano.lua',
}