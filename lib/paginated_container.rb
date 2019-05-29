module Lib
  class PaginatedContainer
    include Discordrb::Webhooks
    include Discordrb::Events
    def initialize(title = "", type)
      @index = 0
      @results = []
      @embed = Embed.new(title: title)
      @type = type # :image or :video
    end

    def set_data_routine(&blk)
      @routine = blk
    end

    def run(query, event)
      if query == '^'
        query = event.channel.history(2).last.content
      end
      @results = @routine.call(query)
      @user = event.user
      if @results.length > 0
        update_embed
        @message = event.respond nil, nil, @embed
        add_reactions
        add_awaits event.bot
      end
      nil
    end

    def reset
      @index = 0
      @results = []
    end

    private

    def add_awaits(bot)
      bot.add_await("#{@message.id}-#{@embed.title}_next", ReactionAddEvent, emoji: "▶") do |reaction|
        next false unless reaction.message.id == @message.id
        @message.delete_reaction(reaction.user.id, reaction.emoji.name)
        if reaction.user.id == @user.id && @index < @results.length - 1
          @index += 1
          update_embed
          @message.edit nil, @embed
        end
        false
      end

      bot.add_await("#{@message.id}-#{@embed.title}_prev", ReactionAddEvent, emoji: "◀") do |reaction|
        next false unless reaction.message.id == @message.id
        @message.delete_reaction(reaction.user.id, reaction.emoji.name)
        if reaction.user.id == @user.id && @index > 0
          @index -= 1
          update_embed
          @message.edit nil, @embed
        end
        false
      end
    end

    def update_embed
      if @type == :image
        update_image
      else
        update_video
      end
      update_author
      update_footer
    end

    def update_video
      # TODO: implement
    end

    def update_image
      @embed.image ||= EmbedImage.new
      @embed.image.url = @results[@index]
    end

    def update_author
      @embed.author ||= EmbedAuthor.new
      @embed.author.name = @user.name
      @embed.author.icon_url = @user.avatar_url
    end

    def update_footer
      @embed.footer ||= EmbedFooter.new
      @embed.footer.text = "Page #{@index + 1}/#{@results.length} (#{@results.length} entries)"
    end

    def add_reactions
      @message.create_reaction("▶")
      @message.create_reaction("◀")
    end
  end
end