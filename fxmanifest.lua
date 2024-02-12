fx_version 'adamant'

game 'gta5'

description 'Craft'

server_scripts {
	'config.lua',
	-- 'server.lua'
}

client_scripts {
	'client.lua'
}

ui_page {
	'assets/index.html'
}

files {
	"assets/index.html",
	"assets/css/styles.css",
	"assets/js/jquery.min.js",
	"assets/js/script.js"
}

dependencies {
	'es_extended'
}