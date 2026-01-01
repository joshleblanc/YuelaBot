class TextPaginationContainer
  include Discordrb::Webhooks
  include Discordrb::Events

  def initialize(text, event, max_length: 2000)
    @text = text
    @event = event
    @user = event.user
    @max_length = max_length
    @pages = split_text_into_pages(text, max_length)
    @current_page = 0
  end

  def send_paginated
    if @pages.length == 1
      # If only one page, send as reply
      if @event.respond_to?(:message)
        @event.message.reply(@pages.first)
      else
        @event.respond(content: @pages.first)
      end
      return
    end

    # Send first page with pagination
    send_current_page
    add_reactions
    add_awaits
  end

  private

  def split_text_into_pages(text, max_length)
    return [text] if text.length <= max_length

    pages = []
    current_page = ""
    
    # Split by paragraphs first (double newlines)
    paragraphs = text.split(/\n\s*\n/)
    
    paragraphs.each do |paragraph|
      # If adding this paragraph would exceed the limit
      if (current_page + "\n\n" + paragraph).length > max_length - 50 # Leave room for page indicator
        # Save current page if it has content
        if current_page.strip.length > 0
          pages << current_page.strip
          current_page = ""
        end
        
        # If the paragraph itself is too long, split by sentences
        if paragraph.length > max_length - 50
          sentences = paragraph.split(/(?<=[.!?])\s+/)
          sentences.each do |sentence|
            if (current_page + " " + sentence).length > max_length - 50
              if current_page.strip.length > 0
                pages << current_page.strip
                current_page = sentence
              else
                # Even a single sentence is too long, force split
                pages << sentence[0...(max_length - 50)]
                current_page = sentence[(max_length - 50)..-1] || ""
              end
            else
              current_page += (current_page.empty? ? "" : " ") + sentence
            end
          end
        else
          current_page = paragraph
        end
      else
        current_page += (current_page.empty? ? "" : "\n\n") + paragraph
      end
    end
    
    # Add the last page if it has content
    if current_page.strip.length > 0
      pages << current_page.strip
    end
    
    # Add page indicators
    pages.map.with_index do |page, index|
      if pages.length > 1
        "#{page}\n\n*Page #{index + 1}/#{pages.length}*"
      else
        page
      end
    end
  end

  def send_current_page
    page_content = @pages[@current_page]

    if @message
      @message.edit(page_content)
    else
      @message = @event.message.reply(page_content)
    end
  end

  def add_reactions
    return if @pages.length <= 1
    
    # Add reactions in a separate thread to avoid blocking
    Thread.new do
      Thread.current.abort_on_exception = true
      begin
        @message.create_reaction("⏮") if @pages.length > 2
        @message.create_reaction("◀")
        @message.create_reaction("▶")
        @message.create_reaction("⏭") if @pages.length > 2
        @message.create_reaction("❌") # Close pagination
      rescue => e
        Rails.logger.error "Failed to add pagination reactions: #{e.message}"
      end
    end
  end

  def add_awaits
    return if @pages.length <= 1
    
    emojis = {
      start: "⏮",
      back: "◀",
      next: "▶",
      end: "⏭",
      close: "❌"
    }
    
    loop do
      response = BOT.add_await!(ReactionAddEvent, timeout: 300) # 5 minute timeout
      break unless response
      next unless response.user.id == @user.id && response.message.id == @message.id
      
      Thread.new do
        begin
          case response.emoji.name
          when emojis[:start]
            @current_page = 0 unless @current_page == 0
          when emojis[:back]
            @current_page -= 1 if @current_page > 0
          when emojis[:next]
            @current_page += 1 if @current_page < @pages.length - 1
          when emojis[:end]
            @current_page = @pages.length - 1 unless @current_page == @pages.length - 1
          when emojis[:close]
            cleanup_and_exit
            break
          end
          
          if emojis.values.include?(response.emoji.name)
            if response.emoji.name == emojis[:close]
              break
            else
              send_current_page
              @message.delete_reaction(response.user.id, response.emoji.name)
            end
          end
        rescue => e
          Rails.logger.error "Error handling pagination reaction: #{e.message}"
        end
      end
    end
    
    cleanup_and_exit
  end

  def cleanup_and_exit
    begin
      @message.delete_all_reactions if @message
    rescue => e
      Rails.logger.error "Failed to remove pagination reactions: #{e.message}"
    end
  end
end