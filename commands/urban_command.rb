module Commands
  class UrbanCommand
    class << self
      include Discordrb::Webhooks

      def name
        :urban
      end

      def attributes
        {
            max_args: 1,
            usage: 'urban term',
            description: 'Return the urban dictionary definition for a term.'
        }
      end

      def command(event, *term)
        return if event.from_bot?
        response = RestClient.get('http://api.urbandictionary.com/v0/define', params: {term: term.join(' ')})
        body = JSON.parse response

        if body['list'].length > 0
          pagination_container = PaginationContainer.new("Urban Dictionary", body['list'], 1, event)
          pagination_container.paginate do |embed, index|
            definition = body['list'][index]
            embed.title = definition['word']
            embed.description = definition['definition']
            embed.url = definition['permalink']
            embed.author = EmbedAuthor.new(name: definition['author'])
            embed.timestamp = Time.parse(definition['written_on'])
            embed.fields = [EmbedField.new(name: "Example", value: definition['example'])]
          end
        else
          event << "I couldn't find anything for that"
        end
      end
    end
  end
end