module Reactions
  class DiscordMessageReaction
    class << self
      include Discordrb::Webhooks

      def regex
        /https:\/\/discord\.com\/channels\/\d+\/(\d+)\/(\d+)/
      end

      def attributes
        {
            contains: self.regex
        }
      end

      def command(event)
        match_data = event.message.content.match(self.regex)
        channel_id = match_data[1].to_i
        channel = event.server.channels.find { |c| c.id == channel_id }
        message = channel.message(match_data[2])
        if message
          if message.embeds.empty?
            embed = Embed.new(title: channel.name)
            embed.image = EmbedImage.new(url: message.attachments[0].url) unless message.attachments.empty?
            embed.description = message.content
            embed.color = '987654'.to_i(16)
            embed.url = match_data[0]
            embed.author = EmbedAuthor.new(name: message.author.username, icon_url: message.author.avatar_url, url: "")
            event.respond nil, false, embed
          else
            original_embed = message.embeds[0]
            embed = Embed.new(title: original_embed.title)
            
            if original_embed.thumbnail
              embed.image = EmbedImage.new(url: original_embed.url)
            elsif original_embed.image
              embed.image = EmbedImage.new(url: original_embed.image.url)
            end
            embed.description = original_embed.description
            embed.color = original_embed.color
            embed.url = original_embed.url
            embed.author = EmbedAuthor.new(name: original_embed.author.name, icon_url: original_embed.author.icon_url, url: original_embed.author.url) unless original_embed.author.nil?
            embed.fields = original_embed.fields.map do |field|
              EmbedField.new(
                name: field.name,
                value: field.value
              )
            end unless original_embed.fields.nil?
            embed.footer = EmbedFooter.new(text: original_embed.footer.text, icon_url: original_embed.footer.icon_url) unless original_embed.footer.nil?
            embed.timestamp = original_embed.timestamp
            event.respond nil, false, embed
          end

        else
          "No message found"
        end
      end
    end
  end
end
