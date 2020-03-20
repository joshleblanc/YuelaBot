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
          aliases: [],
          min_args: 1
        }
      end

      def command(event, *args)
        return if event.from_bot?
        country = args[0].capitalize

        resp = RestClient.get("https://pomber.github.io/covid19/timeseries.json")
        json = JSON.parse(resp.body)
        data = json[country].last
        <<~RESPONSE
          ```
          confirmed: #{data['confirmed']}
          deaths: #{data['deaths']}
          recovered: #{data['recovered']}
          ```
        RESPONSE
      end
    end
  end
end
