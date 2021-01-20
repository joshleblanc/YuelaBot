module Commands
  class YoutubeCommand
    class << self
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
        response = service.list_searches('snippet', q: query, type: "video")
        video = response.items.first
        if video
          "https://www.youtube.com/watch?v=#{video.id.video_id}"
        else
          "No results found"
        end
      end
    end
  end
end