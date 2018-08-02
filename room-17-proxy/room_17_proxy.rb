class Room17Proxy 
    include Discordrb::Webhooks

    def initialize(channel_id, room_id, user, pass)
        @roomid = room_id
        @base_url = "https://chat.stackoverflow.com"
        @channel_id = channel_id
        @user = user
        @pass = pass
        @history = []
    end

    def listen!
        Thread.new do
            run_websocket_loop
        end
    end

    def auth!
        cookies = login
        fkey = get_fkey('https://chat.stackoverflow.com', cookies)
        data = "roomid=#{@roomid}&fkey=#{fkey}"
        resp = RestClient.post("#{@base_url}/ws-auth", {
            roomid: @roomid,
            fkey: fkey
        }, {
            Origin: @base_url,
            Referer: "#{@base_url}/rooms/#{@roomid}",
            content_type: 'application/x-www-form-urlencoded',
            user_agent: "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/67.0.3396.99 Safari/537.36",
            "X-Requested-With" => "XMLHttpRequest",
            cookies: cookies
        }) do |resp, req, res|
            case resp.code
            when 301, 302, 307
                resp.follow_redirection
            else
                resp.return!
            end
        end
        @ws_url = JSON.parse(resp.body)['url']
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

    def run_websocket
        ws = Faye::WebSocket::Client.new("#{@ws_url}?l=99999999999", nil, { 
            headers: {
                "origin" => @base_url
            }    
        })
        ws.on :message do |msg|
            events = JSON.parse(msg.data)["r#{@roomid}"]['e']
            next unless events
            events.each do |e|
                p e['event_type']
                case e['event_type']
                when 1
                    handle_message(e)
                when 2
                    handle_edit(e)
                when 10
                    handle_delete(e)
                end
            end
        end

        ws.on(:open) { |e| p 'ws opened' }

        ws.on(:error) { |e| p e.data, e.code, e.reason }

        ws.on(:close) do |e| 
            p 'ws closed'
            sleep 3
            run_websocket
        end
    end

    def handle_message(e)
        return unless e['content']
        message = process_content(e['content'])
        last = @history.last
        sent_message = if last && last[:so_message]['user_id'] == e['user_id']
            BOT.send_message(@channel_id, message)
        else
            BOT.send_message(@channel_id, "**#{e['user_name']}**\n#{message}")
        end
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

    def run_websocket_loop
        EM.run do
            run_websocket            
        end
    end

    def login
        fkey = get_fkey('https://stackoverflow.com/users/login')
        resp = RestClient.post('https://stackoverflow.com/users/login', {
            fkey: fkey,
            email: @user,
            password: @pass
        }, {
            "Content-Type": "application/x-www-form-urlencoded"
        }) do |resp, req, res|
           case resp.code
            when 301, 302, 307
                resp.follow_redirection
            else
                resp.return!
            end 
        end       
        resp.cookie_jar
    end

    def get_fkey(path, cookies = nil)
        resp = RestClient.get(path, cookies: cookies) 
        Nokogiri::HTML(resp.body).at_css('input[name="fkey"]').attr('value')
    end
end