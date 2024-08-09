fx_version 'cerulean'
game 'gta5'

author 'BungeeException'
description 'Gas Station Script'
version '1.0'

client_scripts {
    'config.lua',
    'client/main.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'config.lua',
    'server/main.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/app.js'
}

exports {
    'SetFuel',
    'GetFuel'
}
