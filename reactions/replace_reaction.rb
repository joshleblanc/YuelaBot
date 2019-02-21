module Reactions
  class ReplaceReaction
    class << self
      def attributes
        {
            start_with: '!!s/'
        }
      end

      def command(event)
        messages = JSON.parse(Discordrb::API::Channel.messages(ENV['discord'], event.channel.id, 100).body)
        message = event.message.content
        parts = message.split('/', -1)
        options = 0
        options += Regexp::IGNORECASE if parts[3].include? 'i'
        options += REGEXP::MULTILINE if parts[3].include? 'm'
        options += REGEXP::EXTENDED if parts[3].include? 'x'
        regex = Regexp.new(parts[1], options)
        target = messages.find { |m| m['content'].match(regex) && m['id'].to_i != event.message.id }
        if target
          if parts[3].include? 'g'
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
