class UserCommand < ApplicationRecord
    def run
        lambda do |_, *args|
            test = args.join(' ')
            p test, input, output
            if input == '.*' || test.match(/#{input}/)
              test.sub(/#{input}/, output)
            end
          end
    end
end
