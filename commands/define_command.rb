require_relative '../lib/helpers/escape'

module Commands
  class DefineCommand
    class << self
      include Helpers

      def name
        :define
      end

      def attributes
        {
            description: 'Look up a word in the English dictionaries',
            usage: 'define word',
            min_args: 1,
        }
      end

      def command(event, *term)
        return if event.from_bot?

        term = URI.encode_www_form_component(term.join(' '))

        wordnik_url = "https://api.wordnik.com/v4/word.json/#{term}/definitions"
        wordnik_headers = {
            limit: 5,
            includeRelated: true,
            useCanonical: true,
            includeTags: false,
            api_key: ENV['wordnik_key']
        }

        begin
          body = JSON.parse RestClient.get(wordnik_url, params: wordnik_headers)
          p body

          unless body.first
            return "No results found for #{term}"
          end

          defs = body.select { |w| w["text"] }
          unless defs.first
            word_url = body.first["wordnikUrl"]
            return "Word found, but no definition provided. Try visiting #{word_url}."
          end

          defs.map { |w|
            text = escape_md w["text"]
            pos = escape_md w["partOfSpeech"]

            "*#{pos}*. #{text}"
          }.join "\n"
        rescue RestClient::NotFound
          "Word not found"
        end
      end
    end
  end
end
