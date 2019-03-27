module Routines

  def archive_text(event, archive_channel, last_pin)
    archive_channel.send_embed do |embed|
      embed.author = EmbedAuthor.new(name: last_pin.author.name, icon_url: last_pin.author.avatar_url)
      embed.description = last_pin.content
      embed.footer = EmbedFooter.new(text: event.channel.name)
      embed.timestamp = last_pin.timestamp
    end
  end

  def archive_embed(archive_channel, last_pin)
    last_embed = last_pin.embeds.first
    archive_channel.send_embed(last_pin.content) do |embed|
      embed.timestamp = last_embed.timestamp
      embed.description = last_embed.description
      if last_embed.author
        embed.author = EmbedAuthor.new(
            name: last_embed.author.name,
            url: last_embed.author.url,
            icon_url: last_embed.author.icon_url
        )
      end
      embed.color = last_embed.color
      embed.fields = Array(last_embed.fields).map do |field|
        EmbedField.new(
            name: field.name,
            inline: field.inline,
            value: field.value
        )
      end
      if last_embed.footer
        embed.footer = EmbedFooter.new(
            text: last_embed.footer.text,
            icon_url: last_embed.footer.icon_url
        )
      end
      if last_embed.image
        embed.image = EmbedImage.new(
            url: last_embed.image.url
        )
      end
      if last_embed.thumbnail
        embed.thumbnail = EmbedThumbnail.new(
            url: last_embed.thumbnail.url
        )
      end
      embed.title = last_embed.title
      embed.url = last_embed.url
    end
  end

  def archive_routine(event)
    include Discordrb::Webhooks
    return unless event.message.pinned?
    return unless event.channel.pins.length == 50

    archive = ArchiveConfig.find_by(server: event.server.id)
    return unless archive
    last_pin = event.channel.pins.last
    last_pin.unpin
    archive_channel = BOT.channel(archive.channel, event.server)
    if last_pin.embeds.empty?
      archive_text(event, archive_channel, last_pin)
    else
      archive_embed(archive_channel, last_pin)
    end
  end
end