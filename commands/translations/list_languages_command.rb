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

        languages = Apis::Azure::Translator.languages
        
        response = StringIO.new
        response.puts '```'
        response.printf "%-7s %s\n", "ID", "Name"
        languages['translation'].each do |k, v|
          response.printf "%-7s %s\n", k, v['name']
        end
        response.puts '```'
        response.string
      end
    end
  end
end