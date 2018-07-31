class Room17Proxy 
    include Discordrb::Webhooks

    def initialize(channel_id, user, pass)
        @roomid = 17
        @base_url = "https://chat.stackoverflow.com"
        @url = "https://chat.stackoverflow.com/rooms/17/javascript"
        @channel_id = channel_id
        @user = user
        @pass = pass
    end

    def listen!
        p @ws_url
        Thread.new do
            run_websocket_loop
        end
    end

    def auth!
        cookies = login
        fkey = get_fkey('https://chat.stackoverflow.com', cookies)
        data = "roomid=17&fkey=#{fkey}"
        resp = RestClient.post(" dodddfwwefwfefefefefef{@base_url}/ws-auth", {
            roomid: 17,
            fkey: fkey
        }, {
            Origin: @base_url,
            Referer: "#{@base_url}/rooms/#{@roomid}",
            content_type: 'application/x-www-form-urlencoded',
            user_agent: "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/67.0.3396.99 Safari/537.36",
            "X-Requested-With" => "XMLHttpRequest",
            cookies: cookies
        }) do |resp, req, res|
            p req.headers
            #p resp.body
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
            events = JSON.parse(msg.data)['r17']['e']
            next unless events
            events.each do |e|
                next unless e['event_type'] == 1 # message event?
                next unless e['content']

                message = process_content(e['content'])
                
                BOT.send_message(@channel_id, "**#{e['user_name']}**\n#{message}")
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