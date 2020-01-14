class SoChat
  include Discordrb::Webhooks

  attr_reader :room_id, :channel_id, :meta

  class << self
    def cookies
      @cookies ||= {}
    end

    def all
      ObjectSpace.each_object(self).to_a
    end

    def get(room_id, channel_id, meta = false)
      all.select { |s| s.room_id == room_id && s.channel_id == channel_id && meta == meta }
    end

    def stop!(room_id, channel_id, meta)
      all.select { |sc| sc.room_id == room_id && sc.channel_id == channel_id && sc.meta == meta }.each(&:stop!)
    end

    def send_message(msg, room, cookie)
      url = cookie.url
      new_message_url = "#{url}/chats/#{room}/messages/new"
      cookie_jar = make_cookie_jar(cookie)
      chat_resp = RestClient.get("#{url}/rooms/#{room}", cookies: cookie_jar)
      fkey = Nokogiri::HTML(chat_resp.body).at_css('input[name="fkey"]').attr('value')
      p "https://chat.stackoverflow.com/chats/1/messages/new"
      p new_message_url
      resp = RestClient.post(new_message_url, {
          text: msg,
          fkey: fkey
      },
          Origin: url,
          Referer: "#{url}/rooms/#{room}",
          "Content-Type" => 'application/x-www-form-urlencoded',
          user_agent: "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/67.0.3396.99 Safari/537.36",
          "X-Requested-With" => "XMLHttpRequest",
          cookies: chat_resp.cookie_jar,
          "Accept" => "application/json, text/javascript, */*; q=0.01",
          "Accept-Encoding" => "gzip, deflate, br",
          "Accept-Language": "en-US,en;q=0.9",
          "Sec-Fetch-Site": "same-origin",
          "Sec-Fetch-Mode": "cors",
          "Pragma": "no-cache"
      )

      p resp
    end

    def login_url(meta = false)
      if meta
        "https://meta.stackexchange.com/users/login"
      else
        "https://stackoverflow.com/users/login"
      end
    end

    def base_url(meta = false)
      if meta
        "https://chat.meta.stackexchange.com"
      else
        "https://chat.stackoverflow.com"
      end
    end

    def make_cookie_jar(cookie)
      p "Found cached cookie"
      io = StringIO.new
      io.write cookie.cookie
      io.rewind
      Http::CookieJar.new.load(io)
    end

    def get_cookie_by_user_id(id, meta)
      so_chat_cookie = SoChatCookie.find_by(user_id: id, url: base_url(meta))
      make_cookie_jar(so_chat_cookie) if so_chat_cookie
    end

    def get_cookie_by_email(email, meta)
      so_chat_cookie = SoChatCookie.find_by(email: email, url: base_url(meta))
      make_cookie_jar(so_chat_cookie) if so_chat_cookie
    end

    def get_fkey(url, cookies = nil)
      resp = RestClient.get(url, cookies: cookies)
      Nokogiri::HTML(resp.body).at_css('input[name="fkey"]').attr('value')
    end

    def login(email, pass, meta)
      fkey = SoChat.get_fkey(login_url(meta))
      resp = RestClient.post(login_url(meta), {
          fkey: fkey,
          email: email,
          password: pass
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
      io = StringIO.new
      resp.cookie_jar.each do |c|
        c.expires = c.expires + 60 * 60 * 24 * 365 * 100
      end
      raise StandardError.new("Not Authorized") unless resp.cookies['uauth']
      resp.cookie_jar.save(io)
      io.rewind
      cookie = SoChatCookie.find_or_initialize_by(email: email, url: base_url(meta))
      cookie.cookie = io.read
      cookie.save
      resp.cookie_jar
    end
  end

  def initialize(channel_id, room_id, user, pass, meta = false)
    @room_id = room_id
    @channel_id = channel_id
    @user = user
    @pass = pass
    @meta = meta
    @listeners = {}
    @history = []
  end

  def stop!
    @thread.terminate if @thread
  end

  def send_disconnection_alert
    BOT.send_message(@channel_id, "Connection lost. Trying to reconnect...")
  end

  def listen!
    stop!
    @thread = Thread.new do
      Thread.current.abort_on_exception = true
      p 'authenticating'
      auth!
      BOT.send_message(@channel_id, "Connected!")
      on :message do |e|
        next unless e['content']
        if is_onebox?(e['content'])
          handle_onebox(e)
        else
          handle_message(e)
        end
      end
      on(:edit) { |e| handle_edit(e) }
      on(:delete) { |e| handle_delete(e) }
      run!
    end
  end

  private

  def send_embed(embed)
    begin
      BOT.send_message(@channel_id, nil, nil, embed)
    rescue
      p "Failed to send message", embed
    end
  end

  def handle_onebox(e)
    onebox = Nokogiri::HTML(e['content'])
    type = onebox.at_css('div.onebox').attributes['class'].value.split(' ')[1]
    embed = create_embed(e)
    case type
    when 'ob-tweet'
      tweet_info = onebox.css('div.ob-tweet-info > a')
      href = tweet_info[1].attr('href')
      embed.description = href
    when 'ob-image'
      img_url = onebox.at_css('img').attr('src')
      embed.image = EmbedImage.new(url: img_url)
    when 'ob-message'
      href = onebox.css('div.ob-message > a').attr('href').value
      embed.description = "#{base_url}#{href}"
    else
      embed.description = "A onebox was sent, but I don't know how to handle it. (#{type})"
    end
    send_embed(embed)
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
    message.gsub! "&gt;", ">"
    message
  end

  def create_embed(e)
    embed = Embed.new
    embed.author = EmbedAuthor.new(
        name: e['user_name'],
        url: "https://chat.stackoverflow.com/users/#{e['user_id']}/cereal"
    )
    embed.timestamp = Time.at(e['time_stamp'])
    embed.url = "#{SoChat.base_url(@meta)}/transcript/message/#{e['message_id']}"
    embed.title = e['room_name']
    embed
  end

  def handle_message(e)
    message = process_content(e['content'])

    embed = create_embed(e)
    embed.description = message
    sent_message = send_embed(embed)
    @history << {
        so_message: e,
        discord_message: sent_message,
        embed: embed
    }
    @history.shift if @history.length >= 100

  end

  def edit_embed(message, embed)
    begin
      message.edit(nil, embed)
    rescue
      p "Failed to edit embed"
    end
  end

  def handle_edit(e)
    edited_message = @history.find { |h| h[:so_message]['message_id'] == e['message_id'] }
    return unless edited_message
    message = process_content(e['content'])
    embed = edited_message[:embed]
    embed.description = message
    embed.footer = EmbedFooter.new(text: "[edited]")
    edited_message[:discord_message] = edit_embed(edited_message[:discord_message], embed)
  end

  def handle_delete(e)
    deleted_message = @history.find { |h| h[:so_message]['message_id'] == e['message_id'] }
    return unless deleted_message
    discord_message = deleted_message[:discord_message]
    embed = deleted_message[:embed]
    embed.footer = EmbedFooter.new(text: "[deleted]")
    deleted_message[:discord_message] = edit_embed(discord_message, embed)
  end

  def auth!
    begin
      cookies = login
      @ws_url = get_ws_url(cookies)
    rescue RestClient::NotFound => e
      p "SO Chat authorization failed"
      p e.message
      send_disconnection_alert
      auth!
    end
  end

  def on(type, &callback)
    @listeners[type] = callback
  end

  def run!
    EM.run do
      inner_run
    end
  end

  private

  def inner_run
    ws = Faye::WebSocket::Client.new("#{@ws_url}?l=99999999999", nil, {
        headers: {
            "origin" => SoChat.base_url(@meta)
        }
    })

    ws.on :message do |msg|
      events = JSON.parse(msg.data)["r#{@room_id}"]['e']
      next unless events
      events.each do |e|
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

    ws.on(:open) do |e|
      p 'ws opened'
    end

    ws.on(:error) do |e|
      p 'ws error'
      p e.data, e.code, e.reason
    end

    ws.on(:close) do |e|
      p 'ws closed', e
      send_disconnection_alert
    end
  end

  def get_ws_url(cookies)
    fkey = SoChat.get_fkey(SoChat.base_url(@meta), cookies)
    resp = RestClient.post("#{SoChat.base_url(@meta)}/ws-auth", {
        roomid: @room_id,
        fkey: fkey
    }, {
        Origin: SoChat.base_url(@meta),
        Referer: "#{SoChat.base_url(@meta)}/rooms/#{@room_id}",
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
    p "Logging in..."
    so_chat_cookie = SoChat.get_cookie_by_email(@user, @meta)
    return so_chat_cookie if so_chat_cookie
    p "No cached cookie found, creating..."
    SoChat.login(@user, @pass, @meta)
  end
end