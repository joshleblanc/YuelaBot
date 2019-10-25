require_relative '../lib/helpers/markdown'

module Reactions
  class SoChatReaction
    class << self
      include Discordrb::Webhooks
      include Helpers

      def regex
        /https:\/\/chat(\.meta)?\.stack(overflow|exchange)\.com\/transcript\/(message\/|\d+\?m=)(\d+)/
      end

      def attributes
        {
            contains: self.regex
        }
      end

      def command(event)
        match_data = event.message.content.match(self.regex)
        url = match_data[0]

        transcript = Nokogiri::HTML(open(url), nil, Encoding::UTF_8.to_s)
        message = transcript.at_css('div.highlight')
        container = message.parent.parent
        user = container.at_css('div.username').children[0]
        avatar = container.at_css('div.avatar').at_css('img').attr('src')
        image = container.css('div.content img')
        room = transcript.at_css('span.room-name a')
        embed = Embed.new(title: room.text)
        embed.image = EmbedImage.new(url: image.attr('src')) unless image.empty?
        embed.description = html_to_md(message.css('.content').inner_html)
        embed.color = '123123'.to_i(16)
        embed.url = "https://chat.stackoverflow.com/#{room.attr('href')}"
        embed.author = EmbedAuthor.new(name: user.text, icon_url: avatar, url: "https://chat.stackoverflow.com#{user.attr('href')}")
        event.respond nil, false, embed
      end
    end
  end
end