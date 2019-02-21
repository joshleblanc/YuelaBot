class UserReaction < ApplicationRecord
    def run
        lambda do |event|
          event << event.message.sub(/#{regex}/, output)
        end
    end
end