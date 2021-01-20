module Commands
  class SteamCommand
    class << self
      include Discordrb::Webhooks
      def name
        :steam
      end

      def attributes
        {
            min_args: 1,
            max_args: 1,
            description: "Search a steam user",
            usage: "steam [username or id]"
        }
      end

      def command(e, *args)
        return if e.from_bot?

        if ENV['STEAM_KEY']
          Steam.apikey = ENV['STEAM_KEY']
        else
          return
        end

        user = args[0]
        begin
          user = Steam::User.vanity_to_steamid(user) if user =~ /\D/
        rescue
          return e.respond "No user found matching #{user}"
        end

        fields = []

        begin
          userdata = Steam::User.summary(user)
          fields << EmbedField.new(name: 'Account Created', value: Time.at(userdata['timecreated']).strftime("%B %-d, %Y"), inline: true)
        rescue
          return e.respond "No user found matching #{user}"
        end

        begin
          level = Steam::Player.steam_level(user)
        rescue
          level = "Private"
        end
        fields << EmbedField.new(name: "Level", value: level.to_s, inline: true)

        begin
          friends = Steam::User.friends(user).count
        rescue
          friends = "Private"
        end
        fields << EmbedField.new(name: "Friends", value: friends.to_s, inline: true)

        begin
          games = Steam::Player.owned_games(user)['game_count']
          if games.nil?
            games = 0
          end
        rescue
          games = "Private"
        end
        fields << EmbedField.new(name: "Games", value: games.to_s, inline: true)

        begin
          recentgames = Steam::Player.recently_played_games(user)
          if recentgames['games'].nil?
            raise
          end
          top3games = recentgames['games']
            .to_a
            .sort_by{ |k, v| -k['playtime_2weeks'] }
            .first(3)
            .map{ |k| "#{k['name']} - #{k['playtime_2weeks']} minutes"}
            .join("\n")
        rescue
          top3games = "No Activity"
        end
        fields << EmbedField.new(name: "Recent Games (2 weeks)", value: top3games.to_s, inline: false)

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
