module Reactions
  class HyperReplaceReaction
    class << self
      def attributes
        {
            start_with: '!!s;'
        }
      end

      def command(event)
        message = event.message.content
        parts = message.match('^!!s;(\\d+)/(.*)/(\\w*)$')
        if parts == nil
          return
        end
        input_message = event.channel.message(parts[1]).content
        options = 0
        options += Regexp::IGNORECASE if parts[3].include? 'i'
        options += REGEXP::MULTILINE if parts[3].include? 'm'
        options += REGEXP::EXTENDED if parts[3].include? 'x'
        regexes = parts[2].split(/(?<!\\)\//, -1)
        if regexes.length.odd?
          event.respond 'Missing a replacement'
          return
        end
        regexes = regexes.group_by.with_index { |_, i| i % 2 }
        replacements = regexes[1]
        regexes = regexes[0].map { |r| Regexp.new(r, options) }
        i = 0
        while i < 1000
          index = regexes.find_index { |r| r.match(input_message) }
          if index == nil
            break
          end
          input_message.sub!(regexes[index], replacements[index])
          i += 1
        end
        if i >= 1000
          event.respond 'Too much looping'
          return
        end
        if i == 0
          return
        end
        event.respond input_message
      end
    end
  end
end
