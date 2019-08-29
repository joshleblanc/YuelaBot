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
    
    def build_embed(&blk)
        @update_block = -> {
            @embed.footer.text = "Page #{@index + 1}/#{@data.length} (#{@data.length} entries)"
            blk.call(@embed, @index)
        }
        @update_block.call
    end

    def send(event)
        @message = event.respond nil, false, @embed
        add_reactions
        add_awaits(event)
    end

    private

    def add_reactions
        @message.create_reaction("▶")
        @message.create_reaction("◀")
    end

    def add_awaits(event)
        BOT.add_await(:"#{@message.id}-pagination-next", ReactionAddEvent, emoji: "▶") do |reaction|
            next false unless reaction.message.id == @message.id
            @message.delete_reaction(reaction.user.id, reaction.emoji.name)
            if reaction.user.id == @user.id && @index < @data.length - 1
                @index += 1
                @update_block.call
                @message.edit nil, @embed
            end
            false
        end     
            
        BOT.add_await(:"#{@message.id}-pagination-prev", ReactionAddEvent, emoji: "◀") do |reaction|
            next false unless reaction.message.id == @message.id
            @message.delete_reaction(reaction.user.id, reaction.emoji.name)
            if reaction.user.id == @user.id && @index > 0
                @index -= 1
                @update_block.call
                @message.edit nil, @embed
            end
            false
        end
    end
end