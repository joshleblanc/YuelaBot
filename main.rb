require 'discordrb'
require 'rbnacl/libsodium'
require 'google/apis/customsearch_v1'
require_relative './commands/replace_command'
require_relative './commands/google_image_command'
include Commands

CONFIG = File.read('config').lines.each_with_object({}) do |l,o|
  parts = l.split('=')
  o[parts[0]] = parts[1].strip
end

p CONFIG

bot = Discordrb::Bot.new token: CONFIG['discord']

bot.message(starting_with: '!!s', &replace_command)
bot.message(starting_with: '!!image', &google_image_command)

bot.run