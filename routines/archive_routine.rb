module Routines
  def archive_routine(event)
    include Discordrb::Webhooks
    if event.message.pinned?
      pins = event.channel.pins
      if pins.length == 50
        archive = ArchiveConfig.find_by(server: event.server.id)
        if archive
          last_pin = pins.last
          last_pin.unpin
          archive_channel = BOT.channel(archive.channel, event.server)
          if last_pin.embeds.empty?
            archive_channel.send_embed do |embed|
              embed.author = EmbedAuthor.new(name: last_pin.author.name, icon_url: last_pin.author.avatar_url)
              embed.description = last_pin.content
              embed.footer = EmbedFooter.new(text: event.channel.name)
              embed.timestamp = last_pin.timestamp
            end
          else
            # Are you fucking kidding me. Why do I have to manually create all this shit
            archive_channel.send_embed(last_pin.content) do |embed|
              embed.timestamp = last_pin.embeds[0].timestamp
              embed.description = last_pin.embeds[0].description
              if last_pin.embeds[0].author
                embed.author = EmbedAuthor.new(
                    name: last_pin.embeds[0].author.name,
                    url: last_pin.embeds[0].author.url,
                    icon_url: last_pin.embeds[0].author.icon_url
                )
              end
              embed.color = last_pin.embeds[0].color
              embed.fields = Array(last_pin.embeds[0].fields).map do |field|
                EmbedField.new(
                    name: field.name,
                    inline: field.inline,
                    value: field.value
                )
              end
              if last_pin.embeds[0].footer
                embed.footer = EmbedFooter.new(
                    text: last_pin.embeds[0].footer.text,
                    icon_url: last_pin.embeds[0].footer.icon_url
                )
              end
              if last_pin.embeds[0].image
                embed.image = EmbedImage.new(
                    url: last_pin.embeds[0].image.url
                )
              end
              if last_pin.embeds[0].thumbnail
                embed.thumbnail = EmbedThumbnail.new(
                    url: last_pin.embeds[0].thumbnail.url
                )
              end
              embed.title = last_pin.embeds[0].title
              embed.url = last_pin.embeds[0].url
            end
          end
        end
      end
    end
  end
end