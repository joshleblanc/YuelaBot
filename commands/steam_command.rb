module Commands
  class SteamCommand
    class << self
      include Discordrb::Webhooks
      def name
        :steam
      end

      def attributes
        {
            description: "Search a steam user",
            usage: "steam [username or id]"
        }
      end

      def command(e, *args)
        return if e.from_bot?

        if ENV['steam_key']
          Steam.apikey = ENV['steam_key']
        else
          return
        end

        user = args[0]
        user = Steam::User.vanity_to_steamid(user) if user =~ /\D/

        userdata = Steam::User.summary(user)
        friends = Steam::User.friends(user)
        games = Steam::Player.owned_games(user)
        recentgames = Steam::Player.recently_played_games(user)
        level = Steam::Player.steam_level(user)

        fields = []
        fields << EmbedField.new(name: 'Account Created', value: Time.at(userdata['timecreated']).strftime("%B %-d, %Y"), inline: true)
        fields << EmbedField.new(name: "Level", value: level.to_s, inline: true)
        fields << EmbedField.new(name: "Friends", value: friends.count.to_s, inline: true)
        fields << EmbedField.new(name: "Games", value: games['game_count'].to_s, inline: true)
        unless recentgames['games'].nil?
          top3games = recentgames['games']
            .to_a
            .sort_by{ |k, v| -k['playtime_2weeks'] }
            .first(3)
            .map{ |k| "#{k['name']} - #{k['playtime_2weeks']} minutes"}
          fields << EmbedField.new(name: "Recent Games (2 weeks)", value: top3games.join("\n"), inline: false)
        end
        embed = Embed.new(
          title: userdata['personaname'],
          thumbnail: EmbedThumbnail.new(url: userdata['avatar']),
          timestamp: Time.at(userdata['lastlogoff']),
          description: "",
          fields: fields,
          footer: EmbedFooter.new(text: 'Last Seen: ')
        )
        e.respond nil, nil, embed
      end
    end
  end
end
