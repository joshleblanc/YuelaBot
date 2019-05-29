module Commands
  class ImageSearch

    class << self
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

        service = Google::Apis::CustomsearchV1::CustomsearchService.new
        service.key = ENV['google']
        container = Lib::PaginatedContainer.new("Image Search Results", :image)
        container.set_data_routine do |query|
          images = service.list_cses(query, cx: ENV['search_id'], search_type: 'image').items || []
          images.map(&:link)
        end
        container.run(args.join(' '), event)
        nil
      end
    end
  end
end