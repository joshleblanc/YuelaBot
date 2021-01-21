module Commands
  class MmrCommand
    class << self
      include Discordrb::Webhooks

      def name
        :mmr
      end
  
      def options_parser
        @options_parser ||= OptionsParserMiddleware.new do |option_parser, options|
          option_parser.on("-s", "--server SERVER", "Specify the server the player players on. Accepts US, EU, KR") do |server|
            options[:server] = server
          end
  
          option_parser.on("-r", "--race RACE", "Specify the race of the player. Accepts terran, zerg, protoss") do |race|
            options[:race] = race
          end
  
          option_parser.banner = "Usage: mmr [options] name"
        end
      end
  
      def middleware
        [
          options_parser
        ]
      end
  
      def attributes
        {
          description: <<~USAGE,
            Lookup sc2 players
            #{options_parser.usage}
          USAGE
      }
      end
  
      def command(e, *args)
        return if e.from_bot?
  
        options, *input = args
  
        race = options[:race].to_s[0]&.downcase
        server = options[:server].to_s[0]&.downcase
        response = RestClient.get("https://www.sc2ladder.com/api/player?query=#{input[0]}&limit=200")
  
        data = JSON.parse(response.body)
        data.select! { |d| d["username"].downcase == input[0].downcase || d["bnet_id"].split("#").last.downcase == input[0].downcase }
        data.select! { |d| d["race"][0].downcase == race } if race
        data.select! { |d| d["region"][0].downcase == server } if server
        if data.any?
          player = data.first
          e.channel.send_embed do |embed|
            embed.title = "SC2Ladder Result"
            embed.fields = [
              EmbedField.new(name: "Race", value: player["race"], inline: true),
              EmbedField.new(name: "Username", value: player["username"], inline: true),
              EmbedField.new(name: "League", value: player["rank"], inline: true),
              EmbedField.new(name: "Wins", value: player["wins"], inline: true),
              EmbedField.new(name: "Losses", value: player["losses"], inline: true),
              EmbedField.new(name: "MMR", value: player["mmr"], inline: true),
              EmbedField.new(name: "Server", value: player["region"], inline: true),
              EmbedField.new(name: "Clan", value: player["clan"], inline: true)
            ].reject { |f| f.value.blank? }
          end
        else
          "Couldn't find anything for #{input[0]}"
        end
      end
    end
    
  end
end
