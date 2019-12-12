module Commands
  class MdnCommand
    class << self
      include Discordrb::Webhooks

      def name
        :mdn
      end

      def attributes
        {
          description: "Search mdn",
          usage: "mdn <search query>",
          min_args: 1
        }
      end

      def command(event, *args)
        query = args.join(' ')
        url = "https://developer.mozilla.org/en-US/search.json"
        response = RestClient.get("#{url}?q=#{query}&highlight=false")
        json = JSON.parse(response.body)
        documents = json['documents']
        if documents.empty?
          return "Nothing found"
        end
        pagination_container = PaginationContainer.new("MDN Search Results", documents, 1, event)
        pagination_container.paginate do |embed, index|
          document = documents[index]
          embed.title = document['title']
          embed.description = document['excerpt']
          embed.url = "https://developer.mozilla.org/en-US/#{document['slug']}"
        end
        nil
      end
    end
  end
end