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

      def init

      end

      def command(e, source, target, *args)
        return if e.from_bot?

        service = Google::Apis::TranslateV2::TranslateService.new
        service.key = ENV['google']
        query = args.join(' ')
        translation = service.list_translations(query, target, source: source).translations.first
        if translation
          translation.translated_text
        else
          "No translations found"
        end
      end
    end
  end
end