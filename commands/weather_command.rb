module Commands
  class WeatherCommand
    class << self
      include Discordrb::Webhooks

      def name
        :weather
      end

      def attributes
        {
            description: 'Get the weather',
            usage: 'weather [city]',
            aliases: [:w]
        }
      end

      def command(event, *args)
        place = args.join(' ')
        url = 'http://api.openweathermap.org/data/2.5/weather'
        is_id = Integer(place) rescue false

        options = if is_id
          {id: place}
        else
          {q: place}
        end
        begin
          weather = JSON.parse RestClient.get(url, params: {appid: ENV['open_weather_key'], units: 'metric', **options})
          main = weather['main']
          fields = []
          fields << EmbedField.new(name: 'Temp (Celcius)', value: main['temp'].to_s, inline: true)
          fields << EmbedField.new(name: 'Max', value: main['temp_max'].to_s, inline: true)
          fields << EmbedField.new(name: 'Min', value: main['temp_min'].to_s, inline: true)
          embed = Embed.new(
              title: "#{weather['name']}, #{weather['sys']['country']}",
              description: weather['weather'][0]['description'],
              timestamp: Time.now,
              fields: fields,
              color: '#4545ff'
          )
          event.respond nil, false, embed
        rescue RestClient::NotFound
          "Didn't find anything for that city"
        end
      end
    end
  end
end