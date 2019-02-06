class Room17Proxy 
    include Discordrb::Webhooks

    def initialize(channel_id, room_id, user, pass)
        @so_chat = SoChat.new(room_id, user, pass)
        @channel_id = channel_id
        @history = []
    end

    def listen!
        Thread.new do
            Thread.current.abort_on_exception = true
            begin 
                loop do
                    p 'authenticating'
                    @so_chat.auth!
                    @so_chat.on :message do |e|
                        next unless e['content']
                        if is_onebox?(e['content'])
                            handle_onebox(e)
                        else
                            handle_message(e)
                        end
                    end
                    @so_chat.on(:edit) { |e| handle_edit(e) }
                    @so_chat.on(:delete) { |e| handle_delete(e) }
                    @so_chat.run!
                end
            rescue RestClient::NotFound
                p "SO Chat authorization failed"
            end
        end
    end

    private

    def handle_tweet(html) 
        tweet_info = html.css('div.ob-tweet-info > a')
        BOT.send_message(@channel_id, tweet_info[1].attr('href'))
    end

    def handle_image(html)
        img_url = html.at_css('img').attr('src')
        BOT.send_message(@channel_id, "http:#{img_url}")
    end

    def handle_onebox(e)
        onebox = Nokogiri::HTML(e['content'])
        type = onebox.at_css('div.onebox').attributes['class'].value.split(' ')[1]
        case type
        when 'ob-tweet'
            handle_tweet(onebox)
        when 'ob-image'
            handle_image(onebox)
        end
    end

    def is_onebox?(message)
        !!Nokogiri::HTML(message).at_css('div.onebox')
    end

    def process_tag!(message, tag, repl1, repl2 = nil)
        repl2 = repl1 unless repl2
        message.gsub!(/<#{tag}.*?>/, repl1)
        message.gsub!(/<\/#{tag}>/, repl2)
    end

    def process_content(message)
        message = CGI.unescapeHTML(message)
        html = Nokogiri::HTML(message)
        if html.at_css('div')
            message = html.at_css('div').inner_html.gsub(' <br> ', "\n")
        end
        process_tag!(message, 'code', '`')
        process_tag!(message, 'pre', "```javascript\n", "```\n")
        process_tag!(message, 'i', '*')
        process_tag!(message, 'b', '**')
        process_tag!(message, 'strike', '~~')
        process_tag!(message, 'a', '')
        message
    end

    def handle_message(e)
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
        @history.shift if @history.length >= 100
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