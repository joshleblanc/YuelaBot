module Commands
  class UrbanCommand
    class << self
      include Discordrb::Webhooks

      def name
        :urban
      end

      def attributes
        {
            min_args: 1,
            usage: 'urban term index?',
            description: 'Return the urban dictionary definition for a term. Index is optional and will default to 1.'
        }
      end

      def command(event, *term)
        return if event.from_bot?

        has_index = Integer(term.last) rescue false
        index = if has_index
          term.pop
        else
          0
        end

        index = 0 if index < 0

        response = RestClient.get('http://api.urbandictionary.com/v0/define', params: {term: term.join(' ')})
        body = JSON.parse response
        definition = body['list'][index]
        if definition
          embed = Embed.new(
              title: definition['word'],
              description: definition['definition'],
              url: definition['permalink'],
              author: EmbedAuthor.new(name: definition['author']),
              timestamp: Time.parse(definition['written_on']),
              fields: [EmbedField.new(name: 'Example', value: definition['example'])]
          )
          event.respond nil, false, embed
        else
          event << "I couldn't find anything for that"
        end
      end
    end
  end
end