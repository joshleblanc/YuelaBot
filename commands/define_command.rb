module Commands
  class DefineCommand
    class << self
      def name
        [:define]
      end

      def attributes
        {
          description: 'Look up a word in the English dictionaries',
          usage: 'define word',
          min_args: 1,
        }
      end

      def command(event, *term)
        term = URI.encode_www_form_component(term.join(' '))

          wordnik_url = "https://api.wordnik.com/v4/word.json/#{term}/definitions"
          wordnik_headers = {
            limit: 1,
            includeRelated: true,
            useCanonical: false,
            includeTags: false,
            api_key: CONFIG['wordnik_key']
          }

          body = JSON.parse RestClient.get(wordnik_url, params: wordnik_headers)
          p body

          if body.first
            body.first['text']
          else
            "No results found for #{term}"
          end
      end
    end
  end
end
