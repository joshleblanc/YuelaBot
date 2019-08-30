module Commands
  class ImageSearch
    class << self
      include Discordrb::Webhooks
      include Discordrb::Events

      def name
        :image
      end

      def attributes
        {
            min_args: 1,
            description: 'Searches google image for a given query',
            usage: 'image [query]',
            aliases: [:i, :img, :I]
        }
      end

      def command(event, *args)
        return if event.from_bot?

        query = args.join(' ')
        if query == '^'
          query = event.channel.history(2).last.content
        end

        engine_id = ENV['search_id']
        service = Google::Apis::CustomsearchV1::CustomsearchService.new
        service.key = ENV['google']
        images = service.list_cses(query, cx: engine_id, search_type: 'image').items || []

        pagination_container = PaginationContainer.new("Image Search Results", images, 1, event)
        pagination_container.paginate do |embed, index|
          embed.image ||= EmbedImage.new
          embed.image.url = images[index].link
        end
        nil
      end
    end
  end
end