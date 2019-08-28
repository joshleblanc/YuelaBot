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

            def command(event)
                return if event.from_bot?
                
                # Image could be an attachment, or in a rich embed, or in an auto embed
                image_url = nil
                event.channel.history(100).each do |message|
                    message.embeds.each do |embed|
                        if embed.type == :image
                            image_url = message.content
                            break
                        elsif embed.type == :rich && embed.image
                            image_url = embed.image.url
                            break
                        end
                    end
                    break if image_url

                    message.attachments.each do |attachment|
                        if attachment.image?
                            image_url = attachment.url
                            break
                        end
                    end
                    break if image_url
                end
                
                return "No images found" unless image_url
                
                response = RestClient.get("https://juiceboxify.me/api?url=#{CGI.escape(image_url)}")
                file = Tempfile.new(['juicebox', '.jpeg'])
                file.binmode
                file.write(response.body)
                file.rewind
                event.send_file file
                file.close
            end
        end
    end
end