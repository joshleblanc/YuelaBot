module Commands
  class Random4ChanCommand
    class << self
      def name
        :'4chan'
      end

      def attributes
        {
            min_args: 1,
            max_args: 1,
            description: 'Prints a random post from the selected 4chan board',
            usage: '4chan [board]'
        }
      end

      def command
        lambda do |event, *args|
          Random4ChanCommand.new(args[0]).run(event)
        end
      end
    end

    def initialize(board)
      @board = Fourchan::Kit::Board.new board
    end

    def run(event)
      res = @board.posts(1).sample
      embed = Discordrb::Webhooks::Embed.new(color: '#cc0066')
      author = Discordrb::Webhooks::EmbedAuthor.new(name: res.name)
      image = Discordrb::Webhooks::EmbedImage.new(url: res.image_link)
      footer = Discordrb::Webhooks::EmbedFooter.new(text: res.now)
      text = res.com
      if text
        text = text.gsub('<br>', "\n")
        text = text.split(/<a href=".*" class="quotelink">&gt;&gt;.*\/a>/).delete_if(&:empty?).first
        quotes = text.scan(/<span class="quote">&gt;.*?<\/span>/)
        num = quotes.length
        quotes.flatten.each do |quote|
          text.delete!(quote)
          embed.add_field(name: '>' * num, value: quote.sub(/<span class="quote">&gt;(.*)<\/span>/, Nokogiri::HTML.parse("\\1").text))
          num -= 1
        end
        embed.add_field(name: '-', value: Nokogiri::HTML.parse(text).text) unless text.strip.empty?
      end
      embed.image = image unless image.url.nil?
      embed.author = author
      embed.footer = footer
      event.respond nil, false, embed
      nil
    end
  end
end