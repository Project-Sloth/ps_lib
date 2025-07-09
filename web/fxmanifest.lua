fx_version 'cerulean'

games {"gta5", "rdr3"}

author "Project Error"
version '1.0.0'

lua54 'yes'

ui_page 'web/build/index.html'

client_script "client/**/*.lua"
server_script "server/**/*.lua"
shared_script "shared/**/*.lua"
files {
  'web/build/index.html',
  'web/build/**/*'
}
