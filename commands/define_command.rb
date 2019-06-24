module Commands
  class DefineCommand
    class << self
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
            limit: 1,
            includeRelated: true,
            useCanonical: false,
            includeTags: false,
            api_key: ENV['wordnik_key']
        }

        begin
          body = JSON.parse RestClient.get(wordnik_url, params: wordnik_headers)
          p body

          if body.first
            if body.first['text']
              body.first['text']
            else
              "Word found, but no definition provided"
            end
          else
            "No results found for #{term}"
          end
        rescue RestClient::NotFound => e
          "Word not found"
        end
      end
    end
  end
end
