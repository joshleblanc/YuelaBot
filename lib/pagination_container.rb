class PaginationContainer
  include Discordrb::Webhooks
  include Discordrb::Events
  
  def initialize(title, data, user)
    @index = 0
    @data = data
    @user = user
    @embed = Embed.new(title: title)
    @embed.footer = EmbedFooter.new
    @embed.footer.text = "Page #{@index}/#{@data.length} (#{@data.length} entries)"
    @embed.author = EmbedAuthor.new
    @embed.author.name = user.name
    @embed.author.icon_url = user.avatar_url
  end
  
  def paginate(event, &blk)
    @update_block = -> {
      @embed.footer.text = "Page #{@index + 1}/#{@data.length} (#{@data.length} entries)"
      blk.call(@embed, @index)
    }
    @update_block.call
    send(event)
  end
  private
  
  def send(event)
    @message = event.respond nil, false, @embed
    add_reactions
    add_awaits(event)
  end
  
  def add_reactions
    @message.create_reaction("▶")
    @message.create_reaction("◀")
  end
  
  def add_awaits(event)
    async_await(ReactionAddEvent, { emoji: "▶" }, true) do |response|
      next unless response.message.id == @message.id
      @message.delete_reaction(response.user.id, response.emoji.name)
      if response.user.id == @user.id && @index < @data.length - 1
        @index += 1
        @update_block.call
        @message.edit nil, @embed
      end
    end
    
    async_await(ReactionAddEvent, { emoji: "◀" }, true) do |response|
      next false unless response.message.id == @message.id
      @message.delete_reaction(response.user.id, response.emoji.name)
      if response.user.id == @user.id && @index > 0
        @index -= 1
        @update_block.call
        @message.edit nil, @embed
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
      rescue 
        p "Async await expired"
        Thread.current.kill
      end 
    end
  end
end