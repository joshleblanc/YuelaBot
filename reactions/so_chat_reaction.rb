module Reactions
  class SoChatReaction
    class << self
      def regex
        /https:\/\/chat\.stackoverflow\.com\/transcript\/message\/\d+/
      end

      def attributes
        {
            contains: self.regex
        }
      end

      def command
        lambda do |event|
          url = event.message.content.match(self.regex)[0]
          page = Nokogiri::HTML(open(url))
          container = page.at_css('div.highlight').parent.parent
          user = container.at_css('div.username').children[0]
          avatar = container.at_css('div.avatar').at_css('img').attr('src')
          time = container.at_css('div.timestamp').text
          message = container.at_css('div.content')
          room_name = page.at_css('span.room-name a').text
          p room_name
          embed = Discordrb::Webhooks::Embed.new(title: room_name)
          embed.author = Discordrb::Webhooks::EmbedAuthor.new
          embed.author.name = user.text
          embed.author.icon_url = avatar
          embed.author.url = "https://chat.stackoverflow.com#{user.attr('href')}"
          p user.text, user.attr('href'), avatar, time, message.text
          event.respond nil, false, embed
        end
      end
    end
  end
end