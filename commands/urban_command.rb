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

        index = 0
        if term.last.numeric?
          term = term.take(term.size - 1).join ' '
          index = Integer(term.last - 1)
        else
          term = term.join ' '

        response = RestClient.get('http://api.urbandictionary.com/v0/define', params: {term: term})
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