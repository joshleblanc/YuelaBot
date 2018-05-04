module Reactions
  class ReplaceReaction
    class << self
      def attributes
        {
            start_with: '!!s'
        }
      end

      def command
        lambda do |event|
          p "Running replace"
          messages = JSON.parse(Discordrb::API::Channel.messages(CONFIG['discord'], event.channel.id, 100).body)
          message = event.message.content
          parts = message.split('/', -1)
          regex = /#{parts[1]}/
          target = messages.find { |m| m['content'].match(regex) && m['id'].to_i != event.message.id }
          if target
            if parts[3] === 'g'
              target['content'].gsub! regex, parts[2]
            else
              target['content'].sub! regex, parts[2]
            end
            event.respond target['content']
          end
        end
      end
    end
  end
end
