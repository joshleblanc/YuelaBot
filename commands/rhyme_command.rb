module Commands
  class RhymeCommand
    class << self
      include Discordrb::Webhooks

      def name
        :rhyme
      end

      def attributes
        {
          min_args: 1,
          usage: 'rhyme term',
          description: 'Return a list of rhymes for a term.'
        }
      end

      def command(event, *term)
        return if event.from_bot?

        request = 'https://api.datamuse.com/words?rel_rhy=' << term[0]
        response = RestClient.get(request)
        body = JSON.parse response

        groups = body.group_by { |word| word['numSyllables'] }

        if groups.empty?
          event << 'No synonyms for the word ' << term[0] << ' were found'
        end

        groups_sorted = groups.sort_by { |num_syllables| num_syllables }
        embed_fields = groups_sorted.map do |(num_syllables, syllables)|
          EmbedField.new(
            name: "Syllables: #{num_syllables}",
            value: syllables
                .sort_by { |group| group['score'] }
                .map { |group| group['word'] }
                .join(', ')
          )
        end

        embed = Embed.new(
          title: 'Words that rhyme with ' << term[0],
          fields: embed_fields
        )
        event.respond nil, false, embed
      end
    end
  end
end