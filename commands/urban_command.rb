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
            usage: 'urban term',
            description: 'Return the urban dictionary definition for a term'
        }
      end

      def command
        lambda do |event, *term|
          term = term.join ' '
          response = RestClient.get('http://api.urbandictionary.com/v0/define', params: { term: term })
          body = JSON.parse response
          definition = body['list'].first
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
end