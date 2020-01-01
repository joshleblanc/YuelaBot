module Commands
  class SoProxyCommand
    class << self
      def name
        :so_proxy
      end

      def attributes
        {
          description: "Connects to a stackoverflow chatroom, and proxies it to a channel",
          usage: "so_chat <room_number>",
          aliases: []
        }
      end

      def command(event, *args)
        return if event.from_bot?
        room_id = args[0].to_i
        server = event.server
        config = SoChatProxyConfig.find_or_create_by(server_id: server.id)
        unless config.channel_id
          category_channel = server.create_channel("Stack Overflow Chats", 4)
          config.update(channel_id: category_channel.id)
        end
        so_chat_proxy = SoChatProxy.find_or_create_by(server_id: server.id, room_id: room_id)
        if so_chat_proxy.channel_id
          event.respond "Channel is already proxied. Do you want to delete it? (y/n)"
          response = event.user.await!
          if response.message.content.downcase == 'y'
            channel = server.channels.find { |c| c.id == so_chat_proxy.channel_id.to_i }
            channel.delete rescue p "Tried to delete a channel that didn't exist"
            SoChat.stop!(room_id, so_chat_proxy.channel_id)
            so_chat_proxy.destroy
          end
        else
          channel = server.create_channel("room#{room_id}", 0, parent: config.channel_id)
          so_chat_proxy.update(channel_id: channel.id)
          so_chat_proxy.listen!
          event.respond "Proxy created"
        end
        nil
      end
    end
  end
end
