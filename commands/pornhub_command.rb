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

          resp = open("http://www.pornhub.com/webmasters/search?search=#{query}").read
          json = JSON.parse(resp)
          video = json['videos'].first
          video['url']
        end
      end
    end
  end
