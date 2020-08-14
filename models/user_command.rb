class UserCommand < ApplicationRecord
  def self.can_create?(name)
    existing_command = Commands.constants.find do |c|
      command = Commands.const_get(c)
      command.is_a?(Class) && [command.name, *command.attributes[:aliases]].include?(name.to_sym)
    end
    blacklisted_commands = ['help']
    !existing_command && !blacklisted_commands.include?(name)
  end

  def run(event, *args)
    return if event.from_bot?

    test = args.join(' ')
    if input == '.*' || test.match(/#{input}/)
      response = test.gsub(/#{input}/, output)
      response.gsub! /:.+?:(?!\d+>)/ do |m|
        formatted_emoji = BOT.all_emoji.find {|e| e.name == m[1...-1]}
        if formatted_emoji
          formatted_emoji.mention
        else
          m
        end
      end
      response
    end
  end
end
