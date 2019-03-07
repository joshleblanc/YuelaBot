class UserCommand < ApplicationRecord
    def run
        lambda do |_, *args|
            test = args.join(' ')
            if input == '.*' || test.match(/#{input}/)
              response = test.gsub(/#{input}/, output)
              response.split(' ').map do |word|
                if word.match /:.+?:/
                  formatted_emoji = BOT.all_emoji.find { |e| e.name == word[1...-1] }
                  if formatted_emoji
                    formatted_emoji.mention
                  else
                    word
                  end
                else
                  word
                end
              end.join(' ')
            end
        end
    end
end
