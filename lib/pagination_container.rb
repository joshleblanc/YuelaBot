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

    async_await(ReactionAddEvent, { emoji: "⏮"}, true) do |response|
      next unless response.message.id == @message.id
      @message.delete_reaction(response.user.id, response.emoji.name)
      if response.user.id == @user.id && @index != 0
        @index = 0
        update
      end
    end

    async_await(ReactionAddEvent, { emoji: "▶" }, true) do |response|
      next unless response.message.id == @message.id
      @message.delete_reaction(response.user.id, response.emoji.name)
      if response.user.id == @user.id && @index < @data.length - 1
        @index += 1
        update
      end
    end
    
    async_await(ReactionAddEvent, { emoji: "◀" }, true) do |response|
      next unless response.message.id == @message.id
      @message.delete_reaction(response.user.id, response.emoji.name)
      if response.user.id == @user.id && @index > 0
        @index -= 1
        update
      end
    end

    async_await(ReactionAddEvent, { emoji: "⏭" }, true) do |response|
      next unless response.message.id == @message.id
      @message.delete_reaction(response.user.id, response.emoji.name)
      if response.user.id == @user.id && @index != num_pages
        @index = num_pages - 1
        update
      end
    end
  end
  
  def async_await(type, attr = {}, repeat = false)
    Thread.new do
      begin
        Timeout.timeout(attr.delete(:timeout) || 600) do
          loop do
            response = BOT.add_await!(type, attr)
            yield response
            break unless repeat
          end
        end
      rescue StandardError => e
        p e.message
        p "Async await expired"
        Thread.current.kill
      end 
    end
  end
end