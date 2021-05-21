module Commands
  class YoutubeCommand
    class << self
      include Discordrb::Webhooks
      include Discordrb::Events

      def name
        :youtube
      end

      def attributes
        {
            min_args: 1,
            description: "Searches youtube for a video",
            usage: "youtube [query]",
            aliases: [:yt]
        }
      end

      def command(event, *args)
        return if event.from_bot?

        query = args.join(' ')
        service = Google::Apis::YoutubeV3::YouTubeService.new
        service.key = ENV['GOOGLE']
        response = service.list_searches('snippet', q: query, type: "video", max_results: 10)

        pagination_container = PaginationContainer.new("YouTube Results", response.items, 1, event)
        pagination_container.paginate do |embed, index|
          item = response.items[index]
          embed.author = EmbedAuthor.new(name: item.snippet.channel_title, url: "https://www.youtube.com/channel/#{item.snippet.channel_id}")
          embed.image = EmbedImage.new(url: item.snippet.thumbnails.high.url)
          embed.url = "https://www.youtube.com/watch?v=#{item.id.video_id}"
          embed.title = item.snippet.title
          embed.description = item.snippet.description
        end
        nil
      end
    end
  end
end