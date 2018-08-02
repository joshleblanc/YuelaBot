class SoChat 
    def initialize(room_id, user, pass)
        @room_id = room_id
        @user = user
        @pass = pass
        @base_url = "https://chat.stackoverflow.com"
        @listeners = {}
    end

    def auth!
        cookies = login
        @ws_url = get_ws_url(cookies)
    end

    def on(type, &callback)
        @listeners[type] = callback
    end

    def run!
        EM.run do
            ws = Faye::WebSocket::Client.new("#{@ws_url}?l=99999999999", nil, { 
                headers: {
                    "origin" => @base_url
                }    
            })

            ws.on :message do |msg|
                events = JSON.parse(msg.data)["r#{@room_id}"]['e']
                next unless events
                events.each do |e|
                    p e['event_type']
                    case e['event_type']
                    when 1
                        @listeners[:message]&.call(e)
                    when 2
                        @listeners[:edit]&.call(e)
                    when 10
                        @listeners[:delete]&.call(e)
                    end
                end
            end

            ws.on(:open) { |e| p 'ws opened' }

            ws.on(:error) { |e| p e.data, e.code, e.reason }

            ws.on(:close) do |e| 
                p 'ws closed'
                sleep 3
                run!
            end
        end
    end

    private 

    def get_fkey(path, cookies = nil)
        resp = RestClient.get(path, cookies: cookies) 
        Nokogiri::HTML(resp.body).at_css('input[name="fkey"]').attr('value')
    end

    def get_ws_url(cookies)
        fkey = get_fkey(@base_url, cookies)
        data = "roomid=#{@room_id}&fkey=#{fkey}"
        resp = RestClient.post("#{@base_url}/ws-auth", {
            roomid: @room_id,
            fkey: fkey
        }, {
            Origin: @base_url,
            Referer: "#{@base_url}/rooms/#{@room_id}",
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
        JSON.parse(resp.body)['url']
    end

    def login
        url = 'https://stackoverflow.com/users/login'
        fkey = get_fkey(url)
        resp = RestClient.post(url, {
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
    
    
end