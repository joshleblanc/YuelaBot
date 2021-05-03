module Reactions
  class TypescriptPlaygroundReaction
    class << self
      include Discordrb::Webhooks

      def regex
        /https?:\/\/(?:www\.)?(?:typescriptlang|staging-typescript)\.org\/(?:play|dev\/bug-workbench)(?:\/index\.html)?\/?(\??(?:\w+=[^\s#&]+)?(?:\&\w+=[^\s#&]+)*)#code\/([\w\-+_]+={0,4})/
      end

      def attributes
        {
          contains: regex
        }
      end

      def command(event)
        url = event.message.content.match(regex)[0]
        embed = Embed.new(
          color: "#007ACC",
          title: "Shortened Playground Link",
          author: EmbedAuthor.new(name: event.author.name, icon_url: event.author.avatar_url),
          url: url
        )
        if url == event.message.content
          event.send_embed nil, embed
          event.message.delete
        else
          event.send_embed "#{event.author.mention} Here's a shortened URL of your playground link! You can remove the full link from your message.", embed
        end
      end
    end
  end
end
