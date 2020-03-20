module Commands
  class CovidCommand
    class << self
      def name
        :covid
      end

      def attributes
        {
          description: "Get the status of a country",
          usage: "covid <country>",
          aliases: []
        }
      end

      def command(event, *args)
        return if event.from_bot?
        resp = RestClient.get("https://pomber.github.io/covid19/timeseries.json")
        json = JSON.parse(resp.body)
        countries = json.keys
        if args.empty?
          pc = PaginationContainer.new("Valid Countries", countries, 10, event)
          pc.paginate do |embed, index|
            left = index * 10
            right = left + 10
            embed.description = "```\n"
            embed.description << countries[left...right].join("\n")
            embed.description << "\n```"
          end
          <<~RESPONSE
          ```
          #{json.keys.join "\n"}
          ```
          RESPONSE
        else
          country = args.join(' ').downcase
          country = countries.find { |c| c.downcase.start_with? country }

          data = json[country]&.last
          return "Not found" unless data
          <<~RESPONSE
          ```
          #{country}
          confirmed: #{data['confirmed']}
          deaths: #{data['deaths']}
          recovered: #{data['recovered']}
          ```
          RESPONSE
        end
      end
    end
  end
end
