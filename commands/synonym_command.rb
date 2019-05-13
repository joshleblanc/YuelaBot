module Commands
  class SynonymCommand
    class << self
      include Discordrb::Webhooks

      def name
        :synonym
      end

      def attributes
        {
          min_args: 1,
          usage: 'synonym term',
          description: 'Return a list of synonyms for a term.'
        }
      end

      def command(event, *term)
        return if event.from_bot?

        request = 'https://api.datamuse.com/words?rel_syn=' << term[0]
        response = RestClient.get(request)
        body = JSON.parse response

        wordset = body.sort { |word| word['score'] }
        words = body.map { |word| word['word'] }

        if words.empty?
          event << 'No synonyms for the word were found'
          return
        end

        embed = Embed.new(
          title: 'Synonyms for ' << term[0],
          description: words.join(', ')
        )
        event.respond nil, false, embed
      end
    end
  end
end