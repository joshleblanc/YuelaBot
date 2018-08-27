module Commands
  class ImageSearch

    class << self
      def name
        [:image, :i]
      end

      def attributes
        {
            min_args: 1,
            description: 'Searches google image for a given query',
            usage: 'image [query]'
        }
      end

      def command
        is = ImageSearch.new
        lambda do |event, *args|
          is.reset!
          is.run!(event, args.join)
        end
      end
    end

    include Discordrb::Webhooks
    include Discordrb::Events
    def initialize
      @index = 0
      @images = []
      @engine_id = CONFIG['search_id']
      @embed = Embed.new(title: "Image Search Results")
      @service = Google::Apis::CustomsearchV1::CustomsearchService.new
      @service.key = CONFIG['google']
    end

    def reset!
      @index = 0
      @images = []
    end

    def run!(event, query)
      if query == '^'
        query = event.channel.history(2).last.content
      end
      @images = get_images(query)
      @user = event.user
      if @images.length > 0
        update_embed!
        @message = send! event
        add_reactions!
        add_awaits! event.bot
      end
      nil
    end

    private
    def send!(event)
      event.respond nil, false, @embed
    end

    def add_awaits!(bot)
      bot.add_await(:image_search_next, ReactionAddEvent, emoji: "▶") do |reaction|
        @message.delete_reaction(reaction.user.id, reaction.emoji.name)
        if reaction.user.id == @user.id && @index < @images.length - 1
          @index += 1
          update_embed!
          @message.edit nil, @embed
        end
        false
      end

      bot.add_await(:image_search_prev, ReactionAddEvent, emoji: "◀") do |reaction|
        @message.delete_reaction(reaction.user.id, reaction.emoji.name)
        if reaction.user.id == @user.id && @index > 0
          @index -= 1
          update_embed!
          @message.edit nil, @embed
        end
        false
      end
    end

    def add_reactions!
      @message.create_reaction("▶")
      @message.create_reaction("◀")
    end

    def update_embed!
      update_image!
      update_author!
      update_footer!
    end

    def update_footer!
      @embed.footer ||= EmbedFooter.new
      @embed.footer.text = "Page #{@index + 1}/#{@images.length} (#{@images.length} entries)"
    end

    def update_author!
      @embed.author ||= EmbedAuthor.new
      @embed.author.name = @user.name
      @embed.author.icon_url = @user.avatar_url
    end

    def update_image!
      @embed.image ||= EmbedImage.new
      @embed.image.url = @images[@index].link
    end

    def get_images(query)
      @service.list_cses(query, cx: @engine_id, search_type: 'image').items || []
    end
  end
end