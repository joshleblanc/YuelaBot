class Room17Proxy 
    include Discordrb::Webhooks

    def initialize(channel_id, user, pass)
        @roomid =17
        @base_url = "https://chat.stackoverflow.com"
        @url = "https://chat.stackoverflow.com/rooms/17/javascript"
        @channel_id = channel_id
        @user = user
        @pass = pass
    end

    def auth
        cookies = login
        fkey = get_fkey('', cookies)
        p cookies
        data = "fkey=#{fkey}&roomid=17"
        resp = RestClient.post("#{@base_url}/ws-auth", data, {
            Origin: @base_url,
            Referer: "#{@base_url}/rooms/#{@roomid}",
            "Content-Length": data.length,
            "Content-Type": 'application/x-www-form-urlencoded',
            cookies: cookies
        }) do |resp, req, res|
            case resp.code
            when 301, 302, 307
                resp.follow_redirection
            else
                resp.return!
            end
        end
        p resp
        # data = "roomid=17&fkey=#{@fkey}"
        # resp = RestClient.post("#{@base_url}/ws-auth", data, {
        #     Origin: @base_url,
        #     Referer: "#{@base_url}/rooms/#{@roomid}",
        #     "Content-Length": data.length,
        #     "Content-Type": 'application/x-www-form-urlencoded'
        # })
        # p resp
    end

    def run
        Thread.new do
            previous_ids = get_events.map { |e| e['message_id']}
            loop do
                events = get_events
                events.reject { |e| previous_ids.include? e['message_id'] }.each do |e|
                    next unless e['content']
                    message = CGI.unescapeHTML e['content']
                    message.gsub!('<code>', '`')
                    message.gsub!('</code>', '`')
                    message.gsub!(/<pre.*?>/, "```javascript\n")
                    message.gsub!('</pre>', "```\n")
                    BOT.send_message(@channel_id, "**#{e['user_name']}**\n#{message}")
                end
                previous_ids = events.map { |e| e['message_id']}
                sleep 20
            end
        end  
    end

    private
    def login
        fkey = get_fkey('users/login')
        p fkey, @user, @pass
        resp = RestClient.post('https://stackoverflow.com/users/login', {
            fkey: fkey,
            email: @user,
            password: @pass
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
        resp = RestClient.get("https://stackoverflow.com/#{path}", cookies: cookies)
        Nokogiri::HTML(resp.body).at_css('input[name="fkey"]').attr('value')
    end

    def get_events
        resp = RestClient.post 'https://chat.stackoverflow.com/chats/17/events', { fkey: @fkey, msgCount: 100, mode: 'Messages', since: 0}
        JSON.parse(resp.body)['events']
    end
end