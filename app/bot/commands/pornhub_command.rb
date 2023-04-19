module Commands
    class PornhubCommand
      class << self
        include Helpers::Requests

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

             json = get_json("http://www.pornhub.com/webmasters/search?search=#{query}")
             video = json['videos'].first
             video['url'] 
          else
             "This command can only be used in a NSFW channel"
          end
        end
      end
    end
  end
