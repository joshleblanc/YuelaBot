class UserCommand < ApplicationRecord
    def run
        lambda do |_, *args|
            test = args.join(' ')
            if input == '.*' || test.match(/#{input}/)
              response = test.gsub(/#{input}/, output)
              matches = response.scan /:.+?:(?!\d+>)/
              matches.each do |m|
                formatted_emoji = BOT.all_emoji.find { |e| e.name == m[1...-1] }
                response.sub!(m, formatted_emoji) if formatted_emoji
              end
              response
            end
        end
    end
end
