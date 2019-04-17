module Commands
    class PornhubCommand
      class << self
        def name
          :pornhub
        end

        def attributes
          {
            description: 'Searches pornhub for a video',
            usage: 'pornhub <query>',
            aliases: [:ph]
          }
        end

        def command(event, *args)
          return if event.from_bot?

          query = args.join(' ')

          resp = open("http://www.pornhub.com/webmasters/search?id=44bc40f3bc04f65b7a35&search=#{query}").read
          json = JSON.parse(resp)
          video = json['videos'].first
          if video
            video['url']
          else
           "Nothing found for #{query}"
          end
        end
      end
    end
  end
