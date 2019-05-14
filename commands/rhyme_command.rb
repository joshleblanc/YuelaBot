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

        request = "https://api.datamuse.com/words?rel_rhy=#{term[0]}"
        response = RestClient.get(request)
        body = JSON.parse response

        groups = body.group_by { |word| word['numSyllables'] }

        if groups.empty?
          return "No synonyms for the word #{term[0]} were found"
        end

        embed_fields = groups.sort_by { |g| g }.map do |(num_syllables, words)|
          words.sort_by! { |word| word['score'] || 0 }
          words.map! { |word| word['word'] }
          words.reverse!
          EmbedField.new(
            name: "Syllables: #{num_syllables}",
            value: words.join(', ')
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
