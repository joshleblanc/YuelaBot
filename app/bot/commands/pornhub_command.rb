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
            
          if event.channel.nsfw?
             query = args.join(' ')

             resp = open("http://www.pornhub.com/webmasters/search?search=#{query}").read
             json = JSON.parse(resp)
             video = json['videos'].first
             video['url'] 
          else
             "This command can only be used in a NSFW channel"
          end
        end
      end
    end
  end
