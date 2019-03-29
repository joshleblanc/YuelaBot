class UserCommand < ApplicationRecord
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
