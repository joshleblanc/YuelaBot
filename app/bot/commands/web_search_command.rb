module Commands
  class WebSearchCommand
    class << self
      include Discordrb::Webhooks
      include Discordrb::Events

      def name
        :search
      end

      def attributes
        {
          min_args: 1,
          description: 'Searches the web for a given query',
          usage: 'search [query]',
          aliases: [:s, :web, :google]
        }
      end

      def command(event, *args)
        return if event.from_bot?

        query = args.join(' ')
        results = perform_web_search(query)

        if results.empty?
          return "No search results found for: #{query}"
        end

        # Format results for Discord
        output = "**Web Search Results for:** #{query}\n\n"
        results.first(3).each_with_index do |result, index|
          output << "**#{index + 1}.** [#{result[:title]}](#{result[:link]})\n"
          output << "#{result[:snippet]}\n\n"
        end

        output[...2000] # Ensure under Discord limit
      end

      private

      def perform_web_search(query)
        return [] unless ENV['GOOGLE'] && ENV['SEARCH_ID']

        begin
          service = Google::Apis::CustomsearchV1::CustomSearchAPIService.new
          service.key = ENV['GOOGLE']
          
          response = service.list_cses(
            q: query,
            cx: ENV['SEARCH_ID'],
            num: 5
          )

          (response.items || []).map do |item|
            {
              title: item.title,
              link: item.link,
              snippet: item.snippet
            }
          end
        rescue => e
          Rails.logger.error "Web search error: #{e.message}"
          []
        end
      end
    end
  end
end