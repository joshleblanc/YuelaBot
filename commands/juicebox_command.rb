module Commands
  class JuiceboxCommand
    class << self
      
      def name
        :juicebox
      end
      
      def attributes
        {
          description: "Give someone a juicebox",
          usage: "!!juicebox",
          aliases: [:jb]
        }
      end

      def spoiler?(message)
        content_spoiler = message.content.match(/\|\|(.*)\|\|/)
        attachment_spoiler = message.attachments.any? { |a| a.filename.start_with? 'SPOILER_' }
        content_spoiler || attachment_spoiler
      end
      
      def command(event)
        return if event.from_bot?
        
        # Image could be an attachment, or in a rich embed, or in an auto embed
        image_url = nil
        image_message = nil
        event.channel.history(100).each do |message|
          message.embeds.each do |embed|
            p embed.type
            if embed.type == :image
              image_url = message.content
              image_message = message
              break
            elsif embed.type == :rich && embed.image
              image_url = embed.image.url
              image_message = message
              break
            end
          end
          break if image_url
          
          message.attachments.each do |attachment|
            if attachment.image?
              image_url = attachment.url
              image_message = message
              break
            end
          end
          break if image_url
        end
        
        return "No images found" unless image_url
        spoiler = spoiler?(image_message)
        if spoiler && spoiler.is_a?(String)
          image_url = spoiler[1]
        end
        response = RestClient::Request.execute(method: :get, url: "https://juiceboxify.me/api?url=#{CGI.escape(image_url)}", timeout: -1)
        
        # api returns an error as json if there's na error, otherwise just throws the file at you
        if response.headers[:content_type] == "application/json"
          error = JSON.parse(response)
          return error['error']
        else
          file = Tempfile.new(['juicebox', '.jpeg'])
          file.binmode
          file.write(response.body)
          file.rewind
          event.send_file file, spoiler: spoiler?(image_message)
          file.close
        end               
      end
    end
  end
end