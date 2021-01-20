module Commands
  class RandomImageCommand
    class << self
      def name
        :random_image
      end

      def attributes
        {
          description: "Spits out a random image from the channel",
          usage: "random_image",
          aliases: [:ri]
        }
      end

      def command(event, *args)
        return if event.from_bot?

        image = event.channel.history(100)
            .reject { |m| m.attachments.empty? }
            .map(&:attachments)
            .flatten
            .select(&:image?)
            .sample
        if image
          tempfile = Tempfile.new([File.basename(image.filename), File.extname(image.filename)])
          response = RestClient.get(image.proxy_url)
          File.write(tempfile.path, response.body, mode: "wb")
          event.channel.send_file(tempfile, caption: image.message.content)
        else
          "Couldn't find an image"
        end
      end
    end
  end
end
