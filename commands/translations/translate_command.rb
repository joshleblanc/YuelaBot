module Commands
  class TranslateCommand
    class << self

      def name
        :translate
      end

      def attributes
        {
            min_args: 3,
            description: "Translate something to another language. Get available languages with !!list_languages",
            usage: "translate [source id] [target id] [words]",
            aliases: [:tr]
        }
      end

      def command(e, *input)
        return if e.from_bot?

        input_string = input.join(' ')
        

        query = args.join(' ')
        translation = Apis::Azure::Translator.translate(query, to: target, from: source)
        if translation.any?
          translation[0]['translations'][0]['text']
        else
          "No translations found"
        end
      end
    end
  end
end