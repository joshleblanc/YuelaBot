module Commands
  class ListLanguagesCommand
    class << self
      def name
        :list_languages
      end

      def attributes
        {
            usage: "list_languages",
            description: "List languages for the translate command",
            aliases: [:ll]
        }
      end

      def command(e)
        return if e.from_bot?

        service = Google::Apis::TranslateV2::TranslateService.new
        service.key = ENV['google']
        languages = service.list_languages(target: 'en').languages

        response = StringIO.new
        response.puts '```'
        response.printf "%-5s %s\n", "ID", "Name"
        languages.each do |l|
          response.printf "%-5s %s\n", l.language, l.name
        end
        response.puts '```'
        response.string
      end
    end
  end
end