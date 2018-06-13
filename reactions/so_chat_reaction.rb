module Reactions
  class SoChatReaction
    class << self
      include Discordrb::Webhooks

      def regex
        /https:\/\/chat\.stackoverflow\.com\/transcript\/message\/(\d+)/
      end

      def attributes
        {
            contains: self.regex
        }
      end

      def command
        lambda do |event|
          match_data = event.message.content.match(self.regex)
          url = match_data[0]

          transcript = Nokogiri::HTML(open(url))
          container = transcript.at_css('div.highlight').parent.parent
          user = container.at_css('div.username').children[0]
          avatar = container.at_css('div.avatar').at_css('img').attr('src')
          message = container.css('div.content').map do |el|
            el.text.strip
          end.join("\n")
          room = transcript.at_css('span.room-name a')
          embed = Embed.new(title: room.text)
          embed.description = message
          embed.color = '123123'.to_i(16)
          embed.url = "http://chat.stackoverflow#{room.attr('href')}"
          embed.author = EmbedAuthor.new(name: user.text, icon_url: avatar, url: "https://chat.stackoverflow.com#{user.attr('href')}")
          event.respond nil, false, embed
        end
      end
    end
  end
end