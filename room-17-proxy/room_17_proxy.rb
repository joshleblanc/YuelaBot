class Room17Proxy 
    include Discordrb::Webhooks

    def initialize(channel_id, room_id, user, pass)
        @so_chat = SoChat.new(room_id, user, pass)
        @channel_id = channel_id
        @history = []
    end

    def listen!
        Thread.new do
            @so_chat.auth!
            @so_chat.on :message, method(:handle_message)
            @so_chat.on :edit, method(:handle_edit)
            @so_chat.on :delete, method(:handle_delete)
            @so_chat.run!
        end
    end

    private

    def process_tag!(message, tag, repl1, repl2 = nil)
        repl2 = repl1 unless repl2
        message.gsub!(/<#{tag}.*?>/, repl1)
        message.gsub!(/<\/#{tag}>/, repl2)
    end

    def process_content(message)
        message = CGI.unescapeHTML(message)
        process_tag!(message, 'code', '`')
        process_tag!(message, 'pre', "```javascript\n", "```\n")
        process_tag!(message, 'i', '*')
        process_tag!(message, 'b', '**')
        process_tag!(message, 'strike', '~~')
        message
    end

    def handle_message(e)
        return unless e['content']
        message = process_content(e['content'])
        last = @history.last
        unless last && last[:so_message]['user_id'] == e['user_id']
            BOT.send_message(@channel_id, "**#{e['user_name']}**:")
        end
        sent_message = BOT.send_message(@channel_id, message)
        @history << {
            so_message: e,
            discord_message: sent_message
        }
    end

    def handle_edit(e)
        edited_message = @history.find { |h| h[:so_message]['message_id'] == e['message_id'] }
        return unless edited_message
        message = process_content(e['content'])
        edited_message[:discord_message] = edited_message[:discord_message].edit(message)
    end

    def handle_delete(e)
        deleted_message = @history.find { |h| h[:so_message]['message_id'] == e['message_id']}
        return unless deleted_message
        discord_message = deleted_message[:discord_message]
        content = discord_message.content
        deleted_message[:discord_message] = discord_message.edit("#{content} [deleted]")
    end
end