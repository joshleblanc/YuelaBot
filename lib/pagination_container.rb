class PaginationContainer
  include Discordrb::Webhooks
  include Discordrb::Events
  
  def initialize(title, data, page_size, event)
    @index = 0
    @data = data
    @user = event.user
    @event = event
    @embed = Embed.new(title: title)
    @embed.footer = EmbedFooter.new
    @embed.footer.text = "Page #{@index}/#{@data.length} (#{@data.length} entries)"
    @embed.author = EmbedAuthor.new
    @embed.author.name = @user.name
    @embed.author.icon_url = @user.avatar_url
    @page_size = page_size.to_f
  end
  
  def paginate(&blk)
    @update_block = -> {
      @embed.footer.text = "Page #{@index + 1}/#{num_pages} (#{@data.length} entries)"
      blk.call(@embed, @index)
    }
    @update_block.call
    send
  end
  private
  
  def send
    @message = @event.respond nil, false, @embed
    add_reactions
    add_awaits
  end

  def num_pages
    (@data.length / @page_size).ceil
  end
  
  def add_reactions
    @message.create_reaction("⏮")
    @message.create_reaction("◀")
    @message.create_reaction("▶")
    @message.create_reaction("⏭")
  end

  def update
    @update_block.call
    @message.edit nil, @embed
  end
  
  def add_awaits
    threads = []
    emojis = {
      start: "⏮",
      back: "◀",
      next: "▶",
      end: "⏭"
    }
    loop do
      response = BOT.add_await!(ReactionAddEvent, timeout: 60)
      break unless response
      next unless response.user.id == @user.id
      case response.emoji.name
      when emojis[:start]
        @index = 0 unless @index == 0
      when emojis[:back]
        @index -= 1 if @index > 0
      when emojis[:next]
        @index += 1 if @index < @data.length - 1
      when emojis[:end]
        @index = num_pages - 1 unless @index == num_pages
      end
      if emojis.values.include?(response.emoji.name)
        update
        @message.delete_reaction(response.user.id, response.emoji.name)
      end
    end
    @message.delete_all_reactions
  end
end