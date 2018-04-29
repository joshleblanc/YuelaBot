require 'discordrb'
require 'rbnacl/libsodium'
require 'google/apis/customsearch_v1'
require_relative './commands/replace_command'
require_relative './commands/google_image_command'
require_relative './commands/image_search'
include Commands



CONFIG = File.read('config').lines.each_with_object({}) do |l,o|
  parts = l.split('=')
  o[parts[0]] = parts[1].strip
end

bot = Discordrb::Bot.new token: CONFIG['discord']

bot.message(starting_with: '!!s', &replace_command)
bot.message(starting_with: '!!image', &ImageSearch.new(CONFIG['google'], CONFIG['search_id']).command)
bot.send_message('346409372152496138-439726621130358795', 'Hello, world!')
bot.run
