module Commands
  class RedditCommand
    class << self
      def name
        :reddit
      end

      def attributes
        {
            min_args: 1,
            max_args: 1,
            description: 'Returns a random thread from a given subreddit',
            usage: 'r[eddit] [subreddit]',
            aliases: [:r]
        }
      end

      def command(event, *args)
        return if event.from_bot?

        session = Redd.it(
            user_agent: 'Redd:YuelaBot (by /u/horizonshadow)',
            client_id: ENV['reddit_clientid'],
            secret: ENV['reddit_secret'],
            username: ENV['reddit_user'],
            password: ENV['reddit_pass']
        )
        post = session.subreddit(args[0]).hot(limit: 100).to_a.sample
        embed = Discordrb::Webhooks::Embed.new
        embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: post.author.name, url: "https://reddit.com/u/#{post.author.name}")
        p post.url

        if post.selftext.empty?
          image_url = URI.parse(post.url)
          http = Net::HTTP.new(image_url.host, image_url.port)
          http.use_ssl = (image_url.scheme == 'https')
          http.start do |http|
            if http.head(image_url.request_uri)['Content-Type']&.start_with? 'image'
              embed.image = Discordrb::Webhooks::EmbedImage.new(url: post.url)
            end
          end
        else
          if post.selftext.length > 2048
            embed.description = "#{post.selftext[0..2044]}..."
          else
            embed.description = post.selftext[0..2048]
          end
        end

        embed.color = '#00cc66'
        embed.title = post.title
        embed.url = post.url
        embed.timestamp = post.created_at
        embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: post.thumbnail)
        event.respond nil, false, embed
      end
    end
  end
end
