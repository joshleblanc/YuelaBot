module Commands
  class GifCommand
    class << self
      def name
        :gif
      end

      def attributes
        {
          description: "TODO: Describe the command",
          usage: "TODO: How to use the command",
          aliases: [:giphy, :tenor, :g]
        }
      end

      def command(event, *args)
        return if event.from_bot?

        response = RestClient.post("https://rightgif.com/search/web",  "text=#{args.join(' ')}")
        JSON.parse(response.body)["url"]
      end
    end
  end
end
